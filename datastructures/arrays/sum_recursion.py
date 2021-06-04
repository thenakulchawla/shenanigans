
def sum(list):
    if len(list) == 0:
        return 0
    else:
        return list.pop(0) + sum(list)

if __name__ == "__main__":
    list = [1, 2, 3, 4]
    x = sum(list)
    print(x)