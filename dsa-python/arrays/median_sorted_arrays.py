

def find_median(nums1, nums2):
    total_elements = len(nums1) + len(nums2)
    median_element = total_elements //2
    return median_element



if __name__ == "__main__":
    nums1 = [1, 3]
    nums2 = [2, 4]
    num = find_median(nums1, nums2)
    print(num)