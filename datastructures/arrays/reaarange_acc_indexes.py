def re_arrange(arr, index):
    n = len(arr)
    for i in range(len(index)):
        while i != index[i]:
            index_target = index[index[i]]
            arr_target = arr[index[i]]

            arr[index[i]] = arr[i]
            index[index[i]] = index[i]

            index[i] = index_target
            arr[i] = arr_target

    return arr, index


if __name__ == "__main__":
    """
    Given two integer arrays of same size, “arr[]” and “index[]”, 
    reorder elements in “arr[]” according to given index array. It is not allowed to given array arr’s length.
    Input:  arr[]   = [10, 11, 12];
            index[] = [1, 0, 2];
    Output: arr[]   = [11, 10, 12]
            index[] = [0,  1,  2] 
    """
    arr = [50, 40, 70, 60, 90]
    index = [3,  0,  4,  1,  2]
    arr_final, index_final = re_arrange(arr, index)
    print(index_final)
    print(arr_final)
