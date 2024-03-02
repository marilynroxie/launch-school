def palindrome?(str)
  str == str.reverse
end

def real_palindrome?(str)
  str = str.downcase.gsub(/\W/, "")
  palindrome?(str)
end
