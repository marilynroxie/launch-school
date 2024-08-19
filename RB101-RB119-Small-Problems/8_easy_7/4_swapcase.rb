def swapcase(str)
  str = str.split('')
  str.map do |char|
    if char =~ /[a-z]/
      char.upcase!
    elsif char =~ /[A-Z]/
      char.downcase!
    end
  end
  str.join("").to_s
end

p swapcase('PascalCase') == 'pASCALcASE'
p swapcase('Tonight on XYZ-TV') == 'tONIGHT ON xyz-tv'

