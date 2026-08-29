

def can_jump(nums):

    max_len = nums[0]
    for i in range(len(nums)):
        if i > max_len:
            return False
        max_len = max(max_len, nums[i]+i)

    if max_len >= len(nums)-1:
        return True

    return False


if __name__ == "__main__":
    arr =[3,2,1,0,4]
    arr1= [1,0,1,0]
    x = can_jump(arr1)
    print(x)
