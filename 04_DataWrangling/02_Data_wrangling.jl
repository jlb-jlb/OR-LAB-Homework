### Transforming data / data wrangling
using CSV
using DataFrames

df3 = CSV.read("04_DataWrangling/dataset_large.csv", DataFrame)
# reorder data
select!(df3, r"sc", :)
# sort by production capacity
sort!(df3, :p_max)

# missing data and duplicates
allowmissing(df3, :p_max) # if we want to explicitly allow missing data, not really useful here 
dropmissing!(df3) # drop missing data
completecases(df3) # boolean array for rows without missing data
unique!(df3) # drop duplicates

# reshape data
df4 = stack(df3) # good for plotting or creating a pivot table
unstack(df4) # going back

# grouping data
gdf = groupby(df3, :region) # group by region
keys(gdf) # get keys for groups
gdf[(region = "East",)] # look up specific data

# aggregating data
combine(df3, :p_max => sum) # throws an error
dropmissing!(df3)
combine(df3, :p_max => sum)
combine(gdf, :p_max => sum) # throws an error
gdf = groupby(df3, :region)
combine(gdf, :p_max => sum) # works now
# shorter, plus assigning a column name
combine(groupby(df3, :region), :p_max => sum => :total_production)

# changing a data frame / adding stuff with "transform" function
# by column
transform(df3, :p_max => mean => :mean_production_capacity) # add a mean capacity column
transform!(df3, :p_max => mean => :mean_production_capacity) # in place with !
select!(df3, Not(:mean_production_capacity)) # remove it again

# by row
# lets say we want to reduce each production capacity by 10 percent to add a security margin
df3[!,:p_max_reduced] = map(x -> x*0.9, df3.p_max) # version a
transform!(df3, :p_max => ByRow(x -> x*0.9) => :p_max_reduced_alternative) # version b
# or we want to aggregate all shippung cost
transform!(df3, [:sc_1, :sc_2, :sc_3] => ByRow(+) => :total_sc)

## Potentially add:
# eachcol: Iterates through all columns
# flatten function?
# mapcols? passes a df and a function, applies function to columns




