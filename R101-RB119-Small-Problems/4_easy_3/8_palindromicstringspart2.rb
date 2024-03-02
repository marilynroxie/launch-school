def palindrome?(str)
  str == str.reverse
end

def real_palindrome?(str)
  str = str.downcase.gsub(/\W/, "")
  palindrome?(str)
end

real_palindrome?("madam") == true
real_palindrome?("Madam") == true           # (case does not matter)
real_palindrome?("Madam, I'm Adam") == true # (only alphanumerics matter)
real_palindrome?("356653") == true
p real_palindrome?("356a653")
p real_palindrome?("123ab321")
