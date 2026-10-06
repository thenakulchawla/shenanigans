

def atoi(s):
    num = 0
    negative = False
    upper_limit = (1 << 31) -1
    lower_limit = -(1 << 31)

    s = s.lstrip()
    if s == "":
        return 0

    if s[0] == "-":
        negative = True
        s = s[1:]
    elif s[0] == "+":
        s = s[1:]

    for c in s:
        if c.isdigit():
            num = num * 10 + int(c)
            if num > upper_limit and not negative:
                return upper_limit
        else:
            break

    if negative:
        num = num * -1
        if num < lower_limit:
            return lower_limit

    return num


if __name__ == "__main__":
    numb = "-91283472332"
    num = atoi(numb)
    print(num)