package arrays

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestBinarySearch(t *testing.T) {

	numbers := make([]int, 100)
	for i := range numbers {
		numbers[i] = i + 1
	}

	t.Run("pass", func(t *testing.T) {
		require.Equal(t, binarySearch(5, numbers), 4)

	})

}

func TestSomething(t *testing.T) {
	something()
}
