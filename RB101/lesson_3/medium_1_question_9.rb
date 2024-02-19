def foo(param = "no")
  "yes"
end

def bar(param = "no")
  param == "no" ? "yes" : "no"
end

bar(foo)
# "no" since foo will always return "yes" and "yes" != "no" in bar's method
