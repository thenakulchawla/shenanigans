

def mergesort(nums):

    if len(nums) > 1:

        mid = len(nums)//2

        L = nums[:mid]
        R = nums[mid:]

        mergesort(L)
        mergesort(R)

        i = j = k = 0

        while i < len(L) and j < len(R):
            if L[i] < R[j]:
                nums[k] = L[i]
                i += 1
            else:
                nums[k] = R[j]
                j += 1
            k += 1

        while i < len(L):
            nums[k] = L[i]
            i += 1
            k += 1

        while j < len(R):
            nums[k] = R[j]
            j += 1
            k += 1


if __name__ == "__main__":
    nums = [3, 2, 4, 5, 8, 7, 5, 9]

    one = [1, 2, 5, 6]
    two = [3, 4, 5, 6]
    #merge(one, two)
    mergesort(nums)
    print(nums)
