// Package sort to sort things
package sort

func selectionSort(input []int) ([]int, error) {

	var minIndex int
	for i := 0; i < len(input)-1; i++ {
		minIndex = i
		for j := i + 1; j < len(input); j++ {
			if input[j] < input[minIndex] {
				minIndex = j
			}
		}

		input[minIndex], input[i] = input[i], input[minIndex]

	}
	return input, nil
}

func mergesort(arr []int) []int {

	if len(arr) <= 1 {
		return arr
	}

	mid := len(arr) / 2

	left := arr[:mid]
	right := arr[mid:]

	left = mergesort(left)
	right = mergesort(right)

	return merge(left, right)

}

func merge(left []int, right []int) []int {
	res := make([]int, len(left)+len(right))

	l := 0
	r := 0
	i := 0

	for l < len(left) && r < len(right) {
		if left[l] <= right[r] {
			res[i] = left[l]
			l++
		} else {
			res[i] = right[r]
			r++
		}
		i++
	}

	for l < len(left) {
		res[i] = left[l]
		l++
		i++
	}

	for r < len(right) {
		res[i] = right[r]
		r++
		i++
	}

	return res
}
