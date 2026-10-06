import heapq


def solve(intervals):
    n = len(intervals)

    if n == 0:
        return 0

    intervals.sort()

    free_rooms = []
    heapq.heappush(free_rooms, intervals[0][1])

    for i in range(1, n):
        if free_rooms[0] <= intervals[i][0]:
            heapq.heappop(free_rooms)

        heapq.heappush(free_rooms, intervals[i][1])

    return len(free_rooms)


if __name__ == "__main__":
    intervals = [[9,10],[4,9],[4,17]]
    x = solve(intervals)
    print(x)