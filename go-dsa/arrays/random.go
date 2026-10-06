package arrays

import "fmt"

func something() {

	nums := []int{1, 2, 3, 4, 5}

	nums1Copy := nums[:3]
	fmt.Println(nums1Copy)
	fmt.Println(len(nums))

}
