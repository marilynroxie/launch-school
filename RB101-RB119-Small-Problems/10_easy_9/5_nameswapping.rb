def swap_name(str)
  str = str.split
  "#{str[1]}, #{str[0]}"
end

p swap_name('Joe Roberts') == 'Roberts, Joe'
