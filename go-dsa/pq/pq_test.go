package pq

import (
	"container/heap"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestMinHeap(t *testing.T) {

	nums := &IntHeap{3, 4, 5, 1, 2, 6}

	heap.Init(nums)
	least := heap.Pop(nums)

	require.Equal(t, least, 1)
}

func TestMinKElements(t *testing.T) {
	numsSlice := []int{8, 9, 10, 1000, 1, 2, 3, 656, 565, 455}
	h := IntHeap(numsSlice)
	nums := &h

	heap.Init(nums)
	var res []int
	for i := 0; i < 3; i++ {
		res = append(res, heap.Pop(nums).(int))
	}

	require.Equal(t, []int{1, 2, 3}, res)

}
