

def solve(nums, k):

    if len(nums) < k:
        return -1

    sum_init = 0

    for i in range(k):
        sum_init += nums[i]

    max_sum = sum_init

    for i in range(k, len(nums)):
        sum_init += nums[i] - nums[i-k]
        max_sum = max(max_sum, sum_init)

    return max_sum


if __name__ == "__main__":
    arr = [1, 4]
    print(solve(arr, 4))







