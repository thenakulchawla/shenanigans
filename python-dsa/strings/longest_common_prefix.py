

def longest_common_prefix(strs):
    prefix = ""

    if len(strs) == 0:
        return prefix

    if len(strs) == 1:
        return strs[0]

    for i in range(len(strs[0])):
        c = strs[0][i]
        for j in range(len(strs)):
            if len(strs[j]) - 1 < i or strs[j][i] != c:
                return prefix
            elif strs[j][i] == c and j == len(strs)-1:
                prefix += c
    return prefix


if __name__ == "__main__":
    strs1 = ["ab", "abcs"]
    pre = longest_common_prefix(strs1)
    print(pre)
