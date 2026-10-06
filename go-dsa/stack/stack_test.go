package stack

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestSimplifyPath(t *testing.T) {

	t.Run("with extra slash", func(t *testing.T) {
		path := "/home/something/.../../////./Pictures"
		ans := "/home/something/Pictures"
		require.Equal(t, ans, simplifyPath(path))
	})
}
