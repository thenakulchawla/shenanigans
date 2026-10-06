
def qsort(input_list):
    if len(input_list) < 2:
        return input_list
    else:
        pivot = input_list[0]
        less = []
        more = []
        for i in range(1, len(input_list)):
            if input_list[i] <= pivot:
                less.append(input_list[i])

            if input_list[i] > pivot :
                more.append(input_list[i])

        return qsort(less) + [pivot] + qsort(more)


def insertion_sort(input_list):
    for j in range(1, len(input_list)):
        key = input_list[j]
        i = j-1
        while i >= 0 and input_list[i] > key:
            input_list[i+1] = input_list[i]
            i = i - 1
        input_list[i+1] = key
    return input_list


if __name__=="__main__":
    listToBeSorted = [2, 5, 8, 7, 6, 9, 0, 12, 10, 15, 11]
    sorted_list = qsort(listToBeSorted)
    # sorted_list = insertion_sort(listToBeSorted)
    print(sorted_list)
