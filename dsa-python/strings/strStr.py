
def str_str(haystack: str, needle: str):

    if len(needle) == 0:
        return 0

    for i in range(len(haystack)):
        if haystack[i] == needle[0]:
            n = len(needle)
            check = haystack[i:i+n]
            if check == needle:
                return i
    return -1


if __name__=="__main__":
    haystack = ""
    needle = "a"
    i = str_str(haystack, needle)
    print(i)
