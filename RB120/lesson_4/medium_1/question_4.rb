class Greet
  def greet(str)
    puts str
  end
end

class Hello < Greet
  def hi
    greet("Hello")
  end
end

class Goodbye < Greet
  def bye
    greet("Goodbye")
  end
end

my_hello = Hello.new
my_hello.hi
