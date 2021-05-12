
def arr_i_eq_i(arr):
    s = set(arr)
    for i in range(len(arr)):
        if i in s:
            arr[i] = i
        else:
            arr[i] = -1
    return arr


def arr_i_eq_i_swap(arr):

    i = 0
    while i < len(arr):
        if arr[i] >= 0 and arr[i] != i:
            arr[arr[i]], arr[i] = arr[i], arr[arr[i]]
        else:
            i += 1
    return arr


def move_zeroes(arr):
    count = 0
    for i in range(len(arr)):
        if arr[i] != 0:
            arr[count] = arr[i]
            count += 1

    while count < len(arr):
        arr[count] = 0
        count += 1

    return arr


def min_swaps_k(arr, k):
    count = 0
    n = len(arr)
    for i in range(n):
        if arr[i] <= k:
            count += 1

    bad = 0
    for i in range(count):
        if arr[i] > k:
            bad += 1

    ans = bad
    j = count
    for i in range(n):
        if j == n:
            break
        if arr[i] > k:
            bad -= 1
        if arr[j] > k:
            bad += 1

        ans = min(bad, ans)
        j += 1

    return ans


if __name__ == "__main__":
    li = [9, 7, 6, 5, -1, -1, 2, 3, 8, -1]
    li1 = [9, 7, 8, 0, 0, 8, 7, 6, 0, -1, 10]
    li3 = [2, 7, 9, 5, 8, 7, 4]
    print(min_swaps_k(li3, 5))
    # print(arr_i_eq_i_swap(li))
    # print(move_zeroes(li1))
