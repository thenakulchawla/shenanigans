from inorder_traversal import inorder
from node import Node


def insert(node, key, arr):
    if node is None:
        root = Node(key)
        arr.append(root.val)
        return arr

    q = [node]

    while len(q):
        temp = q[0]
        q.pop(0)

        if temp.left is None:
            temp.left = Node(key)
            break
        else:
            q.append(temp.left)

        if temp.right is None:
            temp.right = Node(key)
            break
        else:
            q.append(temp.right)


if __name__ == "__main__":
    root = Node(10)
    root.left = Node(11)
    root.left.left = Node(7)
    root.right = Node(9)
    root.right.left = Node(15)
    root.right.right = Node(8)

    arr = []

    print("Inorder traversal before insertion:", end=" ")
    inorder(root, arr)
    print(arr)

    key = 12
    insert(root, key, arr)

    arr1 = []
    root1 = None
    insert(root1, 12, arr1)
    inorder(root1, arr1)
    print(arr1)

    arr2 = []
    print("Inorder traversal after insertion:", end=" ")
    inorder(root, arr2)
    print(arr2)
