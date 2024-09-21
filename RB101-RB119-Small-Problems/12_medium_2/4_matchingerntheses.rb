def balanced?(str)
  parens = str.chars.select { |x| x == "(" || x == ")" }
  count = 0
  parens.each do |paren|
    count += (paren == "(" ? 1 : -1)
    break if count < 0
  end
  count.zero?
end

p balanced?("What (is) this?") == true
p balanced?("What is) this?") == false
p balanced?("What (is this?") == false
p balanced?("((What) (is this))?") == true
p balanced?("((What)) (is this))?") == false
p balanced?("Hey!") == true
p balanced?(")Hey!(") == false
p balanced?("What ((is))) up(") == false
p balanced?("What ())(is() up") == false
