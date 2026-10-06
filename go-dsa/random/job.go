package random

import (
	"fmt"
	"time"
)

/*

Job {
	Job[] deps
}

func (j *Job) Run() {

}

*/

type Job struct {
	Name         string
	Dependencies []*Job
}

func (j *Job) Run() {
	fmt.Printf("running job %s\n", j.Name)
	time.Sleep(1 * time.Second)
}

func execute(jobs []*Job) {

	if len(jobs) == 0 {
		return
	}

	inDegree := make(map[string]int)
	jobsDict := make(map[string]*Job)
	dep := make(map[string][]*Job)

	for _, job := range jobs {
		jobsDict[job.Name] = job
		inDegree[job.Name] = 0
		for _, jobDep := range job.Dependencies {
			dep[jobDep.Name] = append(dep[jobDep.Name], job)
			inDegree[job.Name]++
		}
	}

	var q []*Job
	for job, in := range inDegree {
		if in == 0 {
			q = append(q, jobsDict[job])
		}
	}

	for len(q) > 0 {
		curr := q[0]
		q = q[1:]

		curr.Run()
		deps := dep[curr.Name]
		for _, job := range deps {
			inDegree[job.Name]--
			if inDegree[job.Name] == 0 {
				q = append(q, job)
			}
		}
	}

}
