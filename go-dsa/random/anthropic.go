package random

// Problem: Converting stack samples to a trace

// Sampling profilers are a performance analysis tool for finding the slow parts
// of your code by periodically sampling the entire call stack (lots of code
// might run between samples). In our problem the samples will be a list of
// Samples of a float timestamp and a list of function names, in order by
// timestamp, like this:

type Sample struct {
	ts    float64
	stack []string
}

var samples = []Sample{
	{
		ts:    7.5,
		stack: []string{"main", "my_outer_function", "my_inner_function"},
	},
}

// Sometimes it's nice to visualize these samples on a chronological timeline of
// the call stack using a trace visualizer UI. To do this we need to convert
// the samples into a list of start and end events for each function call. The
// events should be in a list order such that a nested function call's end event
// is before the enclosing call's end event. Assume call frames in the last
// sample haven't finished. The resulting events should use the Event type:

type EventKind string

const (
	EventKindStart EventKind = "start"
	EventKindEnd   EventKind = "end"
)

type Event struct {
	kind EventKind
	ts   float64
	name string
}

// an example list of samples that would emit the below events
var samples2 = []Sample{
	{
		ts:    7.5,
		stack: []string{"main"},
	},
	{
		ts:    9.2,
		stack: []string{"main", "my_fn"},
	},
	{
		ts:    10.7,
		stack: []string{"main"},
	},
}

func convertToTrace(samples []Sample) []Event {

	var res []Event

	if len(samples) == 0 {
		return res
	}

	prev := make(map[string]int)

	for i, fn := range samples[0].stack {
		res = append(res, Event{EventKindStart, samples[0].ts, fn})
		prev[fn] = i
	}

	for i := 1; i < len(samples); i++ {
		curr := make(map[string]int)
		for j, fn := range samples[i].stack {
			curr[fn] = j

			if prevDepth, ok := prev[fn]; !ok || prevDepth != j {
				res = append(res, Event{EventKindStart, samples[i].ts, fn})
			}

		}

		for fn, depth := range prev {
			if currDepth, ok := curr[fn]; !ok || currDepth != depth {
				res = append(res, Event{EventKindEnd, samples[i].ts, fn})
			}
		}

		prev = curr
	}

	return res
}
