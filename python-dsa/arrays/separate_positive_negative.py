def separate(arr):
    i=0
    n = len(arr)-1
    j = n
    while True:
        while i < n and arr[i] < 0:
            i += 1
        while j > 0 and arr[j] > 0:
            j -= 1

        if i < j:
            arr[i], arr[j] = arr[j], arr[i]
        else:
            break
    return arr

if __name__ == "__main__":
    """
    Input:  [12 11 -13 -5 6 -7 5 -3 -6]
    Output: [-13 -5 -7 -3 -6 12 11 6 5]
    """
    arr = [12, 11, -13, -5, 6, -7, 5, -3 -6]
    print(separate(arr))
