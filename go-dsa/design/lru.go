// Package lru package for lru cache
package design

import (
	"errors"
	"fmt"
)

var (
	// ErrkeyDoesnotExist is the error when key doesnot exist
	ErrkeyDoesnotExist = errors.New("lrucache: key doesn't exist")
)

// Node for a double linked list
// that holds a key value pair
type Node struct {
	key  int
	val  int
	next *Node
	prev *Node
}

// DLinkedList double linked list
type DLinkedList struct {
	head *Node
	tail *Node
}

// Cache for storing a LRU cache
type Cache struct {
	capacity int
	items    map[int]*Node
	history  DLinkedList
}

// NewNode returns a new node
func NewNode(key int, val int) *Node {
	return &Node{
		key: key,
		val: val,
	}
}

// NewLRUCache returns a new lru cache
func NewLRUCache(capacity int) *Cache {
	it := make(map[int]*Node)
	return &Cache{
		capacity: capacity,
		items:    it,
	}
}

// Unlink a node in a doubly linked list
func (dll *DLinkedList) Unlink(node *Node) {

	if node == nil {
		return
	}

	prevItem := node.prev
	nextItem := node.next

	if prevItem != nil {
		prevItem.next = nextItem
	}

	if nextItem != nil {
		nextItem.prev = prevItem
	}

	if node == dll.head {
		dll.head = nextItem
	}

	if node == dll.tail {
		dll.tail = prevItem
	}

	node.next = nil
	node.prev = nil
}

// AddToHead adds the node to the head
func (dll *DLinkedList) AddToHead(node *Node) {
	if dll.head != nil {
		node.next = dll.head
		dll.head.prev = node
	}

	if dll.tail == nil {
		dll.tail = node
	}

	dll.head = node
}

func (cache *Cache) evictLRU() {
	lruItem := cache.history.tail

	if lruItem == nil {
		return
	}

	cache.removeItem(lruItem)
}

func (cache *Cache) removeItem(node *Node) {
	cache.history.Unlink(node)
	delete(cache.items, node.key)
}

func (cache *Cache) get(key int) (int, error) {
	node, ok := cache.items[key]
	if !ok {
		return -1, ErrkeyDoesnotExist
	}

	if cache.history.head != node {
		cache.history.Unlink(node)
		cache.history.AddToHead(node)
	}

	return node.val, nil
}

func (cache *Cache) put(key int, val int) {

	node, ok := cache.items[key]
	// node exists and just needs to be moved to front.
	if ok {
		cache.history.Unlink(node)
		cache.history.AddToHead(node)
		return
	}

	// if node does not exist
	node = NewNode(key, val)
	if cache.capacity == len(cache.items) {
		cache.evictLRU()
	}

	cache.history.AddToHead(node)
	cache.items[key] = node
}

func (cache *Cache) print() {
	curr := cache.history.head

	for curr != nil {
		fmt.Printf("key %d, val %d\n", curr.key, curr.val)
		curr = curr.next
	}
}
