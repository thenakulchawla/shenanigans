import heapq
import math


class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


def loop_test(n: int):
    for i in range(n):
        i *= i
        print(i)


def while_test(n):
    i = 2
    j = 1
    while i < n:
        i *= i
        print(i)
        j += 1
        print("number of iterations " + str(j))


def reverse_loop(n):
    nums = []
    for i in range(n, 0, -1):
        nums.append(i)

    return nums


def what_is_this():
    left = TreeNode(1)
    right = TreeNode(2)

    x = TreeNode(0, left, right)
    y = {x}
    print(type(y))


def is_palindrome(s, start, end):
    if s[start:end] == s[start:end][::-1]:
        return True
    return False

def test_palindrome():
    x = "racecar"
    res = is_palindrome(x, 0, len(x))
    print(res)

def heap_test(nums, k):
    return heapq.nsmallest(k, nums)[-1]


def bitwise_n(n):
    print(bin(n))
    print(bin(n-1))
    print(bin(n&n-1))
    return


def bit_unpack(n):
    print(bin(n))

    ret = 0
    power = 31
    while n:
        print(n&1)
        ret += (n&1) << power
        n = n >> 1
        # print(bin(ret))
        power -= 1

    return


def sq_root(n):
    return math.sqrt(n)


def sort_string(s):
    k = ''.join(sorted(s))
    print(k)


def test_str():

    s = "nakul"
    s = s[:-1]
    print(s)


def set_str():
    s = 'nakullukan'
    k = set(list(s))
    print(list(k))


if __name__ == "__main__":
    test_palindrome()


