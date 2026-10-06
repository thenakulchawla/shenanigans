package random

import "unicode"

func isPalindrome(s string, mask int) bool {
	subs := getSubsequence(s, mask)
	runes := []rune(subs)

	low := 0
	high := len(runes) - 1
	for low <= high {
		if runes[low] != runes[high] {
			return false
		}
		low++
		high--
	}

	return true

}

func getSubsequence(s string, mask int) string {
	var res []rune
	for i, r := range s {
		if mask&(1<<i) != 0 {
			res = append(res, r)
		}
	}
	return string(res)
}

func countSetBits(mask int) int {
	count := 0
	for mask > 0 {
		if mask&1 == 1 {
			count++
		}
		mask = mask >> 1
	}

	return count
}

func bitmasks(s string) map[int]int {
	ans := make(map[int]int)
	n := len(s)

	for mask := 0; mask < (1 << n); mask++ {
		if isPalindrome(s, mask) {
			ans[mask] = countSetBits(mask)
		}

	}
	return ans
}

func isPalindromeString(s string) bool {

	left := 0
	right := len(s) - 1

	for left <= right {
		lRune := rune(s[left])
		rRune := rune(s[right])

		if check(lRune) && check(rRune) {
			if unicode.ToLower(lRune) != unicode.ToLower(rRune) {
				return false
			}
			left++
			right--
		}

		if !check(lRune) {
			left++
		}

		if !check(rRune) {
			right--
		}
	}

	return true

}

func check(r rune) bool {
	return unicode.IsLetter(r) || unicode.IsNumber(r)
}
