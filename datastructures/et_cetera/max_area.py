# question -> https://leetcode.com/problems/container-with-most-water/


def max_area(height):
    i = 0
    j = len(height) - 1

    max_a = min(height[i], height[j]) * (j - i)

    while i < j:
        area = min(height[i], height[j]) * (j - i)
        max_a = max(area, max_a)
        if height[i] < height[j]:
            i += 1
        else:
            j -= 1
    return max_a


if __name__ == "__main__":
    arr = [1, 8, 6, 2, 5, 4, 8, 3, 7]
    m_a = max_area(arr)
    print(m_a)

