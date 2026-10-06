package random

import (
	"math"
	"sort"
	"strings"
	"unicode"
)

func topkwords(para string, k int) []string {

	parts := strings.Fields(para)
	dict := make(map[string]int)

	for _, part := range parts {
		p := sanitize(part)
		if p != "" {
			dict[p] += 1
		}

	}

	if len(dict) == 0 {
		return []string{}
	}

	minCount := math.MaxInt
	maxCount := math.MinInt

	for _, val := range dict {
		if val > maxCount {
			maxCount = val
			continue
		}

		if val < minCount {
			minCount = val
			continue
		}
	}

	arr := make([][]string, maxCount-minCount+1)

	for key, val := range dict {
		arr[val-minCount] = append(arr[val-minCount], key)
	}

	res := []string{}

	for i := len(arr) - 1; i >= 0; i++ {
		res = append(res, arr[i]...)
		if len(res) >= k {
			break
		}
	}

	if len(res) <= k {
		return res
	}

	sort.Slice(res, func(i, j int) bool {
		return res[i] < res[j]
	})

	return res[:k]
}

func sanitize(word string) string {

	runes := []rune(word)
	val := len(runes)

	for i := len(runes) - 1; i >= 0; i-- {
		if !unicode.IsLetter(runes[i]) {
			val--
		} else {
			break
		}
	}

	newWord := runes[:val]
	return strings.ToLower(string(newWord))
}
