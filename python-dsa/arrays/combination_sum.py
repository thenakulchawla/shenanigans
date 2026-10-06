

def combination_sum(candidates, target):

    ans = []

    def helper(candidates, start, curr_target, arr):
        if curr_target == 0:
            ans.append(list(arr))
            return
        else:
            for i in range(start, len(candidates)):
                if curr_target < candidates[i]:
                    continue
                else:
                    arr.append(candidates[i])
                    helper(candidates, i, curr_target-candidates[i], arr)
                    arr.pop()

    helper(candidates, 0, target, [])
    return ans


if __name__ == "__main__":
    candidates = [2, 3, 6, 7]
    target = 7
    output = combination_sum(candidates, target)
    print(output)