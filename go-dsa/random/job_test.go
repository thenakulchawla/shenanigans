package random

import "testing"

func TestExecute(t *testing.T) {

	j1 := &Job{Name: "j1", Dependencies: []*Job{}}
	j2 := &Job{Name: "j2", Dependencies: []*Job{j1}}
	j3 := &Job{Name: "j3", Dependencies: []*Job{j1}}
	j4 := &Job{Name: "j4", Dependencies: []*Job{j2, j3}}
	execute([]*Job{j4, j1, j2, j3})

}
