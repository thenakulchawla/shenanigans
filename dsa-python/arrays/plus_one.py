def plus_one(digits):

    if digits[-1] < 9:
        digits[-1] = digits[-1] + 1
        return digits
    else:
        carry = 0
        for i in range(1, len(digits) + 1):
            if digits[-i] == 9:
                digits[-i] = 0
                carry = 1
            else:
                digits[-i] += 1
                carry = 0
                break

        if carry == 1:
            digits.insert(0, 1)

    return digits


if __name__=="__main__":
    digits = [0]
    # digits = [9, 9, 9]
    # digits = [4, 3, 2, 9]
    ans = plus_one(digits)
    print(ans)