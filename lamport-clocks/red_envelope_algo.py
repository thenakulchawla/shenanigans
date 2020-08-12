from threading import Thread
from socket import *
import sys
import logging
import random
from multiprocessing import Manager, Value
import uuid
import time
from sets import Set

# Setting logger https://docs.python.org/2/library/logging.html
logging_file = gethostname()+".out"
logging.basicConfig(filename = logging_file, 
                    format='%(asctime)s,%(msecs)d %(name)s %(levelname)s %(message)s',
                    datefmt='%H:%M:%S', level=logging.DEBUG)
logger = logging.getLogger(__name__)
logging.debug("================WECHAT CHINESE ENVELOPE GAME===============")

# Global vars
NUM_PEERS = 2
ack_count = {}
req_res = {}
completed_requests = Set()
might_win = Set()

def generate_money(timestamp):
    # Reference: https://stackoverflow.com/questions/22878625/receiving-broadcast-packets-in-python
    sock1 = socket(AF_INET, SOCK_DGRAM)
    sock1.setsockopt(SOL_SOCKET, SO_BROADCAST, 1)
    # Assumption that max money to be sent is 200 bucks
    for i in range(0,1000):
        money = str(random.randint(1,200))
        ID = str(uuid.uuid4())
        set_clock_for_send(timestamp)
        packet = ID+"|"+gethostname()+"|"+money+"|"+str(timestamp.value)+"|MON"
        debug_msg = "Sending red envelope | REQUEST ID - "+ID+" | SENDER - "+gethostname()+" | AMOUNT- "+money+" TIMESTAMP "+ str(timestamp.value)
        sock1.sendto(packet, ('255.255.255.255', 8586))
        logging.debug(debug_msg)
        time.sleep(2)
        i=i+1


def set_clock_for_receive(recvd_timestamp, timestamp):
    timestamp.value = max(int(recvd_timestamp), timestamp.value)+1

def set_clock_for_send(timestamp):
    timestamp.value = timestamp.value+1

def expired_envelope(req_id):
    if req_id in completed_requests:
        return True
    return False

def envelope_claimed(req_id):
    completed_requests.add(req_id)

def is_ack_complete(list1):
    return len(set(list1)) == NUM_PEERS

def open_envelope(req_id, host, money, recvd_timestamp, timestamp, sock):
    time.sleep(random.random()*random.randint(1,10))
    if expired_envelope(req_id):
        logging.debug("Host: "+gethostname()+" can't get the money since the envelope has already been opened")
        return
    set_clock_for_receive(recvd_timestamp, timestamp)
    set_clock_for_send(timestamp)
    t = str(timestamp.value)
    packet = req_id+"|"+gethostname()+"|"+money+"|"+t+"|"+"REQ"
    sock.sendto(packet, ('255.255.255.255', 8586))
    if req_id not in req_res:
        req_res[req_id] = gethostname()+"|"+money+"|"+t
    debug_msg = gethostname()+ " wants to open the envelope | REQUEST ID - "+req_id+" | SENDER- "+host+" | AMOUNT- "+money+" TIMESTAMP- "+ t
    logging.debug(debug_msg)
    


def approve(req_id, host, money, recvd_timestamp, timestamp, sock):
    set_clock_for_receive(recvd_timestamp, timestamp)
    if req_id not in req_res:
        req_res[req_id] = host+"|"+money+"|"+str(timestamp.value)
    set_clock_for_send(timestamp)
    t = str(timestamp.value)
    packet = req_id+"|"+gethostname()+"|"+money+"|"+t+"|"+"ACK"
    sock.sendto(packet,(host, 8586))
    debug_msg = "Sending ACK message | REQUEST ID - "+req_id+" | SENDER- "+gethostname()+" | CLAIMER- "+host+" | AMOUNT- "+money+"| TIMESTAMP- "+t
    logging.debug(debug_msg)



def receive_ack(req_id, host, money, recvd_timestamp, timestamp, sock):
    set_clock_for_receive(recvd_timestamp, timestamp)
    t = str(timestamp.value)
    logging.debug("Receiving ACK message | REQUEST ID - "+req_id+" | SENDER- "+host+" | AMOUNT - "+money+" | TIMESTAMP- "+t)
    if req_id not in ack_count:
        ack_count[req_id] = []

    ack_count[req_id].append(host)
    if is_ack_complete(ack_count[req_id]):
        request_release(req_id, host, money, recvd_timestamp, timestamp, sock)

def request_release(req_id, host, money, recvd_timestamp, timestamp, sock):
    if expired_envelope(req_id):
        return
    set_clock_for_send(timestamp)
    t = str(timestamp.value)
    packet = req_id+"|"+gethostname()+"|"+money+"|"+t+"|"+"REL"
    sock.sendto(packet,('255.255.255.255', 8586))
    debug_msg = "Sending Release resource message | REQUEST ID - "+req_id+" | SENDER- "+gethostname()+" | CLAIMER- "+host+" | AMOUNT-"+money+"| TIMESTAMP- "+t
    logging.debug(debug_msg)


def release(req_id, host, money, recvd_timestamp, timestamp, sock):
    set_clock_for_receive(recvd_timestamp, timestamp)
    if req_id in req_res:
        first_packet = req_res[req_id]
        packet_host = first_packet.split("|")[0]
        if (packet_host == host):
            logging.debug("Received envelope money| REQUEST ID - "+req_id+" | AMOUNT - "+ money+"| RECEIVER - "+ host)
            set_clock_for_send(timestamp)
            t = str(timestamp.value)
            packet = req_id+"|"+gethostname()+"|"+money+"|"+t+"|"+"WIN"
            sock.sendto(packet,(host, 8586))
        if req_id in req_res:
            del req_res[req_id]
        envelope_claimed(req_id)


def print_win_msg(req_id, host, money, recvd_timestamp, timestamp, sock):
    set_clock_for_receive(recvd_timestamp, timestamp)
    if req_id in might_win:
        return
    logging.debug("Received envelope money| REQUEST ID - "+req_id+" | AMOUNT - "+ money+"| RECEIVER - "+ gethostname())
    if req_id in req_res:
        del req_res[req_id]
    might_win.add(req_id) 

def listen_to_packets(timestamp):
    sock2 = socket(AF_INET, SOCK_DGRAM)
    sock2.setsockopt(SOL_SOCKET, SO_BROADCAST, 1)
    sock2.bind(('', 8586))
  
    while True:
        packet = sock2.recvfrom(2048)[0]
        ID, HOST, MONEY, TIME, TYPE = packet.split("|")
        if (HOST == gethostname()):
            continue
        if TYPE == "MON":
            Thread(target=open_envelope,args=(ID, HOST, MONEY, TIME, timestamp, sock2,)).start()
        elif TYPE == "ACK":
            receive_ack(ID, HOST, MONEY, TIME, timestamp, sock2)
        elif TYPE == "REQ":
            approve(ID, HOST, MONEY, TIME, timestamp, sock2)
        elif TYPE == "REL":
            release(ID, HOST, MONEY, TIME, timestamp, sock2)
        elif TYPE == "WIN":
            print_win_msg(ID, HOST, MONEY, TIME, timestamp, sock2)
    
def main():
    manager = Manager()
    timestamp = manager.Value('i', 0)
    # Process to generate red envelopes
    Thread(target=generate_money,args=(timestamp,)).start()
    listen_to_packets(timestamp)


if __name__ == "__main__":
    main()
