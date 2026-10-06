
def to_int(s: str):
    refer_map = {"I": 1, "V": 5, "X": 10, "L": 50, "C": 100, "D": 500, "M": 1000}
    result = 0

    for i in range(0, len(s ) -1):
        if refer_map[s[i]] < refer_map[s[ i +1]]:
            result -= refer_map[s[i]]
        else:
            result += refer_map[s[i]]

    result += refer_map[s[len(s) - 1]]

    return result


def to_roman(n: int):
    digits = [(1000, "M"), (900, "CM"), (500, "D"), (400, "CD"), (100, "C"),
              (90, "XC"), (50, "L"), (40, "XL"), (10, "X"), (9, "IX"),
              (5, "V"), (4, "IV"), (1, "I")]
    roman_num = []
    for value, symbol in digits:
        if n == 0:
            break
        count, n = divmod(n, value)
        roman_num.append(symbol * count)

    roman_str = "".join(roman_num)
    return roman_str



if __name__ == "__main__":
    s = "LVIII"
    num = to_int(s)
    s = to_roman(num)
    print(s)
