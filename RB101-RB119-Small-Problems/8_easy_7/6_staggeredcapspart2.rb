def staggered_case(str)
  caps = false
  str.gsub(/[a-z]/i) do |char|
    caps = !caps
    caps ? char.upcase : char.downcase
  end
end

p staggered_case('I Love Launch School!') == 'I lOvE lAuNcH sChOoL!'
p staggered_case('ALL CAPS') == 'AlL cApS'
p staggered_case('ignore 77 the 444 numbers') == 'IgNoRe 77 ThE 444 nUmBeRs'
