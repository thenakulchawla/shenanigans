
def inorder(node, arr):
    if node is None:
        return

    inorder(node.left, arr)
    arr.append(node.val)
    inorder(node.right, arr)