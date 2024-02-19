answer = 42

def mess_with_it(some_number)
  some_number += 8
end

new_answer = mess_with_it(answer)

p answer - 8

# The output is 34 because this is the result of answer, which is 42, - 8. The new_answer variable didn't change anything about answer as the method has its own scope.
