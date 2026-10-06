package random

import (
	"fmt"
	"strconv"
)

func splitMessage(message string, limit int) []string {

	n := len(message)
	parts := getParts(n, limit)
	res := []string{}
	if parts == 0 {
		return res
	}
	index := 0
	for i := 1; i <= parts; i++ {
		suf := fmt.Sprintf("<%d/%d>", i, parts)
		sufLen := len(suf)
		availableChars := limit - sufLen

		if index+availableChars > n {
			availableChars = n - index
		}
		str := message[index:index+availableChars] + suf
		res = append(res, str)
		index += availableChars
	}
	return res

}

// func getParts(n, limit int) int {
// 	low := minParts(n, limit)
// 	result := sort.Search(n+1, func(parts int) bool {
// 		if parts < low {
// 			return false
// 		}
// 		return checkParts2(n, parts, limit)
// 	})

// 	// If we didn't find a valid result
// 	if result > n {
// 		return 0
// 	}
// 	return result
// }

func getParts(n, limit int) int {
	low := minParts(n, limit)
	// low := 1
	high := n

	for low <= high {
		val := checkParts2(n, low, limit)
		if val {
			return low
		}
		low++
	}

	return 0

}

func checkParts2(n, parts, limit int) bool {
	total := 0

	sub := []int{9, 90, 900, 9000}
	start := []int{0, 9, 99, 999}

	for i, num := range sub {

		if parts > start[i] {
			suf := suffixLength(num, parts)
			availableChars := limit - suf
			if availableChars <= 0 {
				return false
			}

			digitCounts := min(num, parts-start[i])
			total += digitCounts * availableChars

		}

	}

	if total >= n {
		return true
	}

	return false

}

func suffixLength(i, parts int) int {
	return 3 + len(strconv.Itoa(i)) + len(strconv.Itoa(parts))
}

func minParts(n, limit int) int {
	suf := suffixLength(1, 1)
	k := limit - suf
	if k == 0 {
		return 0
	}
	if n%k == 0 {
		return n / k
	}

	return n/k + 1
}

func checkParts(n, parts, limit int) bool {

	total := 0

	for i := 1; i <= parts; i++ {

		if total >= n {
			return false
		}

		suf := suffixLength(i, parts)
		availableChars := limit - suf

		if availableChars <= 0 {
			return false
		}

		total += availableChars
	}

	if total >= n {
		return true
	}

	return false
}

func getPartsWithBinary(n, limit int) int {
	low := minParts(n, limit)
	// low := 1
	high := n

	for low <= high {
		val := checkParts(n, low, limit)
		if val {
			return low
		}
		low++
	}

	return 0

	// for low <= high {
	// 	mid := low + (high-low)/2
	// 	val := checkParts(n, mid, limit)

	// 	if val == 0 {
	// 		parts = min(parts, mid)
	// 		high = mid - 1
	// 	}

	// 	if val == -1 {
	// 		high = mid - 1
	// 	} else {
	// 		low = mid + 1
	// 	}

	// }

	// if parts == math.MaxInt {
	// 	return 0
	// }

	// return parts

}

func generic() bool {
	n := len("abbababbbaaa aabaa a") // 19 characters
	limit := 8

	for parts := 6; parts <= 12; parts++ {
		result := checkParts2(n, parts, limit)
		fmt.Printf("parts=%d: %v\n", parts, result)
	}
	return true
}
