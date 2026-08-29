

def reverse(x):
    lower_limit = -(1 << 31)
    upper_limit = (1 << 31) - 1
    result = 0
    negative = False

    if x == 0:
        return 0

    if x < 0:
        negative = True
        x = x * -1

    while x:
        result = result * 10 + x % 10
        x = x //10

        if result > upper_limit and not negative:
            return 0

        if negative and result*-1 < lower_limit:
            return 0

    if negative:
        result = result * -1

    return result


def is_palindrome(x):
    if x < 0:
        return False

    return x == reverse(x)


if __name__ == "__main__":
    numb = -101
    is_it = is_palindrome(numb)
    print(is_it)