package graph

import (
	"fmt"
	"testing"

	"github.com/stretchr/testify/require"
)

func getGraph() []Edge {
	numEdges := 6
	edges := make([]Edge, numEdges)
	edges[0] = Edge{Weight: 1, To: 1, From: 0}
	edges[1] = Edge{Weight: 2, To: 2, From: 0}
	edges[2] = Edge{Weight: 3, To: 3, From: 0}
	edges[3] = Edge{Weight: 4, To: 4, From: 0}
	edges[4] = Edge{Weight: 5, To: 1, From: 2}
	edges[5] = Edge{Weight: 6, To: 3, From: 2}

	return edges
}

func TestNumVertices(t *testing.T) {
	g := getGraph()
	t.Run("calculate vertices", func(t *testing.T) {
		require.Equal(t, numVertices(g), 5)
	})
}

func TestKrusk(t *testing.T) {
	g := getGraph()
	t.Run("test 1", func(t *testing.T) {
		tree, weight := kruskal(g)
		require.Equal(t, 10, weight)
		fmt.Println(tree)

	})
}
