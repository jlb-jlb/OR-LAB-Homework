### Data handling with Data Frames


using DataFrames
using CSV
using Statistics

## Constructing a data frame
# from a matrix
mDf = [
    350 0.225 0.153 0.162
    600 0.225 0.162 0.126
]
df = DataFrame(mDf, :auto)
# add column names
newnames = vec(string.(["sc_"], [1 2 3]))
pushfirst!(newnames, "p_max")
rename!(df, newnames)
# add ID column
df.id = 1:nrow(df)
# and move it to the front
select!(df, "id", :)
# or add the plants by names
df.plant = ["Seattle", "San Diego"]

# or constructing it directly
df1 = DataFrame("id" => collect(1:2),
               "p_max" => [350.0, 600.0],
               "sc_1" => [0.225, 0.225],
               "sc_2" => [0.153, 0.162],
               "sc_3" => [0.162, 0.126],
               "plant" => ["Seattle", "San Diego"])

# or using CSV:
df2 = CSV.read("04_DataWrangling/dataset_small.csv", DataFrame)

## Accessing attributes of a data frame

# describe gives us an overview on the data
describe(df)
# but can also be specified
describe(df, sum => "sum", mean => "mean")
# accessing attributes
nrow(df) # number of rows
ncol(df) # number of columns
size(df) # both
names(df) # get colnames

# accessing columns
df.plant # direct access
df."plant" # direct access
df[:,:plant] # copy
df[:,6] # copy
df[!,:plant] # direct access in matrix notation
# accessing rows
df[2,:]
# both:
df[2,:plant]

# filter / search for specific data
# using index notation
df[df.plant .== "Seattle", :]
# using filter function (faster)
filter(:plant => ==("Seattle"), df) # take elements of :plant and pass it to x -> x == "Seattle" function
# using filter function (more readable)
filter(row -> row.plant == "Seattle", df)