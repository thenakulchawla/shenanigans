package design

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestLRUCache(t *testing.T) {

	testCache := NewLRUCache(3)
	testCache.put(0, 0)
	testCache.put(1, 1)
	testCache.put(2, 2)
	testCache.get(0)
	testCache.print()

	require.Equal(t, testCache.capacity, len(testCache.items))
}

func TestLRUCache1(t *testing.T) {

	t.Run("base test", func(t *testing.T) {
		lru := NewLRUCache(3)
		_, err := lru.get(1)
		require.Error(t, err, ErrkeyDoesnotExist)

		lru.put(1, 1)
		val, err := lru.get(1)
		require.NoError(t, err)
		require.Equal(t, val, 1)

	})

	t.Run("print lru", func(t *testing.T) {
		lru := NewLRUCache(5)
		lru.put(1, 1)
		lru.put(2, 3)
		lru.put(3, 5)
		lru.put(4, 6)
		lru.put(7, 8)

		// lru.Print()
		lru.get(1)
		lru.print()
	})

}
