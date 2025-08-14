class Computer
  attr_accessor :template

  def create_template
    @template = "template 14231"
  end

  def show_template
    template
  end
end

# vs

class Computer
  attr_accessor :template

  def create_template
    @template = "template 14231"
  end

  def show_template
    self.template
  end
end

# There is no different; self is unnecessary and should be avoided because it isn't required for the code to function.
