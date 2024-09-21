def triangle(first, second, third)
  sides = [first, second, third]
  case
  when sides.sum != 180 || sides.any? { |x| x.zero? }
    :invalid
  when sides.any?(90)
    :right
  when sides.any? { |x| x > 90 }
    :obtuse
  when sides.any? { |x| x < 90 }
    :acute
  end
end

p triangle(60, 70, 50) == :acute
p triangle(30, 90, 60) == :right
p triangle(120, 50, 10) == :obtuse
p triangle(0, 90, 90) == :invalid
p triangle(50, 50, 50) == :invalid
