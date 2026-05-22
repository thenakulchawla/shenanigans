def is_palindrome(s):
  left = 0
  right = len(s) - 1
  while left <= right:
    print("left: " + s[left])
    print("right: " + s[right])
    if s[left] != s[right]:
      print("left: " + s[left])
      print("right: " + s[right])
      return False
    left += 1
    right -= 1
  
  # Replace this placeholder return statement with your code
  return False

if __name__=="__main__":
  is_palindrome("kaYak")