
using CSV
using DataFrames
using Dates, TimeZones
using Statistics
using JuMP
using Cbc

df = CSV.read("./data/timeseries.csv", DataFrame, dateformat="yyyy-mm-ddTHH:MM:SSZ")

df[!, 1] = DateTime.(df[!, 1], "yyyy-mm-ddTHH:MM:SSz")
df[!, 2] = DateTime.(df[!, 2], "yyyy-mm-ddTHH:MM:SSzzzz")

df
describe(df)
sort!(df, (:utc_timestamp))




df_18 = filter(:utc_timestamp => x -> 2018 == year(x), df)

df[1, :utc_timestamp]
df_18.utc_timestamp

# transform!(df_18, :utc_timestamp => ByRow(x -> (month(x) * day(x) * (hour(x) + 1))) => :hour)

d = DateTime(2018)
Dates.datetime2epochms(d)

transform!(df_18, :utc_timestamp => ByRow(x -> trunc(Int, ((Dates.datetime2epochms(DateTime(year(x), month(x), day(x), hour(x))) - Dates.datetime2epochms(d)) / 3600000) + 1)) => :hour)

df_18.hour
df_18.hour[:35039:35040]





df_18

describe(df_18)
select!(df_18, r"hour", r"solar", r"wind_onshore", r"nuclear", r"coal", r"DE_load_actual")
# select!(df_18, r"hour", r"solar", r"wind_onshore", r"nuclear", r"coal", r"DE_load_actual", r"curtailment")
describe(df_18)
# df_18.utc_timestamp




df_m = combine(groupby(df_18, :hour), All() .=> mean)
df_m

# Execise 2
names(df_m)


technology = ["solar", "wind_onshore", "nuclear", "coal"]
hours = df_m.hour
demand = df_m.DE_load_actual_entsoe_transparency_mean
cost = Dict(zip(technology, [0, 0, 3, 8]))

production_solar_h = Dict(zip(hours, df_m.DE_solar_generation_actual_mean))
production_wind_h = Dict(zip(hours, df_m.DE_wind_onshore_generation_actual_mean))
production_nuclear_h = Dict(zip(hours, fill(8000, 8760)))
production_coal_h = Dict(zip(hours, fill(100000, 8760)))


production = Dict(zip(technology, [production_solar_h, production_wind_h, production_nuclear_h, production_coal_h]))

m = Model(Cbc.Optimizer)

@variable(m, x[technology, hours] >= 0)

@variable(m, curtailment[hours] >= 0)

@objective(m, Min,
    sum(cost[t] * x[t, h] for t in technology, h in hours)
)

@constraint(m, Curt[h=hours],
    sum(x[t, h] - curtailment[h] for t in technology) == demand[h]
)

@constraint(m, Solar[h=hours],
    x["solar", h] == production["solar"][h]
)

@constraint(m, Wind[h=hours],
    x["wind_onshore", h] == production["wind_onshore"][h]
)

@constraint(m, Production[t=technology, h=hours],
    x[t, h] <= production[t][h]
)

# println(m)

status = optimize!(m)

println(objective_value(m))



# Excercise 3 - Plots

# In this task, you are asked to plot the results of your optimization model.
# For the first graph, create a stacked area plot of generation profiles. You are asked to
# depict the following results: onshore wind, solar, nuclear, coal and curtailment. Your
# plot should depict the first 100 hours. You are free to choose your own colors, scalings
# etc., but everything must be clearly visible. Provide valid axis labels, a meaningful title
# and a legend. For the second graph, you are supposed to create a barplot, depicting the
# aggregated renewable and conventional as well as total generation. Once again, you are
# free to choose colors etc., but valid axis labels and a meaningful title must be provided.
# Further, it must be made clear which bar is related to which result


# stacked area plot of generation profiles
# depict following results: onshore wind, solar, nuclear, coal and curtailment

# 100 h
# axis labels
# title
# legend
using CairoMakie, Makie

f = Figure()
ax1 = Axis(f[1, 1],
    title="Results of optimization model",
    xlabel="Hour",
    ylabel="Generation"
)

result_solar = []
result_wind = []
result_nuclear = []
result_coal = []
result_curtailment = []

for i in 1:100
    append!(result_solar, value(x["solar", i]))
    append!(result_wind, value(x["wind_onshore", i]))
    append!(result_nuclear, value(x["nuclear", i]))
    append!(result_coal, value(x["coal", i]))
    append!(result_curtailment, value(curtailment[i]))
end

result_solar

band!(ax1, hours[1:100], result_curtailment + result_coal + result_nuclear + result_wind + result_solar, zero(100), color=:magenta, label="Curtailment")
band!(ax1, hours[1:100], result_coal + result_nuclear + result_wind + result_solar, zero(100), color=:gray64, label="coal")
band!(ax1, hours[1:100], result_nuclear + result_wind + result_solar, zero(100), color=:lime, label="nuclear")
band!(ax1, hours[1:100], result_wind + result_solar, zero(100), color=:cyan, label="wind")
band!(ax1, hours[1:100], result_solar, zero(100), color=:gold, label="solar")
axislegend(ax1)

ax2 = Axis(f[1, 2],
    title="Aggregated Generation",
    xlabel="Type of generation",
    ylabel="Generation",
    xticks=(1:3, ["renewable", "conventional", "total"])
)
renewable = sum(result_solar) + sum(result_wind)
conventional = sum(result_nuclear) + sum(result_coal)
barplot!(ax2, 1:3, [renewable, conventional, renewable + conventional], color=[:green, :grey, :blue])
f
