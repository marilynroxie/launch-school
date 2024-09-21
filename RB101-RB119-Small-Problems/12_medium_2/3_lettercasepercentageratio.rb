def letter_percentages(str)
  {
    lowercase: (str.count("a-z").to_f / str.length * 100).round(1),
    uppercase: (str.count("A-Z").to_f / str.length * 100).round(1),
    neither: ((str.length - str.count("a-z") - str.count("A-Z")).to_f / str.length * 100).round(1),
  }
end

p letter_percentages("abCdef 123") == { lowercase: 50.0, uppercase: 10.0, neither: 40.0 }
p letter_percentages("AbCd +Ef") == { lowercase: 37.5, uppercase: 37.5, neither: 25.0 }
p letter_percentages("123") == { lowercase: 0.0, uppercase: 0.0, neither: 100.0 }
p letter_percentages("abcdefGHI") == { :lowercase => 66.7, :uppercase => 33.3, :neither => 0.0 }

# Further exploration is incorporated for last example to round
