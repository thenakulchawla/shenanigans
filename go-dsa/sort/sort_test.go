package sort

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestSelectionSort(t *testing.T) {

	input := []int{4, 3, 2, 1}
	out, err := selectionSort(input)
	require.Nil(t, err)
	require.Equal(t, []int{1, 2, 3, 4}, out)
}

func TestMergeSort(t *testing.T) {

	t.Run("random", func(t *testing.T) {
		nums := []int{1, 4, 5, 3, 2, 6}
		ans := []int{1, 2, 3, 4, 5, 6}
		require.Equal(t, mergesort(nums), ans)
	})
}
