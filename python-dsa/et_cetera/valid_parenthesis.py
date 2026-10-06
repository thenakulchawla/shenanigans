

def is_valid(s: str):

    stack = []

    for i in range(len(s)):
        if s[i] == "(":
            stack.append(s[i])
        elif s[i] == "{":
            stack.append(s[i])
        elif s[i] == "[":
            stack.append(s[i])
        elif s[i] == "]":
            if len(stack) == 0 or stack[len(stack)-1] != "[":
                return False
            elif stack[len(stack)-1] == "[":
                stack.pop()
        elif s[i] == ")":
            if len(stack) == 0 or stack[len(stack)-1] != "(":
                return False
            elif stack[len(stack)-1] == "(":
                stack.pop()
        elif s[i] == "}":
            if len(stack) == 0 or stack[len(stack)-1] != "{":
                return False
            elif stack[len(stack)-1] == "{":
                stack.pop()

    return len(stack) == 0


if __name__== "__main__":
    s = "(])"
    print(is_valid(s))