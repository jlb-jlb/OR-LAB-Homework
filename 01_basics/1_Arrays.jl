## Dictionaries, Tuples, Arrays
# Dict: unordered
# Tuples: immutable

### Arrays (ordered, mutable) ###

## Construct/initialize arrays ##
# a vector is a one dimensional array
my_vector = [1,2,3]
typeof(my_vector)

# a two dimensional array is a matrix
my_matrix = [1 2 3; 4 5 6]

another_matrix = [6 5 4
                  3 2 1]

# 3 dimensional, using the rand function
my_array = rand(4, 3, 2)

# not only numbers
lab_tutors = ["lukas", "elmar", "karlo", "gero", "mario"]

# we can also mix different types
[1, "a", 6.8]

# arrays can also contain other arrays
["t", [1,2,3], 99]

# init a matrix with a certain value
zeros(3,3)
ones(Int, 3,3)
fill(5,2,3)

# or init an empty array and fill it
myemptyarray = zeros(Int, 3,3)
fill!(myemptyarray, 2)

# note the difference
another_emptyarray = []
fill!(another_emptyarray, 2)

# another useful constructor
range_array = collect(1:10)

# another constructor which create an array of the same size but without any meaningful values
similar(myemptyarray)


## Describe arrays ##
# ask for the dimension of an array
ndims(myemptyarray)

# get the size of the respective dimensions
size(myemptyarray)

# the number of elements inside a container (despite their dimension)
length(myemptyarray)


## Accessing and altering arrays ##
# Vectors
my_vector
# elements can be access by their index
my_vector[1]
# single elements can also be manipulated
my_vector[3] = 1
my_vector

# same works for matrices
myemptyarray
myemptyarray[1,1]
myemptyarray[1,1] = 0
myemptyarray

# adding items to a vector
append!(my_vector, [4,5,6])
vcat(my_vector, [7,8,9])

# adding items to a matrix
hcat(myemptyarray, [1; 2; 3])
vcat(myemptyarray, [1 2 3])

# or using keywords
lab_tutors
lab_tutors[end]
lab_tutors[end-1]

# pop function to delete items
popfirst!(lab_tutors)
lab_tutors

pop!(lab_tutors)
lab_tutors

# push function to add items
pushfirst!(lab_tutors, "yournamehere")
push!(lab_tutors, "anothernamehere")

## Some linear algebra ##
# remember the matrices we constructed in the beginning? 
my_matrix
another_matrix

# matrix multiplication (throws dimension error)
my_matrix*another_matrix

# a matrix can be transposed using `'`
another_matrix'

# now it works
my_matrix * another_matrix

# other useful stuff
arr1 = [10,21,3]
sort(arr1)
sort(arr1, rev=true)
maximum(arr1)
findmax(arr1)