

def three_sum(nums):
    if len(nums) < 3:
        return []

    num_sorted = sorted(nums)
    list_to_return = []

    for i in range(len(num_sorted) - 2):
        if i > 0 and nums[i] == nums[i-1]:
            continue
        j = i+1
        k = len(nums) - 1
        while j != k:
            if k < len(nums) -1 and nums[k] == nums[k+1]:
                k -= 1

            if nums[i] + nums[j] + nums[k] == 0:
                temp = [nums[i], nums[j], nums[k]]
                list_to_return.append(temp)

            elif nums[i] + nums[j] + nums[k] > 0:
                k -=1
            elif nums[i] + nums[j] + nums[k] < 0:
                j += 1
    return list_to_return


if __name__ == "__main__":
    nums = [-1, 0, 1, 2, -1, -4]
    nums1 = three_sum(nums)
    print(nums1)