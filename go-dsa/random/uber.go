package random

type Folder struct {
	ID         int
	SubFolders []int
	Name       string
}

type TrieNode struct {
	SubFolders map[int]*TrieNode
	IsEnd      bool
}

type Trie struct {
	Roots      []*TrieNode
	PathLookup map[int][]int
}

func buildTrie(index int, folders []Folder, foldersMap map[int]int, currentPath []int, pathLookup map[int][]int) *TrieNode {
	folder := folders[index]
	root := &TrieNode{
		SubFolders: make(map[int]*TrieNode),
		IsEnd:      len(folders[index].SubFolders) == 0,
	}

	if folder.ID != 0 {
		pathCopy := make([]int, len(currentPath))
		copy(pathCopy, currentPath)
		pathLookup[folder.ID] = pathCopy
	}

	for _, subfolderID := range folder.SubFolders {

		if subfolderIndex, ok := foldersMap[subfolderID]; ok {
			newPath := append(currentPath, subfolderID)
			subNode := buildTrie(subfolderIndex, folders, foldersMap, newPath, pathLookup)
			root.SubFolders[subfolderID] = subNode
		}
	}

	return root

}

func printPath(input int) []string {
	folders := []Folder{
		{ID: 0, SubFolders: []int{1, 2, 3}, Name: "root1"},
		{ID: 0, SubFolders: []int{4, 5, 6}, Name: "root2"},
		{ID: 1, SubFolders: []int{8, 9}, Name: "folder1"},
		{ID: 8, SubFolders: []int{}, Name: "empty8"},
		{ID: 9, SubFolders: []int{}, Name: "empty9"},
		{ID: 4, SubFolders: []int{}, Name: "empty4"},
		{ID: 5, SubFolders: []int{}, Name: "empty5"},
		{ID: 6, SubFolders: []int{}, Name: "empty6"},
		{ID: 2, SubFolders: []int{}, Name: "empty2"},
		{ID: 3, SubFolders: []int{}, Name: "empty3"},
	}

	trie := &Trie{
		Roots:      []*TrieNode{},
		PathLookup: make(map[int][]int),
	}

	foldersMap := make(map[int]int)
	for i, folder := range folders {
		if folder.ID == 0 {
			continue
		}
		foldersMap[folder.ID] = i
	}

	for i, folder := range folders {
		if folder.ID == 0 {
			root := buildTrie(i, folders, foldersMap, []int{}, trie.PathLookup)
			trie.Roots = append(trie.Roots, root)
		}
	}

	if path, ok := trie.PathLookup[input]; ok {
		names := make([]string, len(path))
		for _, id := range path {
			folder := foldersMap[id]
			name := folders[folder].Name
			names = append(names, name)
		}
		return names
	}

	return []string{}
}
