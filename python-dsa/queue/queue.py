

class QNode:

    def __init__(self, val=0):
        self.next = None
        self.prev = None
        self.val = val

class Qqueue:

    def __init__(self):
        self.head = None
        self.tail = None
        self.size = 0

    def add(self, value):
        new_node = QNode(value)

        if self.size == 0:
            self.head = new_node
            self.tail = new_node
            self.size = 1
        else:
            self.tail.next = new_node
            self.tail = new_node
            self.size += 1

    def popleft(self):

        if self.size == 0:
            return None

        to_return = self.head
        self.head = self.head.next
        self.size -= 1

        return to_return

    def pop(self):

        if self.size == None:
            return None

        to_return = self.tail

        if self.tail.prev:
            self.tail = self.tail.prev
            self.size -= 1

        return to_return


if __name__=="__main__":

    q = Qqueue()

    q.add(1)
    q.add(2)

    ans = q.popleft()
    print(ans.val)
    ans = q.popleft()
    print(ans.val)
    n = q.popleft()
    print(n)







