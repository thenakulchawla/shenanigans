import heapq


def simple_sort(arr, k):
    arr.sort()
    return arr[k-1]


def using_heap(arr, k):
    heapq.heapify(arr)
    for i in range(k-1):
        heapq.heappop(arr)
    return heapq.heappop(arr)


if __name__ == "__main__":
    """
    Input: arr[] = {7, 10, 4, 3, 20, 15} 
    k = 3 
    Output: 7
    
    Input: arr[] = {7, 10, 4, 3, 20, 15} 
    k = 4 
    Output: 10 
    """
    arr = [7, 10, 4, 3, 20, 15]
    k = 3
    simple = simple_sort(arr, k)
    heap = using_heap(arr, k)
    print(simple, heap)