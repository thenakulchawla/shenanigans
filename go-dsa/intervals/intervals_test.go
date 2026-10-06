package intervals

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestSortIntervals(t *testing.T) {

	t.Run("basic input", func(t *testing.T) {

		nums := [][]int{
			{5, 7},
			{1, 2},
			{10, 18},
			{3, 4},
		}

		output := [][]int{
			{1, 2},
			{3, 4},
			{5, 7},
			{10, 18},
		}

		require.Equal(t, output, sortIntervals(nums))
	})
}
