
def set_zeroes(mat):

    first_row = False
    first_col = False

    for i in range(len(mat[0])):
        if mat[0][i] == 0:
            first_row = True
            break

    for i in range(len(mat)):
        if mat[i][0] == 0:
            first_col = True
            break

    for i in range(1, len(mat)):
        for j in range(1, len(mat[0])):
            if mat[i][j] == 0:
                mat[i][0] = 0
                mat[0][j] = 0

    for i in range(1, len(mat)):
        for j in range(1, len(mat[0])):
            if mat[i][0] == 0 or mat[0][j] == 0:
                mat[i][j] = 0

    if first_row:
        for i in range(len(mat[0])):
            mat[0][i] = 0

    if first_col:
        for i in range(len(mat)):
            mat[i][0] = 0


if __name__=="__main__":
    # matrix = [[1, 1, 1], [1, 0, 1], [1, 1, 1]]
    matrix = [[0, 1, 2, 0], [3, 4, 5, 2], [1, 3, 1, 5]]
    set_zeroes(matrix)
    print(matrix)