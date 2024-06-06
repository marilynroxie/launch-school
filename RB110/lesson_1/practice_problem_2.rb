["ant", "bat", "caterpillar"].count do |str|
  str.length < 4
end

# Docs can be consulted to find out count's return: https://docs.ruby-lang.org/en/3.3/Array.html#method-i-count ("With no argument and a block given, calls the block with each element; returns the count of elements for which the block returns a truthy value:") in addition to testing in irb. In this case, the return value is 2 because "ant" and "bat" both have a length of less than 4.
