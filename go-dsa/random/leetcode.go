package random

import "strconv"

// LC 3176
func maximumLength(nums []int, k int) int {

	if len(nums) < k {
		return 0
	}

	count := 0
	maxCount := 0

	for i := 0; i < len(nums)-1; i++ {
		if nums[i] != nums[i+1] {
			count++
			if count >= k {
				maxCount = max(maxCount, count)
			}

		} else {
			count = 0
		}
	}

	return maxCount

}

// LC 438
func findAnagrams(s string, p string) []int {

	k := len(p)

	if len(s) < k {
		return []int{}
	}

	pMap := make(map[rune]int)
	sMap := make(map[rune]int)

	for _, r := range p {
		pMap[r] += 1
	}

	for i := range k {
		sMap[rune(s[i])] += 1
	}
	var res []int

	for left := 0; left <= len(s)-k; left++ {

		if validate(sMap, pMap) {
			res = append(res, left)
		}

		if left+k == len(s) {
			break
		}

		sRune := rune(s[left])
		val, _ := sMap[sRune]
		if val == 1 {
			delete(sMap, sRune)
		} else {
			sMap[sRune]--
		}

		rRune := rune(s[left+k])
		sMap[rRune]++

	}

	return res

}

func validate(sMap, pMap map[rune]int) bool {

	if len(sMap) != len(pMap) {
		return false
	}
	for key, val := range sMap {
		pVal, ok := pMap[key]
		if !ok {
			return false
		}

		if pVal != val {
			return false
		}
	}

	return true
}

// LC 670
func maximumSwap(num int) int {

	numStr := strconv.Itoa(num)
	runes := []rune(numStr)
	maxIndex, swap1, swap2 := -1, -1, -1

	n := len(runes)

	for i := n - 1; i >= 0; i-- {
		if maxIndex == -1 || runes[i] > runes[maxIndex] {
			maxIndex = i
		} else if runes[i] < runes[maxIndex] {
			swap1 = i
			swap2 = maxIndex
		}
	}

	if swap1 != -1 && swap2 != -1 {
		runes[swap1], runes[swap2] = runes[swap2], runes[swap1]
	}

	toNum, _ := strconv.Atoi(string(runes))
	return toNum

}

// LC 523
func checkSubarraySum(nums []int, k int) bool {

	if len(nums) < 2 {
		return false
	}

	for left := 0; left < len(nums)-1; left++ {
		sum := nums[left]
		for i := left + 1; i < len(nums); i++ {
			sum += nums[i]
			if sum%k == 0 {
				return true
			}
		}
	}

	return false
}

func isAlienSorted(words []string, order string) bool {

	dict := make(map[rune]int)
	for i, r := range order {
		dict[r] = i
	}

	for i := 1; i < len(words); i++ {
		if !compare(words[i-1], words[i], dict) {
			return false
		}
	}

	return true

}

func compare(prev, curr string, dict map[rune]int) bool {

	l := len(prev)
	r := len(curr)
	lrunes := []rune(prev)
	rrunes := []rune(curr)

	var i, j int
	for i < l && j < r {
		if dict[lrunes[i]] < dict[rrunes[j]] {
			return true
		} else if dict[lrunes[i]] > dict[rrunes[j]] {
			return false
		}
		i++
		j++
	}

	if i != l && j == r {
		return false
	}

	return true
}

// LC162
func findPeakElement(nums []int) int {

	low := 0
	high := len(nums) - 1

	for low <= high {
		mid := low + (high-low)/2
		if mid > low && nums[mid] < nums[mid-1] {
			high = mid - 1
		} else if mid < high && nums[mid] < nums[mid+1] {
			low = mid + 1

		} else {
			return mid
		}
	}

	return -1

}
