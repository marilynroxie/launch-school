flintstones = { "Fred" => 0, "Wilma" => 1, "Barney" => 2, "Betty" => 3, "BamBam" => 4, "Pebbles" => 5 }

# Create an array containing only two elements: Barney's name and Barney's number:

flintstones = flintstones.to_a
flintstones = flintstones[2]

# Though the following is the solution given, I don't remember assoc before now:

flintstones.assoc("Barney")
