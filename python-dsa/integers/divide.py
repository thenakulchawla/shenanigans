

def divide(dividend, divisor):

    if dividend == 0:
        return 0

    if dividend == -1*(2**31) and divisor == -1:
        return 2**31 - 1

    sign = -1 if (dividend < 0) ^ (divisor < 0) else 1

    if dividend < 0:
        dividend = -dividend

    if divisor < 0:
        divisor = -divisor

    quotient = 0
    while dividend >= divisor:

        value = divisor
        powerofTwo = 1

        while value + value < dividend:
            value += value
            powerofTwo += powerofTwo

        quotient += powerofTwo
        dividend -= value

    return quotient*sign


if __name__=="__main__":
    dividend = 2147483647
    divisor = 1
    print(divide(dividend, divisor))