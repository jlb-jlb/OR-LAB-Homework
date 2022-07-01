using CSV
using DataFrames
using Statistics

# Import both datasets using the package CSV
df_m = CSV.read("./homework_4/markets.csv", DataFrame)
df_p = CSV.read("./homework_4/producers.csv", DataFrame)


# In the producers dataset, deal with missing values by replacing the missing values
# with average values from the available data. To do so, subset the dataframe to
# only contain complete rows and calculate the average value for each column of the
# subsetted dataframe

describe(df_m)
# no missing values in df_m
describe(df_p)
# lots of missing values in df_p (p_max:2, sc_to_poland:1, sc_to_switzerland:2, sc_to_austria:2)

# missing values with average values

# only complete rows:
df_p
df_tmp = dropmissing(df_p)

describe(df_p)
describe(df_tmp)

# simply attach the describe data to a variable
tmp = describe(df_tmp)
tmp.mean
tmp.mean[3]


# It would be better to use the whole df since we will have more precise
# means but to have the correct output i'll use the subsetted df

replace!(df_p.p_max, missing => round(tmp.mean[3]))
replace!(df_p.sc_to_poland, missing => tmp.mean[4])
replace!(df_p.sc_to_switzerland, missing => tmp.mean[5])
replace!(df_p.sc_to_austria, missing => tmp.mean[6])

describe(df_p)

# For further processing, the data should now be aggregated by region.
sort!(df_p, :region)

# Excercise 2 - Aggregate Data
# Group the dataframe by region
gdf_p = groupby(df_p, :region)
gdf_p

gdf_p[1]
gdf_p[2]
gdf_p[3]
gdf_p[4]

# For each region, sum up the maximum production capacity and calculate the mean
# shipping costs to each region. Store the aggregated values in a new dataframe
df_tmp = combine(
    gdf_p,
    :p_max => sum,
    :sc_to_poland => mean,
    :sc_to_switzerland => mean,
    :sc_to_netherlands => mean,
    :sc_to_austria => mean,
)

# Add a new colum to the dataframe that contains the mean shipping cost from that
# region to all other regions divided by the maximum production of that region. Name
# the new column “Export_Production_Ratio”. Hint: Use the transform function

transform!(
    df_tmp,
    [:sc_to_poland_mean, :sc_to_switzerland_mean, :sc_to_netherlands_mean, :sc_to_austria_mean]
    =>
        ByRow(+) => :sum_of_means
)

transform!(
    df_tmp,
    :sum_of_means => ByRow(x -> x / 4) => :mean_of_all
)

transform!(
    df_tmp,
    [:mean_of_all, :p_max_sum] => ByRow(/) => :Export_Production_Ratio
)
# Now we want to use the new data in the model from last week

# Exercise 3 - Modeling
# Use the aggregated dataframe and the data given in the second dataset (markets) to
# model the European market using the model that you developed in your homework
# (Task 2 of Homework 3). It is not necessary to change the model - reshape the
# data provided to match the input format that you chose to use last week. We will
# also upload a solution for the model tomorrow (Tuesday)
df_m
df_tmp

# reshape the DATA:
# plants = producers = df_p
df_tmp[2, :3:6]
df_tmp
using Cbc
using JuMP

plants = df_tmp.region
markets = df_m.markets

# sc = Dict("Seattle" => Dict(zip(markets, [0.225, 0.153, 0.162])),
#     "San Diego" => Dict(zip(markets, [0.225, 0.162, 0.126]))
# ) # works like sc[plant][market]
sc = Dict(
    "germany" => Dict(zip(markets, df_tmp[1, :3:6])),
    "france"  => Dict(zip(markets, df_tmp[2, :3:6])),
    "belgium" => Dict(zip(markets, df_tmp[3, :3:6])),
    "denmark" => Dict(zip(markets, df_tmp[4, :3:6])),
)
pmax = Dict(zip(plants, df_tmp.p_max_sum))
demand = Dict(zip(markets, df_m.demand))

# plants = ["Seattle", "San Diego"]
# markets = ["New York", "Chicago", "Topeka"]
# sc = Dict("Seattle" => Dict(zip(markets, [0.225, 0.153, 0.162])),
#     "San Diego" => Dict(zip(markets, [0.225, 0.162, 0.126]))) # works like sc[plant][market]
# pmax = Dict(zip(plants, [350, 600]))
# demand = Dict(zip(markets, [325.5, 300.5, 275.5]))

model = Model(Cbc.Optimizer)
@variable(model, x[plants, markets] >= 0, Int)
@objective(model, Min, sum(sc[p][m] * x[p, m] for p in plants, m in markets))
@constraint(model, production[p in plants], sum(x[p, m] for m in markets) <= pmax[p])
@constraint(model, consumption[m in markets], sum(x[p, m] for p in plants) >= demand[m])
optimize!(model)
value.(x)
 
for p in plants
    for m in markets
        print("x[$p, $m] = ", value(x[p, m]), "     ")
    end
    println()
end








