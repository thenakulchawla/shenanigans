import sys


def three_sum(nums):
    if len(nums) < 3:
        return []

    nums_sorted = sorted(nums)
    list_to_return = []

    for i in range(len(nums_sorted) - 2):
        if nums_sorted[i] > 0:
            break
        if i != 0 and (nums_sorted[i] == nums_sorted[i-1]):
            continue

        j = i+1
        k = len(nums_sorted) - 1
        while j < k:

            if nums_sorted[i] + nums_sorted[j] + nums_sorted[k] == 0:
                temp = [nums_sorted[i], nums_sorted[j], nums_sorted[k]]
                list_to_return.append(temp)
                j += 1
                k -= 1
                while j < k and nums_sorted[j] == nums_sorted[j-1]:
                    j += 1

            elif nums_sorted[i] + nums_sorted[j] + nums_sorted[k] > 0:
                k -= 1
            elif nums_sorted[i] + nums_sorted[j] + nums_sorted[k] < 0:
                j += 1
    return list_to_return


def three_sum_closest(nums, target):
    if len(nums) == 3:
        return sum(nums)

    nums.sort()

    closest_sum = sys.maxsize

    i = 0
    while i < len(nums) - 2:
        low = i + 1
        high = len(nums) - 1

        while low < high:
            curr_sum = nums[i] + nums[low] + nums[high]

            if abs(target- curr_sum) < abs(target - closest_sum):
                closest_sum = curr_sum

            if curr_sum == target:
                return curr_sum
            elif curr_sum < target:
                low += 1
            else:
                high -= 1

        i += 1

    return closest_sum

def three_sum(nums, target):
  if len(nums) < 3:
    return False

  nums.sort()
  n = len(nums)
  for i in range(n-2):
    if i > 0 and nums[i] == nums[i-1]:
      continue
    low = i+1
    high = n-1
    
    while low< high:
      current_sum = nums[i] + nums[low] + nums[high]
      if current_sum == target:
        return True
      elif current_sum > target:
        high -= 1
      else:
        low += 1
  
  return False


if __name__ == "__main__":
    nums = [-2, 0, 0, 2, 2]
    # nums1 = three_sum(nums)

    nums_for_closest = [-1,2,1,-4]
    target = 1

    number = three_sum_closest(nums_for_closest, target)
    print(number)
