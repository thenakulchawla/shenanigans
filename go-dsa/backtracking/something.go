package backtracking

import "fmt"

func Printallbinary(digits int) {

	printallbinaryhelper(digits, "")

}

func printallbinaryhelper(digits int, output string) {
	if digits == 0 {
		fmt.Println(output)
	} else {
		printallbinaryhelper(digits-1, "0"+output)
		printallbinaryhelper(digits-1, "1"+output)
	}
}
