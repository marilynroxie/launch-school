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
