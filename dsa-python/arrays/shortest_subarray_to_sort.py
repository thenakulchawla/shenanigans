

def solve(nums):
    flag = False
    start_pos = 0
    end = 0
    biggest_num = nums[0]
    smallest_num = float('inf')
    n = len(nums)

    for i in range(n):
        if nums[i] > biggest_num:
            biggest_num = nums[i]

        if not flag and nums[i] < biggest_num:
            flag = True

        if flag:
            smallest_num = min(smallest_num, nums[i])

        if nums[i] < biggest_num:
            end = i

    if not flag:
        return 0

    for i in range(n):
        if smallest_num < nums[i]:
            start_pos = i
            break

    res = end - start_pos + 1
    return res


if __name__ == "__main__":
    nums = [2]
    x = solve(nums)
    print(x)
