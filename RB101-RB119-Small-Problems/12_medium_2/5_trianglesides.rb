def triangle(first, second, third)
  sides = [first, second, third].sort
  case
  when sides[0] <= 0 || sides[0] + sides[1] <= sides[2]
    :invalid
  when sides.uniq.length == 1
    :equilateral
  when sides.uniq.length == 2
    :isosceles
  else
    :scalene
  end
end

p triangle(3, 3, 3) == :equilateral
p triangle(3, 3, 1.5) == :isosceles
p triangle(3, 4, 5) == :scalene
p triangle(0, 3, 3) == :invalid
p triangle(3, 1, 1) == :invalid
