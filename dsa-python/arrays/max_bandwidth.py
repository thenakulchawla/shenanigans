"""
For n tv channels, given show start time, end time & bandwidth needed for each channels,
find the maximum bandwidth required at peak.
a show represented as [1,30,2] meaning [show-start-time, show-end-time, bandwidth-needed].
"""


def solve(intervals):

    res = []
    n = len(intervals)
    intervals.sort()
    res.append(intervals[0])

    for i in range(1, n):

        if intervals[i][0] < res[-1][1]:
            res[-1][1] = max(res[-1][1], intervals[i][1])
            res[-1][2] += intervals[i][2]
        else:
            res.append(intervals[i])

    max_band = 0

    for i in range(len(intervals)):

        max_band = max(max_band, intervals[i][2])

    return max_band


if __name__== "__main__":
    intervals = [[1, 30, 2], [31, 60, 4], [61, 120, 3], [1, 20, 2],[21, 40, 4],[41,60,5],[61,120,3], [1,60,4],[61,120,4]]
    x = solve(intervals)
    print(x)