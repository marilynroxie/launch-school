# Question 2

# While ! often (but not always) indicates a destructive method, and methods named with ? often return a boolean result, but Ruby as a language does not enforce these commonly-understood conventions, rather they are established by developers.

# Exclamation point convention is covered here:

# https://rubystyle.guide/#dangerous-method-bang

# Question mark convention is covered here:

# https://rubystyle.guide/#bool-methods-qmark

# You can't expect all methods ending with ! to be destructive, nor all methods ending with ? to return booleans.

# != does not equal is commonly used in conditionals or comparisons

# ! flips boolean falue e.g. !true becomes false; using this with variables however can create confusion such as using !user_name to mean if user_name is false

user_name = false
puts "yes" if !user_name

# ? before something - I'm not aware of where this is done in Ruby, if at all

# ? also appears in ternaries e.g.
true ? "yes" : "no"

# !!user_name returns the boolean value
