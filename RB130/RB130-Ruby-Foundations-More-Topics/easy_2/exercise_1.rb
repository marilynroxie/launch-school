def step(starting, ending, step)
  current_value = starting
  until current_value > ending
    yield(current_value)
    current_value = starting += step
  end
end

step(1, 10, 3) { |value| puts "value = #{value}" }
