package linkedlist

// Node is a node in a linked list
type Node struct {
	Value int
	Next  *Node
}

func reverse(head *Node) *Node {
	var prev *Node
	curr := head
	next := head.Next

	for curr != nil {
		next = curr.Next
		curr.Next = prev
		prev = curr
		curr = next
	}

	return prev
}
