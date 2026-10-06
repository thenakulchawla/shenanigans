package random

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestSplitMessage(t *testing.T) {

	t.Run("example1", func(t *testing.T) {

		input := "this is really a very awesome message"
		limit := 9

		output := []string{"thi<1/14>", "s i<2/14>", "s r<3/14>", "eal<4/14>", "ly <5/14>",
			"a v<6/14>", "ery<7/14>", " aw<8/14>", "eso<9/14>", "me<10/14>", " m<11/14>", "es<12/14>",
			"sa<13/14>", "ge<14/14>"}

		require.Equal(t, output, splitMessage(input, limit))

	})

	t.Run("example2", func(t *testing.T) {
		input := "short message"
		output := []string{"short mess<1/2>", "age<2/2>"}

		require.Equal(t, output, splitMessage(input, 15))
	})

	t.Run("example 3", func(t *testing.T) {
		input := "abbababbbaaa aabaa a"
		output := []string{"abb<1/7>", "aba<2/7>", "bbb<3/7>",
			"aaa<4/7>", " aa<5/7>", "baa<6/7>", " a<7/7>"}

		require.Equal(t, output, splitMessage(input, 8))
	})

	t.Run("example 4", func(t *testing.T) {
		input := "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"
		output := []string{"zzzzz<1/9>", "zzzzz<2/9>", "zzzzz<3/9>",
			"zzzzz<4/9>", "zzzzz<5/9>", "zzzzz<6/9>", "zzzzz<7/9>", "zzzzz<8/9>", "zz<9/9>"}

		require.Equal(t, output, splitMessage(input, 10))
	})

}

func TestCheckParts(t *testing.T) {
	t.Run("something true", func(t *testing.T) {
		require.True(t, checkParts2(37, 14, 9))
	})

	t.Run("something false", func(t *testing.T) {
		require.False(t, checkParts2(37, 17, 9))
		require.False(t, checkParts2(37, 12, 9))
	})

	t.Run("generic", func(t *testing.T) {
		require.True(t, generic())
	})
}

func TestGetParts(t *testing.T) {

	t.Run("example1", func(t *testing.T) {

		input := "this is really a very awesome message"
		limit := 9

		require.Equal(t, 14, getParts(len(input), limit))

	})

}
