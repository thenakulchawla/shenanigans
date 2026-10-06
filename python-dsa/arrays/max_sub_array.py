

def max_sub_aray(nums):

    max_overall = nums[0]
    curr_max = nums[0]

    for i in range(len(nums)):
        curr_max = max(curr_max + nums[i], nums[i])
        max_overall = max(curr_max, max_overall)

    return max_overall


if __name__=="__main__":
    arr = [-2, 1, -3, 4, -1, 2, 1, -5, 4]
    output = 6
    out = max_sub_aray(arr)
    print(out)