numbers = [1, 2, 3, 4, 5]

numbers.delete_at(1)

p numbers

# removes the integer at index 1, that is, 2

# => [1, 3, 4, 5]

numbers = [1, 2, 3, 4, 5]

numbers.delete(1)

p numbers

# removes the integer 1, that is, at index 0

# => [2, 3, 4, 5]

# Both are destructive despite not having a !
