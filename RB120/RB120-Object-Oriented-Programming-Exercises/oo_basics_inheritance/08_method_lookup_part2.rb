class Animal
end

class Cat < Animal
end

class Bird < Animal
end

cat1 = Cat.new
p cat1.class.ancestors
cat1.color

# Method lookup path:

# Cat -> Animal -> Object -> Kernel -> BasicObjeect
