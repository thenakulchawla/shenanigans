package reverse

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestReverseArray(t *testing.T) {

	inp := []int{1, 2, 3}
	err := reverseArrayInplace(inp)
	require.Nil(t, err)
	require.Equal(t, inp, []int{3, 2, 1})
}

func TestReverseNum(t *testing.T) {
	inp := 75
	rev, err := reverseNum(inp)
	require.Nil(t, err)
	require.Equal(t, rev, 57)
}
