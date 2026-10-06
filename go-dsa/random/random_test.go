package random

import (
	"fmt"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestFindAnagrams(t *testing.T) {

	t.Run("random", func(t *testing.T) {

		ans := []int{0, 6}
		require.Equal(t, ans, findAnagrams("cbaebabacd", "abc"))
	})

	t.Run("random1", func(t *testing.T) {
		ans := []int{0, 1, 2}
		require.Equal(t, ans, findAnagrams("abab", "ab"))
	})
}

func TestFindGoodSub(t *testing.T) {

	t.Run("random", func(t *testing.T) {
		nums := []int{1, 2, 1, 1, 3}
		k := 2
		require.Equal(t, 4, maximumLength(nums, k))
	})
}

func TestJudge(t *testing.T) {

	t.Run("test1", func(t *testing.T) {
		trust := [][]int{
			{1, 3},
			{2, 3},
		}
		n := 3

		val := findJudge(n, trust)
		require.Equal(t, 3, val)

	})

	t.Run("test2", func(t *testing.T) {
		trust := [][]int{
			{1, 2},
		}

		n := 2
		val := findJudge(n, trust)
		require.Equal(t, 2, val)

	})

	t.Run("test3", func(t *testing.T) {
		trust := [][]int{
			{1, 3},
			{2, 3},
			{3, 1},
		}
		trust[0] = []int{1, 3}
		trust[1] = []int{2, 3}
		trust[2] = []int{3, 1}

		n := 3

		val := findJudge(n, trust)
		require.Equal(t, -1, val)

	})
}

func TestWordsAbbreviation(t *testing.T) {
	t.Run("base below 3", func(t *testing.T) {
		words := []string{"god", "aa", "aaa"}
		res := wordsAbbreviation(words)

		require.Equal(t, words, res)
	})

	t.Run("not exactly base", func(t *testing.T) {
		words := []string{"kids", "aunt", "leetcode"}
		ans := []string{"k2s", "a2t", "l6e"}
		res := wordsAbbreviation(words)
		require.Equal(t, res, ans)

	})

	t.Run("all cases", func(t *testing.T) {
		words := []string{"like", "god", "internal", "me", "internet", "interval", "intension", "face", "intrusion"}
		ans := []string{"l2e", "god", "internal", "me", "i6t", "interval", "inte4n", "f2e", "intr4n"}
		res := wordsAbbreviation(words)
		require.Equal(t, ans, res)
	})

	t.Run("debug", func(t *testing.T) {
		words := []string{"internal", "interval"}
		ans := []string{"internal", "interval"}
		res := wordsAbbreviation(words)
		require.Equal(t, res, ans)
	})

	t.Run("debug1", func(t *testing.T) {
		words := []string{"intension", "intrusion"}
		ans := []string{"inte4n", "intr4n"}
		res := wordsAbbreviation(words)
		require.Equal(t, res, ans)
	})
}

func TestFindPivot(t *testing.T) {

	t.Run("base", func(t *testing.T) {
		nums := []int{4, 5, 6, 7, 0, 1, 2}
		pivot := findPivot(nums)
		require.Equal(t, 7, nums[pivot])
	})

	t.Run("another", func(t *testing.T) {
		nums := []int{1}
		pivot := findPivot(nums)
		require.Equal(t, -1, pivot)
	})

	t.Run("no rotation", func(t *testing.T) {
		nums := []int{1, 2, 3, 4, 5}
		pivot := findPivot(nums)
		require.Equal(t, -1, pivot)
	})
}

func TestIsMatch(t *testing.T) {

	t.Run("no kleene", func(t *testing.T) {
		s := "ab"
		p := ".."
		require.True(t, isMatch(s, p))
	})

	t.Run("no kleene 1", func(t *testing.T) {
		s := "aa"
		p := "a."
		require.True(t, isMatch(s, p))
	})
}

func TestIsPalindrome(t *testing.T) {
	t.Run("base", func(t *testing.T) {
		s := "howoh"
		require.True(t, isPalindrome(s, 32))
	})

	t.Run("base1", func(t *testing.T) {
		s := "howoh1"
		require.False(t, isPalindrome(s, 32))
	})

}

func TestTopKWords(t *testing.T) {
	t.Run("base with punctuation", func(t *testing.T) {
		input := "Base case,.! base case val aaa aaa bbb ccc"
		output := []string{"aaa", "base"}

		require.Equal(t, output, topkwords(input, 2))
	})

	t.Run("edge1", func(t *testing.T) {
		input := "...!!"
		output := []string{}
		require.Equal(t, output, topkwords(input, 2))
	})

	t.Run("edge2", func(t *testing.T) {
		input := "... ... !!! "
		output := []string{}
		require.Equal(t, output, topkwords(input, 2))
	})
}

func TestSanitize(t *testing.T) {
	t.Run("complicated", func(t *testing.T) {
		input := "Base..?!:"

		require.Equal(t, "base", sanitize(input))

	})
}

func TestConvertNum(t *testing.T) {

	t.Run("two digit", func(t *testing.T) {
		require.Equal(t, "ninety nine", convertNumToString(99))
		require.Equal(t, "one", convertNumToString(1))
	})

	t.Run("base 3 digit", func(t *testing.T) {
		require.Equal(t, "five hundred forty five", convertNumToString(545))
		require.Equal(t, "five hundred forty five", convertNumToString(545))
		require.Equal(t, "five hundred one", convertNumToString(501))
		require.Equal(t, "nine hundred twenty", convertNumToString(920))
		require.Equal(t, "nine hundred twenty one", convertNumToString(921))
		require.Equal(t, "nine hundred ninety nine", convertNumToString(999))
	})

	t.Run("thousands", func(t *testing.T) {
		require.Equal(t, "one thousand", convertNumToString(1000))
		require.Equal(t, "nine thousand nine hundred ninety nine", convertNumToString(9999))
	})

	t.Run("millions", func(t *testing.T) {
		require.Equal(t, "one million", convertNumToString(1000000))
	})

	t.Run("billons", func(t *testing.T) {
		require.Equal(t, "one billion", convertNumToString(1000000000))
	})

}

func TestPalindromeString(t *testing.T) {

	t.Run("base lc", func(t *testing.T) {
		s := "A man, a plan, a canal: Panama"
		require.True(t, isPalindromeString(s))

	})

	t.Run("something", func(t *testing.T) {

		s2 := "8V8K;G;K;V;"
		require.False(t, isPalindromeString(s2))
	})
}

func TestMaxSwap(t *testing.T) {
	t.Run("random", func(t *testing.T) {
		require.Equal(t, 7236, maximumSwap(2736))
	})
}

func TestQuickSelect(t *testing.T) {

	t.Run("debug", func(t *testing.T) {
		nums := []int{3, 2, 1, 5, 6, 4}
		require.Equal(t, 5, quickselectBase(nums, 2))
	})
}

func TestKClosest(t *testing.T) {
	t.Run("debug", func(t *testing.T) {
		points := [][]int{
			{3, 3},
			{5, -1},
			{-2, 4},
		}

		ans := [][]int{
			{3, 3},
			{-2, 4},
		}

		require.Equal(t, ans, kClosest(points, 2))

	})
}

func TestSubarraySum(t *testing.T) {
	t.Run("n-square", func(t *testing.T) {
		nums := []int{23, 2, 4, 6, 7}
		require.True(t, checkSubarraySum(nums, 6))
	})
}

// Your old code in python3 has been preserved below.
// # Rolling Boulder
// #
// # is_reachable() bool
// # 5 inputs, start x (col), start y (row), target x (col), target y(row), map [][]int
//  # Returns true if you can *stop* at the target point, false otherwise

// # [ [ Z 0 0 0 A]
// #   [ 0 0 1 0 0]
// #   [ B 1 D 0 C] ]
//  # z[y][x]
// # z[2][0]
//  # is_reachable ->  (0,0), (0, 2) -> true
//  # is_reachable ->  (0,0), (1, 1) -> false
// # is_reachable ->  (0,0), (2, 0) -> false

// # Rules
//  # 1s are blocker and there non traversable
//  # 0s are free space
//  # you can move up down left and right
//  # HINT: (If you could only move like a knight) <- think about this
//  # you must move until you reach a 1 or a boundary
//  # you can change directions after you *stop*
//  # If you are started outside the bounds or inside of a blocker (1) then it's false

func TestFindTarget(t *testing.T) {
	t.Run("debug", func(t *testing.T) {

		grid := [][]int{
			{0, 0, 0, 0, 0},
			{0, 0, 1, 0, 0},
			{0, 1, 0, 0, 0},
		}

		require.True(t, findTarget(grid, []int{0, 0}, []int{2, 0}))

	})
}

func TestRemoveDuplicates(t *testing.T) {

	t.Run("something", func(t *testing.T) {
		require.Equal(t, "ca", removeDuplicates("abbaca"))
	})
}

func TestMiddleElement(t *testing.T) {

	nums := []int{-10, -3, 0, 5, 9}
	require.Equal(t, 0, middleElement(nums))
}

func TestIsPalindromeBig(t *testing.T) {
	require.True(t, isPalindromeBig(10001))
	require.True(t, isPalindromeBig(1001))
	require.False(t, isPalindromeBig(112233))
	require.True(t, isPalindromeBig(1000000000000000001))

}

func TestGethash(t *testing.T) {
	require.Equal(t, "1#2#", getHash("zab"))
	require.Equal(t, "1#2#", getHash("abc"))

	require.Equal(t, getHash2("az"), getHash2("ba"))
	require.Equal(t, getHash("az"), getHash("ba"))

}

func TestIsAlienSorted(t *testing.T) {

	t.Run("base", func(t *testing.T) {
		words := []string{"hello", "leetcode"}
		order := "hlabcdefgijkmnopqrstuvwxyz"
		require.True(t, isAlienSorted(words, order))
	})
}

func TestPeakElement(t *testing.T) {
	t.Run("peak element", func(t *testing.T) {
		require.Equal(t, 0, findPeakElement([]int{3, 1}))
		require.Equal(t, 1, findPeakElement([]int{1, 3}))
	})
}

func TestMovingAverage(t *testing.T) {
	t.Run("something", func(t *testing.T) {
		nums := []int{1, 2, 3, 4, 5}
		k := 3
		ans := []float64{2.00, 3.00, 4.00}
		require.Equal(t, ans, findMovingAverage(nums, k))
	})
}

func TestLongestMountain(t *testing.T) {
	t.Run("case1", func(t *testing.T) {
		nums := []int{2, 1, 4, 7, 3, 2, 5}
		require.Equal(t, 5, longestMountain(nums))
	})

	t.Run("case2", func(t *testing.T) {
		nums := []int{2, 2, 2}
		require.Equal(t, 0, longestMountain(nums))
	})
}

func TestAnthropic(t *testing.T) {
	t.Run("case1", func(t *testing.T) {
		events := convertToTrace(samples2)
		require.Equal(t, len(events), 3)
	})
}

func TestSnapshot(t *testing.T) {
	var s *SnapshotMap = NewSnapshotMap()

	/*
	   PHASE 1 - Basic snapshot functionality
	   Please note that we're commenting out the delete for now!
	*/
	// Test for basic put and get operations
	s.put("a", 1)
	// "a": (1,0)
	// 1
	// ("a", 2)
	// (2, 1)
	s.put("b", 2)
	if val := s.get("a"); val != 1 {
		fmt.Println("value of first a: ", val)
		panic("a != 1")
	}
	if val := s.get("b"); val != 2 {
		panic("b != 2")
	}

	// Test for snapshot functionality
	snap_id1 := s.takeSnapshot()
	s.put("a", 5)
	snap_id2 := s.takeSnapshot()
	snap_id3 := s.takeSnapshot()
	/*
	   Uncomment for Phase 2 - reflect deletion in subsequent snapshots
	   remember, below at `assert s.getWithSnapId("b", snap_id1)` we will expect `2`
	   after this deletion step
	*/
	// s.delete("b")
	s.put("a", 10)
	snap_id4 := s.takeSnapshot()
	snap_id5 := s.takeSnapshot()

	// Test for values in different snapshots
	if val := s.getWithSnapId("a", snap_id1); val != 1 {
		fmt.Println("value of a: ", val)
		panic("a != 1")
	}
	if val := s.getWithSnapId("a", snap_id2); val != 5 {
		panic("a != 5")
	}
	if val := s.getWithSnapId("a", snap_id3); val != 5 {
		panic("a != 5")
	}
	if val := s.getWithSnapId("a", snap_id4); val != 10 {
		panic("a != 10")
	}
	if val := s.getWithSnapId("a", snap_id5); val != 10 {
		fmt.Println("value of a", val)
		panic("a != 10")
	}
	if val := s.get("a"); val != 10 {
		panic("a != 10")
	}

	if val := s.getWithSnapId("b", snap_id1); val != 2 {
		panic("b != 2")
	}
	if val := s.getWithSnapId("b", snap_id2); val != 2 {
		panic("b != 2")
	}
	if val := s.getWithSnapId("b", snap_id3); val != 2 {
		panic("b != 2")
	}
	fmt.Println("PHASE 1 PASSED")
}

func TestUber(t *testing.T) {

	require.Equal(t, []string{"root1", "folder1", "empty9"}, printPath(9))

}
