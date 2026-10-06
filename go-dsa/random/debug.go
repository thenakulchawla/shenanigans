package random

import (
	"fmt"
	"strconv"
	"strings"

	"github.com/thenakulchawla/shenanigans/go-dsa/trie"
)

func findJudge(n int, trust [][]int) int {
	trusts := make(map[int]int)
	trustedBy := make(map[int]int)

	// Build the trust maps
	for _, t := range trust {
		a, b := t[0], t[1]
		trusts[a]++
		trustedBy[b]++
	}

	// Check for the judge
	for i := 1; i <= n; i++ {
		if trustedBy[i] == n-1 && trusts[i] == 0 {
			return i
		}
	}

	return -1
}

func wordsAbbreviation(words []string) []string {

	n := len(words)

	if len(words) == 0 {
		return []string{}
	}

	res := make([]string, n)
	abbrMap := make(map[string][]int)
	for i, word := range words {
		if len(word) <= 3 {
			abbrMap[word] = append(abbrMap[word], i)
			continue
		}
		abbr := abbreviation(word, 0)
		abbrMap[abbr] = append(abbrMap[abbr], i)
	}

	check := false
	for key, val := range abbrMap {
		if len(val) == 1 {
			res[val[0]] = key
			delete(abbrMap, key)
		} else {
			check = true
		}
	}
	if !check {
		return res
	}

	for _, indices := range abbrMap {
		trie := trie.NewTrie()
		for _, idx := range indices {
			trie.Insert(words[idx])
		}
		for _, idx := range indices {
			prefix := trie.FindPrefixLength(words[idx])
			res[idx] = abbreviation(words[idx], prefix-1)
		}
	}

	return res
}

func abbreviation(word string, prefix int) string {
	if len(word)-prefix-2 <= 1 {
		return word
	}

	return word[:prefix+1] + strconv.Itoa(len(word)-prefix-2) + word[len(word)-1:]

}

type Pair struct {
	X int
	Y int
}

func findTarget(grid [][]int, source []int, target []int) bool {

	rows := len(grid)
	if rows == 0 {
		return false
	}

	cols := len(grid[0])
	visited := make(map[Pair]struct{})

	if source[0] >= rows || source[0] < 0 {
		return false
	}

	if source[1] >= cols || source[1] < 0 {
		return false
	}

	var dfs func(row, col int) bool

	dfs = func(row, col int) bool {
		visited[Pair{row, col}] = struct{}{}

		if row == target[0] && col == target[1] {
			return true
		}

		dx := []int{-1, 1, 0, 0}
		dy := []int{0, 0, -1, 1}

		for i := 0; i < 4; i++ {

			newRow, newCol := slide(row, col, target[0], target[1], dx[i], dy[i], grid)
			if newRow == target[0] && newCol == target[1] {
				return true
			}

			if _, ok := visited[Pair{newRow, newCol}]; !ok {
				if dfs(newRow, newCol) {
					return true
				}

			}
		}

		return false

	}

	return dfs(source[0], source[1])
}

func slide(row, col, targetRow, targetCol, dx, dy int, grid [][]int) (int, int) {

	rows, cols := len(grid), len(grid[0])
	newRow, newCol := row, col

	for {
		nextRow, nextCol := newRow+dx, newCol+dy
		if nextRow < 0 || nextCol < 0 || nextRow >= rows || nextCol >= cols {
			break
		}

		newRow, newCol = nextRow, nextCol
		if newRow == targetRow && newCol == targetCol {
			return nextRow, nextCol
		}
	}

	return newRow, newCol
}

func removeDuplicates(s string) string {

	stack := []rune{}

	for _, r := range s {

		if len(stack) > 0 && stack[len(stack)-1] == r {
			stack = stack[:len(stack)-1]
		} else {
			stack = append(stack, r)
		}

	}

	return string(stack)

}

func middleElement(nums []int) int {
	low := 0
	high := len(nums) - 1

	mid := low + (high-low)/2
	firstHalf := nums[low : mid-1]
	secHalf := nums[mid+1 : high]

	fmt.Println("first half: ", firstHalf)
	fmt.Println("second half: ", secHalf)

	return mid
}

func isPalindromeBig(num int) bool {

	rev := 0
	for rev < num {

		rev = rev*10 + num%10
		num = num / 10
	}

	return rev == num || num == rev/10

}

func getHash2(s string) string {

	n := len(s)
	var sb strings.Builder

	for i := 1; i < n; i++ {
		diff := int(rune(s[i])) - int(rune(s[0]))
		if diff < 0 {
			diff = diff + 26
		}
		sb.WriteString(strconv.Itoa(diff))
		sb.WriteString("#")
	}

	return sb.String()
}

func getHash(s string) string {
	n := len(s)
	if n == 1 {
		return "#single#"
	}

	var sb strings.Builder
	for i := 1; i < n; i++ {
		diff := int(rune(s[i])) - int(rune(s[0]))
		if diff < 0 {
			diff = diff + 26
		}

		sb.WriteString(strconv.Itoa(diff))
		sb.WriteString("#")

	}

	return sb.String()
}

func findMovingAverage(nums []int, k int) []float64 {

	sum := 0

	var res []float64

	for i := range k {
		sum += nums[i]
	}

	res = append(res, float64(sum)/float64(k))

	for i := k; i < len(nums); i++ {
		sum += nums[i] - nums[i-k]
		res = append(res, float64(sum)/float64(k))
	}

	return res

}

func longestMountain(arr []int) int {

	if len(arr) < 3 {
		return 0
	}

	up := false
	down := false
	longest := 0
	length := 1

	for i := 1; i < len(arr); i++ {
		if arr[i] > arr[i-1] {

			if down {
				length = 1
			}
			up = true
			down = false
			length++
		} else if arr[i] < arr[i-1] {
			if up {
				down = true
				length++
				if length >= 3 {
					longest = max(longest, length)
				}

			} else if down {
				length++
				if length >= 3 {
					longest = max(longest, length)
				}
			}
		} else {
			length = 1
			up = false
			down = false
		}

	}

	return longest

}
