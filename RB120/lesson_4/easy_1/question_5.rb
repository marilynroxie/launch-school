class Fruit
  def initialize(name)
    name = name
  end
end

class Pizza
  def initialize(name)
    @name = name
  end
end

# The Pizza class would create an object that has an instance variable. The initialize in the Fruit class only has a local variable, whereas Pizza's initialize has @name, which is an instance variable.
