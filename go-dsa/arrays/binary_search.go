// Package arrays package for arrays
package arrays

func binarySearch(target int, nums []int) int {

	left := 0
	right := len(nums) - 1

	for left <= right {
		mid := (left + right) / 2
		midNum := nums[mid]
		if midNum == target {
			return mid
		} else if midNum > target {
			right = mid - 1
		} else {
			left = mid + 1
		}

	}

	return -1
}
