package graph

import "sort"

func numVertices(edges []Edge) int {
	vertices := make(map[int]struct{})

	for _, edge := range edges {
		vertices[edge.To] = struct{}{}
		vertices[edge.From] = struct{}{}
	}

	return len(vertices)
}

func find(node int, parent []int) int {
	if parent[node] == node {
		return node
	}

	node = find(parent[node], parent)
	return node
}

func union(a, b int, rank, parent []int) {
	rootA := find(a, parent)
	rootB := find(b, parent)

	if rootA == rootB {
		return
	}

	if rank[rootA] < rank[rootB] {
		parent[rootA] = rootB
	} else if rank[rootB] < rank[rootA] {
		parent[rootB] = rootA
	} else {
		parent[rootA] = rootB
		rank[rootB]++
	}
}

type Edge struct {
	Weight int
	To     int
	From   int
}

func kruskal(edges []Edge) ([]Edge, int) {
	sort.Slice(edges, func(i, j int) bool {
		return edges[i].Weight < edges[j].Weight
	})

	n := numVertices(edges)
	parent := make([]int, n)
	rank := make([]int, n)

	for i := range parent {
		parent[i] = i
	}
	var mstWeight int
	var mst []Edge

	for _, edge := range edges {
		rootA := find(edge.To, parent)
		rootB := find(edge.From, parent)

		if rootA != rootB {
			mstWeight += edge.Weight
			mst = append(mst, edge)
			union(rootA, rootB, rank, parent)
		}

	}

	return mst, mstWeight

}
