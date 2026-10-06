
def find_min(arr, low, high):
    if high < low:
        return arr[0]
    if high == low:
        return arr[low]

    mid = int((high+low)/2)
    if mid < high and arr[mid] > arr[mid+1]:
        return arr[mid+1]
    if mid > low and arr[mid] < arr[mid-1]:
        return arr[mid]
    if arr[high] > arr[mid]:
        return find_min(arr, low, mid-1)
    return find_min(arr, mid+1, high)


def min_in_rotated_arr(arr):
    """
    find min in a sorted rotated array
    """
    return find_min(arr, 0, len(arr)-1)

if __name__ == "__main__":
    li = [4, 5, 6, 7, 8, 9, 10, 1, 2, 3]
    print(min_in_rotated_arr(li))
