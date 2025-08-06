class Pet
  attr_accessor :animal, :name

  def initialize(species, name)
    @species = species
    @name = name
  end

  def to_s
    "a #{@species} named #{@name}"
  end
end

class Owner
  attr_accessor :name, :pets

  def initialize(name)
    @name = name
    @pets = []
  end

  def pet_add(pet)
    @pets << pet
  end

  def number_of_pets
    pets.size
  end

  def print_pets
    puts pets
  end
end

class Shelter
  def initialize
    @owners = {}
  end

  def adopt(owner, pet)
    owner.pet_add(pet)
    @owners[owner.name] = owner
  end

  def print_adoptions
    @owners.each_value do |owner|
      puts "#{owner.name} has adopted the following pets:"
      owner.print_pets
      puts
    end
  end
end

butterscotch = Pet.new("cat", "Butterscotch")
pudding = Pet.new("cat", "Pudding")
darwin = Pet.new("bearded dragon", "Darwin")
kennedy = Pet.new("dog", "Kennedy")
sweetie = Pet.new("parakeet", "Sweetie Pie")
molly = Pet.new("dog", "Molly")
chester = Pet.new("fish", "Chester")

phanson = Owner.new("P Hanson")
bholmes = Owner.new("B Holmes")

shelter = Shelter.new
shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)
shelter.print_adoptions
puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."
