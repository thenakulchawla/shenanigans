# Lamport Clocks <br />

## Python implementation of lamport clocks over 3 virtual machines. <br />

The idea is abstracted through a game.
The Chinese Red Envelope game. Here each VM sends random amount of money to the other machines.
The VM that receives the message first should be able to access the money.

All the signals sent by nodes are logged  <br />
in the log files of each VM.

The messages are described below:

1. "MON" : Money in the red envelope.
2. "ACK" : Acknowledgement after the first message is received.
3. "REQ" : Message to request claiming the resource from other nodes.
4. "REL" : Message to release the resource.
5. "WIN" : Message that the node has claimed the money in the envelope. 

