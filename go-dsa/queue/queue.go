package queue

import (
	"container/list"
	"fmt"
)

func tryList() error {
	l := list.New()

	l.PushBack(1)
	l.PushBack(2)

	fmt.Printf("value at back %d\n", l.Back().Value)
	fmt.Printf("value at front %d\n", l.Front().Value)
	return nil

}
