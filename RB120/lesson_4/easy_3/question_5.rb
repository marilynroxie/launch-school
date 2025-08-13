class Television
  def self.manufacturer
    # method logic
  end

  def model
    # method logic
  end
end

tv = Television.new
tv.manufacturer #NoMethodError
tv.model # Method logic

Television.manufacturer # Method logic would execute
Television.model # NoMethodError
