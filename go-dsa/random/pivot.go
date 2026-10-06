package random

func findPivot(nums []int) int {
	low := 0
	high := len(nums) - 1

	for low <= high {
		mid := low + (high-low)/2
		if mid < high && nums[mid] > nums[mid+1] {
			return mid
		}
		if mid > low && nums[mid] < nums[mid-1] {
			return mid
		}

		if nums[low] > nums[mid] {
			high = mid - 1
		} else {
			low = mid + 1
		}
	}

	return -1

}
