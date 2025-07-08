=begin
Given 2 strings, find out if there is a substring that appears in both strings. Return true if you find a substring that appears in both strings, or false if not. Only consider substrings that are longer than one letter long.
=end

def substr_test(str1, str2)
  substrings1 = []

  (0..str1.length - 1).each do |start_idx|
    (start_idx..str1.length).each do |end_idx|
      substrings1 << str1[start_idx..end_idx] if str1[start_idx..end_idx].size > 1
    end
  end

  (0..str2.length - 1).each do |start_idx|
    (start_idx..str2.length).each do |end_idx|
      if str2[start_idx..end_idx].size > 1
        return true if substrings1.include?(str2[start_idx..end_idx])
      end
    end
  end

  false
end

p substr_test("Something", "Fun") == false
p substr_test("Something", "Home") == true
p substr_test("Something", "") == false
p substr_test("", "Something") == false
p substr_test("Banana", "banana") == true
p substr_test("test", "lllt") == false
p substr_test("", "") == false
p substr_test("1234567", "541256") == true
p substr_test("supercalifragilisticexpialidocious", "SoundOfItIsAtrociou") == true
