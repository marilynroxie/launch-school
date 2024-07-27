def cleanup(str)
   str.gsub(/[^a-z]+/, " ")
end

p cleanup("---what's my +*& line?") == ' what s my line '

