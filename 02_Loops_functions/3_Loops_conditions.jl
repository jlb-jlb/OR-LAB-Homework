### Loops ###

## For loop
# range as an iterator
for i in 1:5
    println("The current iteration is $i")
end

myarr = [5,10,12]
# a common way to iterator an array is to use 1:length(x)
for i in 1:length(myarr) # length(myarr) returns 3 resulting basically in 1:3
    println("The current iteration is $i and value is $(myarr[i])")
end

# `eachindex` also returns an iterator and has the same results als 1:length(emptyarray)
for i in eachindex(myarr)
    println(i)
end

# we can just iterate over the values of an array
for x in myarr
    println("The current value is $x")
end

# another way is to `enumerate`
# it returns the position and the value as a tuple
for (position,value) in enumerate(myarr)
    println("The current iteration is $position and value is $value")
end

# in a multidimensional array the iterator works rowwise
myarr = hcat(myarr, [1,2,3])
for (position,value) in enumerate(myarr)
    println("The current iteration is $position and value is $value")
end

# `zip` zips two (or more) equally long vectors together
# the result is a array of tuples (or pairs)
arr1 = ["a","b","c"]
arr2 = [1,2,3]
x = zip(arr1, arr2)
collect(zip(arr1, arr2)) # we need to call `collect` because zip returns an iterator that is not stored in memory yet

for (a1,a2) in zip(arr1, arr2)
    println("The first value $a1 comes from arr1 and the second value $a2 comes from arr2")
end

## While loop
i = 10
while i>=1
    println(i)
    i -= 1
end

i = 10
# we can also define a variable locally different
let i=1 
    while i<=5
        println(i)
        i += 1
    end
end
println(i)

### Conditions ###
## basics
true, false
1 == 1.0
2 != 2
!(2 == 2)
x = 2
mylist = [1,2,3,4]
# check if an element is in an array
x in mylist
x = 10
x in mylist


## subseting arrays based on a condition
# initiate an array with booleans
fill(true, 3)

boolarray = [true, false, true, false]
# use a boolean array to subset another array
mylist[boolarray]

bitarray = [1,2,3,4] .>= 3
mylist[bitarray]
mylist[mylist .>= 3]

## controling code flow with "if"
if true
    println("This is true")
end

if false
    println("This is not true")
end

# if, else, elseif
x = 1
if x >= 1
    println("x is greater than 0")
elseif x == 0
    println("x is zero")
else
    println("x is smaller than 0")
end

# short form for if statement
x = -1
x >= 0 ? (y = "positive") : (y = "negative")
# this is equal to
#if x >= 0
#    y = "positive"
#else
#    y = "negative"
#end
y

x = 1
# && is an "and"
x > 0 && println("x is greater than zero")

x = -11
# || is an "or "
x <= 0 || println("x is greater than zero")

for i in 1:5
    println(i)
    if i > 3
        break
    end
end

i = 4
if i > 3 println("Hi") end