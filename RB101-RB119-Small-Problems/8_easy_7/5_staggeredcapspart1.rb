def staggered_case(str)
  str = str.split("")
  str = str.each_with_index do |x, index|
    index.even? ? x.upcase! : x.downcase!
    end
  str.join
end

p staggered_case('I Love Launch School!') == 'I LoVe lAuNcH ScHoOl!'
p staggered_case('ALL_CAPS') == 'AlL_CaPs'
p staggered_case('ignore 77 the 444 numbers') == 'IgNoRe 77 ThE 444 NuMbErS'
