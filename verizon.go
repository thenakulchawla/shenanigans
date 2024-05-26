package main

import "fmt"

const (
	total       = "total"
	rudra       = "rudra"
	aamir       = "aamir"
	jitesh      = "jitesh"
	nakul       = "nakul"
	amul        = "amul"
	preet       = "preet"
	surabhi     = "surabhi"
	discount    = "discount"
)

func main() {
	all := map[string]float64{
		total:      313.14,
		discount:    10,
		rudra:       42.45,
		aamir:       42.45,
		jitesh:      42.45,
		nakul:       47.67,
		amul:        66.17,
		preet:       42.45,
		surabhi:     39.50,
	}

	calculate(all)
	printOutput(all)
}

func calculate(inputMap map[string]float64) {
	fmt.Println(inputMap[discount])
	participants := float64(len(inputMap) - 2)
	fmt.Println(participants)
	discountPerPerson := inputMap[discount] / participants
	for key := range inputMap {
		inputMap[key] -= discountPerPerson
	}
	aggregate(inputMap)
}

func aggregate(inputMap map[string]float64) {
	inputMap[preet] += inputMap[surabhi]
	delete(inputMap, surabhi)
	delete(inputMap, total)
	delete(inputMap, discount)

	newTotal := 0.0
	for _, value := range inputMap {
		newTotal += value
	}
	inputMap[total] = newTotal
}

func printOutput(inputMap map[string]float64) {
	for key, value := range inputMap {
		fmt.Printf("%s: %.2f\n", key, value)
	}
}
