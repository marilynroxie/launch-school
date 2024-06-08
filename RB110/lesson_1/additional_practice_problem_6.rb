flintstones = %w(Fred Barney Wilma Betty BamBam Pebbles)

flintstones.map! { |element| element[0, 3] }
