

def insert_intervals(intervals, new_interval):

    newIntervals = []
    newIntervals.append(new_interval)

    for interval in intervals:

        if interval[1] < newIntervals[-1][0]:
            backup = newIntervals[-1]
            newIntervals[-1] = interval
            newIntervals.append(backup)
        elif interval[0] <= newIntervals[-1][1]:
            newIntervals[-1][0] = min(interval[0], newIntervals[-1][0])
            newIntervals[-1][1] = max(interval[1], newIntervals[-1][1])
        else:
            newIntervals.append(interval)

    return newIntervals


if __name__ == "__main__":
    # intervals = [[1, 3], [2, 6], [8, 10], [15, 18]]
    # intervals = [[1, 3], [6, 9]]
    # newInterval = [2, 5]
    intervals = [[1, 2], [3, 5], [6, 7], [8, 10], [12, 16]]
    newInterval = [4, 8]
    output = insert_intervals(intervals, newInterval)
    print(output)