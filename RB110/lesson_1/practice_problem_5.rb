hash = { a: "ant", b: "bear" }
hash.shift

# Consulting the docs - https://docs.ruby-lang.org/en/3.2/Hash.html#method-i-shift - and testing it out in irb can demonstrate that shift will remove the first hash entry and return "a 2-element Array containing the removed key and value," so in this case the return would be [:a, "ant"]. This will mutate hash.
