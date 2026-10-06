
def spiral_order(mat):
    i, j = 0, 0

    N = len(mat) * len(mat[0])
    visited = [[False for i in range(len(mat[0]))] for j in range(len(mat))]
    ans = [mat[i][j]]

    count = 1
    visited[i][j] = True

    while count < N:
        while j+1 < len(mat[0]) and not visited[i][j+1]:
            j += 1
            ans.append(mat[i][j])
            visited[i][j] = True
            count += 1
        while i+1 < len(mat) and not visited[i+1][j]:
            i += 1
            ans.append(mat[i][j])
            visited[i][j] = True
            count += 1
        while j-1 >= 0 and not visited[i][j-1]:
            j -= 1
            ans.append(mat[i][j])
            visited[i][j] = True
            count += 1
        while i-1 >= 0 and not visited[i-1][j]:
            i -= 1
            ans.append(mat[i][j])
            visited[i][j] = True
            count += 1
    return ans


if __name__=="__main__":
    # matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    matrix = [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12]]
    output = spiral_order(matrix)
    print(output)