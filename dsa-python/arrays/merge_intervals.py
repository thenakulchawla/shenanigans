
def merge_intervals(nums):
    ans = []
    nums.sort()
    ans.append(nums[0])

    for i in range(1, len(nums)):
        if nums[i][0] <= ans[-1][1]:
            ans[-1][1] = max(nums[i][1], ans[-1][1])
        else:
            ans.append(nums[i])

    return ans


if __name__=="__main__":
    # intervals = [[1, 3], [2, 6], [8, 10], [15, 18]]
    # intervals = [[1,4], [4,5]]
    intervals = [[1, 4], [2, 3]]
    output = merge_intervals(intervals)
    print(output)

