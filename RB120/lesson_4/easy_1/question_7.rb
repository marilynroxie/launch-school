class Cat
  attr_accessor :type, :age

  def initialize(type)
    @type = type
    @age = 0
  end

  def make_one_year_older
    self.age += 1
  end
end

my_cat = Cat.new("calico")

p my_cat.age

my_cat.make_one_year_older

p my_cat.age

# self is referring to the calling object, in this case, the instance of the Cat class
