
def do_xor(arr):
    ans = arr[0]
    for i in range(1, len(arr)):
        ans = ans ^ arr[i]

    return ans


if __name__ == "__main__":
    nums = [4, 1, 2, 1, 2]

    ans = do_xor(nums)
    print(ans)