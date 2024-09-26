def letter_counter(str)
  str.split.each_with_object({}) do |word, count|
    if count.key?(word.size)
      count[word.size] += 1
    else
      count[word.size] = 1
    end
  end
end

p letter_counter("Four score and seven.") == { 3 => 1, 4 => 1, 5 => 1, 6 => 1 }
p letter_counter("Hey diddle diddle, the cat and the fiddle!") == { 3 => 5, 6 => 1, 7 => 2 }
p letter_counter("What's up doc?") == { 6 => 1, 2 => 1, 4 => 1 }
p letter_counter("") == {}

# Further Exploration

# Take some time to read about Hash::new to learn about the different ways to initialize a hash with default values.

hash = Hash.new(0) # sets default values for future keys to 0
hash = Hash.new # sets default value for future keys to nil
hash = Hash.new { |hash, key| hash[key] = [] } # using a block
