// Package reverse to manage all reverses
package reverse

func reverseArrayInplace(input []int) error {

	inputLen := len(input)
	left := 0
	right := inputLen - 1

	for left < right {
		input[left], input[right] = input[right], input[left]
		left++
		right--
	}

	return nil
}

func reverseNum(input int) (int, error) {

	rev := 0

	for input > 0 {
		num := input % 10
		rev = rev*10 + num
		input = input / 10
	}

	return rev, nil

}
