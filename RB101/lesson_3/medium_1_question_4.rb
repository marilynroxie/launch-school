def rolling_buffer1(buffer, max_buffer_size, new_element)
  buffer << new_element
  buffer.shift if buffer.size > max_buffer_size
  buffer
end

def rolling_buffer2(input_array, max_buffer_size, new_element)
  buffer = input_array + [new_element]
  buffer.shift if buffer.size > max_buffer_size
  buffer
end

# In rolling_buffer1, the original buffer object, modified if necessary, is returned. Its side effect is modifying the buffer array as well as returning the result of the modification.

# In rolling_buffer2, buffer is a new object set to the input_array + the new element. input_array is not mutated.
