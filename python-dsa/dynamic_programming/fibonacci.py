

def solve(n):
    if n <=1:
        return n
    return solve(n-1) + solve(n-2)


if __name__== "__main__":
    x = solve(10)
    print(x)