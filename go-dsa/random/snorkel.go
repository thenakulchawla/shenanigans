// """
// Background: You're tasked with implementing a SnapshotMap data structure
// that extends a regular map with snapshot capabilities. This data structure
// should allow users to take snapshots of the map's state and retrieve values
// from these snapshots later.

// A regular map has the following interface methods:
// - get(k) -> v or KeyError
// - put(k, v)
// - delete(k)

// We wish to augment this with two more methods:
// - take_snapshot() -> snap_id
// - get(k, snap_id) -> v or KeyError

// Your Task:

// Implement the SnapshotMap class with the following methods:
// - put(k, v): Insert or update the value for a key.
// - get(k, snap_id=None): Retrieve the value of a key at the current state or
// at a given snapshot.
// - take_snapshot(): Take a historical snapshot of the current state and return a snapshot ID.
// - delete(k): Delete a key from the map and reflect this in SUBSEQUENT snapshots. (Optional, if time permits)

// Your implementation must adhere to these hard constraints:
// - Values unchanged across snapshots should not be duplicated.
// - All operations should be sub-linear in the size of the map. O(1) <  x  < O(n)
// - Assume the map will handle up to ~1 million keys, with ~10 snapshots, and 1% of
// the keys changing in each snapshot.

// Testing Your Implementation
// - To ensure your implementation meets the requirements, use the provided tests.
// This includes various scenarios to check the functionality and performance of
// your SnapshotMap.

// Please review the test cases before starting the problem.
// """

package random

import (
	"fmt"
	"math/rand/v2"
	"sort"
	"time"
)

type SnapValue struct {
	SnapID int
	Value  int
}

type SnapshotMap struct {
	Keys   map[string][]SnapValue
	SnapID int
}

// First, initialize your chosen data structure
func NewSnapshotMap() *SnapshotMap {
	return &SnapshotMap{
		Keys:   make(map[string][]SnapValue),
		SnapID: 0,
	}
}

// Second, create a snapshot of the current state
func (s *SnapshotMap) takeSnapshot() int {
	prev := s.SnapID
	s.SnapID++
	return prev
}

// Third, we'll need to cover the basics
func (s *SnapshotMap) put(key string, value int) {
	// Insert or update the value for a key
	snapArray, ok := s.Keys[key]

	if !ok {
		s.Keys[key] = []SnapValue{{Value: value, SnapID: 0}}
		return
	}
	if len(snapArray) == 0 {
		s.Keys[key] = []SnapValue{{Value: value, SnapID: 0}}
		return
	}
	snapID := snapArray[len(snapArray)-1].SnapID
	if snapID == s.SnapID {
		snapArray[len(snapArray)-1].Value = value
		return
	}

	// WTF, don't copy paste in interviews
	s.Keys[key] = append(s.Keys[key], SnapValue{Value: value, SnapID: s.SnapID})
	return

}

func (s *SnapshotMap) get(key string) int {
	// Retrieve the value of a key at current state.
	snapArray, ok := s.Keys[key]
	if !ok {
		return -1
	}

	index := len(snapArray)

	return snapArray[index-1].Value

}

func (s *SnapshotMap) getWithSnapId(key string, snapId int) int {
	// Retrieve the value of a key at a given snapshot.
	snapArray, ok := s.Keys[key]
	if !ok {
		fmt.Println("value not found")
		return -1
	}

	// Find the latest snapshot at or before the requested snapId
	idx := sort.Search(len(snapArray), func(i int) bool {
		return snapArray[i].SnapID > snapId
	})

	if idx == 0 {
		return -1
	}

	return snapArray[idx-1].Value
}

func (s *SnapshotMap) delete(key string) {

}

// Test Helpers
func sample(limit, size int) []int {
	result := make([]int, size)
	for i := 0; i < size; i++ {
		result[i] = rand.IntN(limit)
	}
	return result
}

func perfTest(s *SnapshotMap, snapshots int, iterations int) time.Duration {
	// Insert Keys
	for i := 0; i < iterations; i++ {
		s.put(fmt.Sprintf("key%d", i), i)
	}

	// Update 1% of Keys
	start_time := time.Now()
	for snapshot := 0; snapshot < 10; snapshot++ {
		keys := sample(iterations, iterations/100)
		for key := range keys {
			s.put(fmt.Sprintf("key%d", key), rand.IntN(iterations))
		}
		s.takeSnapshot()
	}
	end_time := time.Now()

	// Calculate Duration
	duration := end_time.Sub(start_time)
	fmt.Printf("\n%d keys.\nTotal time for 10 snapshots with 1%% key changes each: %.6f seconds\n\n", iterations, duration.Seconds())
	return duration
}
