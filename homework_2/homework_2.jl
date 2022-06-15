# AUFGABE 1

using Pkg
# Pkg.status()
# # Pkg.generate("OR_LAB_homework")
# Pkg.activate("OR_LAB_homework")
# Pkg.status()
# Pkg.add("Random")
# Pkg.status()

using Random
Pkg.status()

Random.seed!(2345)

array_1 = rand(Float64, 3, 3) # Random FLoat 3x3 Matrix



# AUFGABE 2

array_2 = Array{Int64, 1}(0:5:50)
println(array_2)


array_3 = zeros(Int64, 1,11)
print(array_3[1])

for i in 1:length(array_3)
    print(i , "\t")
    print(array_3[i], "\t")
    array_3[i] = (i-1) * 5
    print(array_3[i], "\n")
end
println()


array_4 = collect(Int64,0:5:50)
array_4

# Iterieren mit enumerate
for (i, val) in enumerate(array_4)
    print(i, "\t", val, "\n")
end
println()


# if the sum of index and value is dividable by 5

for (i, val) in enumerate(array_4)
    if (i % 5 == 0) && (val % 5 == 0)
        print(i, "\t", val, "\n")
    end
end


# Write a while loop to create a boolean or bitarray that contains a true or 1, if the
# value of the array is even, and a false or 0, if not. Define the iterator for the while
# loop locally
bool_array = fill(false, length(array_4))

let i = 1
    while i <= length(array_4)
        if array_4[i] % 2 == 0
            bool_array[i] = true
        end
        i += 1
    end
end
println(bool_array)

#  Use the bitarray you just created so subset your original array. The subset should
#  be [0, 10, 20, 30, 40, 50], if you have done everything correctly

array_5 = array_4[bool_array]
println(array_5)


# Wrap the last code block that you just wrote (the one with the while loop to create
# the boolean or bitarray) in a function called is_even. The function should take an
# array as an input and return an array that contains a true or 1, if the value of the
# array is even, and a false or 0, if not (similar as above). Hint: Use the length()
# function to construct an array that has the same length as your input array and to
# dynamically define the iterator of your while loop.

function is_even(input_arr)
    bool_array_1 = fill(false, length(input_arr))
    i = 1
    while i <= length(input_arr)
        if input_arr[i] % 2 == 0
            bool_array_1[i] = true    
        end
        i += 1
    end
    return bool_array_1
end

print(is_even([1,2,3,4,5,5,4,4,4,]))
