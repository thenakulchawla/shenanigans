package queue

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestQueue(t *testing.T) {

	t.Run("random", func(t *testing.T) {
		require.NoError(t, tryList())
	})
}
