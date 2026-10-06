package trie

import "sort"

type TrieNode struct {
	Children map[rune]*TrieNode
	Count    int
	IsEnd    bool
}

type Trie struct {
	Root *TrieNode
}

func NewTrie() *Trie {
	return &Trie{
		Root: &TrieNode{
			Children: make(map[rune]*TrieNode),
		},
	}

}

func (t *Trie) Insert(word string) {
	node := t.Root
	for _, r := range word {
		if _, ok := node.Children[r]; !ok {
			node.Children[r] = &TrieNode{Children: make(map[rune]*TrieNode)}

		}
		node.Count++
		node = node.Children[r]
	}
	node.IsEnd = true
}

func (t *Trie) FindPrefixLength(word string) int {
	node := t.Root
	prefix := 0
	for _, r := range word {
		node = node.Children[r]
		prefix++
		if node.Count == 1 {
			break
		}
	}

	return prefix

}

func (t *Trie) Search(word string) bool {

	node := t.Root
	for _, r := range word {
		if _, ok := node.Children[r]; !ok {
			return false
		}
		node = node.Children[r]
	}

	return node.IsEnd
}

func (t *Trie) StartsWith(prefix string) bool {

	node := t.Root
	for _, r := range prefix {
		if _, ok := node.Children[r]; !ok {
			return false
		}
		node = node.Children[r]
	}

	return true

}

func (t *Trie) StartsWithLimit(prefix string, limit int) []string {
	node := t.Root
	for _, r := range prefix {
		_, ok := node.Children[r]
		if !ok {
			return nil
		}
		node = node.Children[r]
	}

	words := []string{}
	t.CollectWords(node, prefix, limit, &words)
	return words
}

func (t *Trie) CollectWords(node *TrieNode, prefix string, limit int, words *[]string) {
	if len(*words) >= limit {
		return
	}

	if node.IsEnd {
		*words = append(*words, prefix)
	}

	var keys []rune
	for r := range node.Children {
		keys = append(keys, r)
	}

	sort.Slice(keys, func(i, j int) bool {
		return keys[i] < keys[j]
	})

	// if len(keys) > limit {
	//     keys = keys[:limit]
	// }

	for _, r := range keys {
		t.CollectWords(node.Children[r], prefix+string(r), limit, words)
		if len(*words) >= limit {
			break
		}
	}

}
