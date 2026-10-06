package intervals

func sortIntervals(intervals [][]int) [][]int {

	var res [][]int

	for i, interval := range intervals {
		if i == 0 {
			res = append(res, interval)
		}

		// insertion := sort.Search(len(res), func(index int) bool {
		// 	return res[index][1] >= interval[0]
		// })

	}

	return res

}
