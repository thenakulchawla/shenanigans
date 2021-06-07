

def reverse_string(s: str):
    return s[::-1]


def expand_from_middle(s: str, left: int, right: int):
    if s  == "" or left > right:
        return 0
    while left >= 0 and right < len(s) and s[left] == s[right]:
        left -= 1
        right += 1

    return right - left - 1


def longest_palindrome(s: str):
    start = 0
    end = 0

    for i in range(len(s)):
        len1 = expand_from_middle(s, i, i)
        len2 = expand_from_middle(s, i, i+1)
        length = max(len1, len2)
        if length < end-start:
            start = i - ((length -1)//2)
            end = i + length//2

    return s[start:end+1]


if __name__ == "__main__":
    strng = "babad"
    st = longest_palindrome(strng)
    print(st)