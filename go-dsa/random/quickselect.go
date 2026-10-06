package random

import "math"

func findKthLargest(nums []int, k int) int {

	if len(nums) < k {
		return -1
	}

	return quickselectBase(nums, k)

}

func quickselectBase(nums []int, k int) int {
	pivot := nums[0]

	var large, small, equal []int
	for _, num := range nums {
		if num > pivot {
			large = append(large, num)
		} else if num < pivot {
			small = append(small, num)
		} else {
			equal = append(equal, num)
		}
	}

	if len(large) >= k {
		return quickselectBase(large, k)
	}

	if len(large)+len(equal) < k {
		return quickselectBase(small, k-len(large)-len(equal))
	}

	return pivot
}

// LC 973
type Point struct {
	X        int
	Y        int
	Distance float64
}

func kClosest(points [][]int, k int) [][]int {

	if len(points) < k {
		return [][]int{}
	}

	var distances []Point
	for _, point := range points {
		d := distance(point)
		distances = append(distances, Point{point[0], point[1], d})
	}

	ans := quickselect(distances, k)
	var res [][]int

	for _, d := range distances {
		if d.Distance <= ans.Distance {
			res = append(res, []int{d.X, d.Y})
		}

	}
	return res

}

func distance(point []int) float64 {
	x, y := float64(point[0]), float64(point[1])
	return math.Sqrt(x*x + y*y)

}

func quickselect(points []Point, k int) Point {

	pivot := points[0]
	var small, equal, large []Point

	for _, point := range points {
		if point.Distance < pivot.Distance {
			small = append(small, point)
		} else if point.Distance > pivot.Distance {
			large = append(large, point)
		} else {
			equal = append(equal, point)
		}
	}

	if len(small) >= k {
		return quickselect(small, k)
	}

	if len(small)+len(equal) < k {
		return quickselect(large, k-len(small)-len(equal))
	}

	return pivot
}
