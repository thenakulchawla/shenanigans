import array


def print_array(arr):
    for i in range(len(arr)):
        print(arr[i])


def create_array():
    arr = array.array('I', [1, 2, 3, 1, 5])
    return arr


def create_second_array():
    arr = array.array('I', [4, 5, 6, 7, 7])
    return arr


def print_first_occurance(number, arr):
    print(arr.index(number))


def print_reverse_array(arr):
    arr.reverse()
    print_array(arr)


def count_occurances(arr, number):
    print(arr.count(number))


def extend_array(arr1, arr2):
    arr1.extend(arr2)


def create_list():
    li = [1, 2, 3]
    return li


def append_list_to_array(arr, li):
    arr.fromlist(li)
    return arr


def to_list(arr):
    li = arr.tolist()
    return li


if __name__ == "__main__":
    arr1 = create_array()
    arr2 = create_second_array()
    li1 = create_list()
    arr3 = append_list_to_array(arr1, li1)
    li4 = to_list(arr3)
    print_array(li4)
