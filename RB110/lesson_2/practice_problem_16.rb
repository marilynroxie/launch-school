def uuid
  hex_chars = ('0'..'9').to_a.concat(('a'..'f').to_a)
  sections = [8, 4, 4, 4, 12]

  sections.map! do |element|
    element.times.map { hex_chars.sample }.join
  end

  sections.join('-')
end
