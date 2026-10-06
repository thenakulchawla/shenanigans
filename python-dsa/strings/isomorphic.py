
def is_isomorphic(s: str, t:str):
    dict_s = {}
    dict_t = {}
    for i in range(len(s)):
        if s[i] not in dict_s and t[i] not in dict_t:
            dict_s[s[i]] = t[i]
            dict_t[t[i]] = s[i]
        elif s[i] not in dict_s and t[i] in dict_t:
            return False
        elif s[i] in dict_s and t[i] not in dict_t:
            return False
        elif dict_s[s[i]] != t[i]:
            return False

    return True


if __name__ == "__main__":
    a = "foo"
    b = "bar"
    c = is_isomorphic(a, b)
    print(c)