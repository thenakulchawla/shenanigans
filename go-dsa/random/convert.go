package random

import (
	"fmt"
	"strings"
)

func convertNumToString(num int) string {

	res := ""

	for num > 0 {
		if num/1000000000 > 0 {
			res += threeDigit(num/1000000000) + " billion"
			num = num % 1000000000
			continue
		}

		if num/1000000 > 0 {
			res += threeDigit(num/1000000) + " million"
			num = num % 1000000
			continue
		}

		if num/1000 > 0 {
			res += threeDigit(num/1000) + " thousand"
			num = num % 1000
			continue
		}

		res += " " + threeDigit(num)
		break
	}

	return strings.Trim(res, " ")

}

func threeDigit(num int) string {
	if num > 999 {
		fmt.Println("wrong input")
		return ""
	}
	nums := map[int]string{
		1:   "one",
		2:   "two",
		3:   "three",
		4:   "four",
		5:   "five",
		6:   "six",
		7:   "seven",
		8:   "eight",
		9:   "nine",
		10:  "ten",
		11:  "eleven",
		12:  "twelve",
		13:  "thirteen",
		14:  "fourteen",
		15:  "fifteen",
		16:  "sixteen",
		17:  "seventeen",
		18:  "eighteen",
		19:  "nineteen",
		20:  "twenty",
		30:  "thirty",
		40:  "forty",
		50:  "fifty",
		60:  "seventy",
		80:  "eighty",
		90:  "ninety",
		100: "hundred",
	}

	if _, ok := nums[num]; ok {
		return nums[num]
	}

	res := ""

	for num > 0 {

		if num/100 > 0 {
			res += nums[num/100] + " hundred"
			num = num % 100
			continue
		}

		if _, ok := nums[num]; ok {
			res += " " + nums[num]
			return res
		}

		res += " " + nums[num/10*10]
		num = num % 10
		res += " " + nums[num]
		break
	}

	return strings.Trim(res, " ")
}
