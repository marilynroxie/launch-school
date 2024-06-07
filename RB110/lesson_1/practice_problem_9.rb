{ a: "ant", b: "bear" }.map do |key, value|
  if value.size > 3
    value
  end
end

# The return is [nil, "bear"] because map returns a transformed array, and the size > 3 condition is only true for "bear", so "ant" evaluates as false, causing if to return nil implicitly.
# https://docs.ruby-lang.org/en/3.2/Enumerable.html#method-i-map
# https://docs.ruby-lang.org/en/3.2/Array.html#method-i-size
