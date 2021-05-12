def reverse(arr, i, j):
    while i < j:
        arr[i], arr[j] = arr[j], arr[i]
        i += 1
        j -= 1


def right_using_reverse(arr, d, n):
    reverse(arr, 0, n-1)
    reverse(arr, 0, d-1)
    reverse(arr, d, n-1)
    return arr


def using_reverse(arr, d, n):
    reverse(arr, 0, d-1)
    reverse(arr, d, n-1)
    reverse(arr, 0, n-1)
    return arr


def find_pivot(arr, low, high):
    if high < low:
        return -1
    if high == low:
        return low

    mid = int((high - low)/2 + low)

    if mid < high and arr[mid] > arr[mid+1]:
        return mid
    if mid > low and arr[mid] < arr[mid-1]:
        return mid-1
    if arr[low] >= arr[mid]:
        return find_pivot(arr, low, mid-1)
    return find_pivot(arr, mid+1, high)


def binary_search(arr, low, high, number):
    if high < low:
        return -1

    mid = int((high - low)/2 + low)
    if arr[mid] == number:
        return mid
    if arr[mid] < number:
        return binary_search(arr, mid+1, high, number)
    return binary_search(arr, low, mid-1, number)


def search_in_sorted_rotated(arr, number):
    n = len(arr)
    pivot = find_pivot(arr, 0, n-1)

    if pivot == -1:
        return binary_search(arr, 0, n-1, number)

    if arr[pivot] == number:
        return pivot
    if arr[0] <= number:
        return binary_search(arr, 0, pivot-1, number)
    return binary_search(arr, pivot+1, n-1, number)


def pair_in_sorted_rotated(arr, sum_two):
    n = len(arr)
    pivot = find_pivot(arr, 0, n-1)

    left = (pivot + 1) % n
    right = pivot

    while left != right:
        if arr[left] + arr[right] == sum_two:
            return True
        if arr[left] + arr[right] < sum_two:
            left = (left + 1) % n
        else:
            right = (n + right - 1) % n
    return False


def using_shift(arr, d, n):
    p = n - d
    for i in range(p):
        arr.append(arr.pop(0))
    return arr


def maximize_arr_sum_by_rotation(arr):
    """
    Maximize sum of i*arr[i]
    """
    arrSum = 0
    currVal = 0
    n = len(arr)
    for i in range(n):
        arrSum = arrSum + arr[i]
        currVal = currVal + (i*arr[i])

    maxVal = currVal

    for j in range(1, n):
        currVal = currVal + arrSum - (n*arr[n-j])
        if currVal > maxVal:
            maxVal = currVal

    return maxVal





if __name__ == "__main__":
    li = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    li1 = [5, 6, 7, 2, 3, 4]
    li2 = [2, 1]
    print(right_using_reverse(li, 3, 10))
