## General

# a comment

#=
a multiline
comment
=#

# use ? in the REPL to get the documentation for the function or object

# printing in the console:
println("jippie, we are doing OR-LAB")

## Variables ##
my_age = 28
typeof(my_age)

my_height = 1.84    
typeof(my_height)

🚂 = "locomotive"
typeof(🚂)



my_conditional = false
typeof(my_conditional)

my_symbol = :ez
typeof(my_symbol)

# converting in between
String(my_symbol)
Symbol(🚂)
Float64(my_age)
convert(Float64, my_age)

## What can you do with numbers? Basic math
2+2

x1 = 5
x2 = 2

sum = x1 + x2
product = x1 * x2
quotient = x1 / x2
power = x1^x2

# 5 + 1 * 2
x1 + 1 * x2

# (5 + 1) * 2
(x1 + 1) * x2

## What can you do with strings?
part1 = "OR-GDL is a lot of "
part2 = "fun."

part1*part2

merged_string = string(part1, part2)

split(merged_string, " ")

replace(merged_string, "fun" => "crap")

my_result = 5

"The result of my fancy calculation is $my_result"

"The square root of 4 is $(sqrt(4))"