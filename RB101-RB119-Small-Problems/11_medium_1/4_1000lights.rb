def thousand_lights(n)
  (1..Math.sqrt(n).to_i).map do |i|
    i ** 2
  end
end

p thousand_lights(5) == [1, 4]
p thousand_lights(1000) == [1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 121, 144, 169, 196, 225, 256, 289, 324, 361, 400, 441, 484, 529, 576, 625, 676, 729, 784, 841, 900, 961]
