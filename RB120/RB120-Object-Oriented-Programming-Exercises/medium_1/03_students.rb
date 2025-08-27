class Student
  def initialize(name, year)
    @name = name
    @year = year
  end
end

class Graduate < Student
  def initialize(name, year, parking)
    super(name, year)
    @parking = parking
  end
end

class Undergraduate < Student
end

# Though shown in the solution, there is no need for initialize in the Undergraduate class, because it inherits from Student and the parameters are the same
