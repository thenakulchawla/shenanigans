

class Node:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next


class LinkedList:

    # Function to initialize head
    def __init__(self):
        self.head = None


def remove_duplicates(head):
    prev = head

    while prev and prev.next:

        if prev.val == prev.next.val:
            prev.next = prev.next.next
        else:
            prev = prev.next

    print_list(head)


def print_list(head):

    some = head
    while some:
        print(some.val)
        some = some.next


if __name__=='__main__':
    llist = LinkedList()
    llist.head = Node(1)
    second = Node(1)
    third = Node(2)
    fourth = Node(2)

    llist.head.next = second
    second.next = third
    third.next = fourth

    remove_duplicates(llist.head)

    # print_list(llist.head)



