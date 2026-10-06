from collections import Counter


def permute_unique(nums):
    result = []

    def permutation(combination, counter):

        if len(combination) == len(nums):
            result.append(list(combination))
            return

        for num in counter:

            if counter[num] > 0:
                combination.append(num)
                counter[num] -= 1
                permutation(combination, counter)
                combination.pop()
                counter[num] += 1

    permutation([], Counter(nums))
    return result


if __name__ == "__main__":
    nums = [1, 1, 2]
    res = permute_unique(nums)
    print(res)
