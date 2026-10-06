from typing import List


def solveNQueens(n: int) -> List[List[str]]:
    # board = [[".", ".", ".", "."], [".", ".", ".", "."], [".", ".", ".", "."], [".", ".", ".", "."]]
    board = [["." for x in range(n)] for y in range(n)]
    # print(board)
    # print(board1)
    # if board == board1:
    #     print("WTF")
    #     return board
    # print()

    def is_safe(board, row, col):

        for i in range(col):
            if board[row][i] == 'Q':
                return False

        # upper diagonal on left side
        for i, j in zip(range(row, -1, -1), range(col, -1, -1)):
            if board[i][j] == 'Q':
                return False

        # lower left diagonal
        for i, j in zip(range(row, n, 1), range(col, -1, -1)):
            if board[i][j] == 'Q':
                return False

        return True

    def NQueenBacktrack(board, col):
        if col >= n:
            return True

        for i in range(n):
            if is_safe(board, i, col):
                board[i][col] = 'Q'
                if NQueenBacktrack(board, col + 1):
                    return True
                board[i][col] = '.'
        return False

    if not NQueenBacktrack(board, 0):
        print(False)
    return board


if __name__ == "__main__":
    x = solveNQueens(4)
    print(x)