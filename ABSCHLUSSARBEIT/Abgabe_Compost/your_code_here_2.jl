using CSV, DataFrames, Dates, TimeZones, Statistics, JuMP, Cbc

# Exercise 1
df = CSV.read("./data/timeseries.csv", DataFrame, dateformat="yyyy-mm-ddTHH:MM:SSZ")

df[!, 1] = DateTime.(df[!, 1], "yyyy-mm-ddTHH:MM:SSz")
df[!, 2] = DateTime.(df[!, 2], "yyyy-mm-ddTHH:MM:SSzzzz")

df_18 = filter(:utc_timestamp => x -> 2018 == year(x) , df)

d = DateTime(2018)

transform!(df_18, :utc_timestamp => ByRow(x -> trunc(Int,((Dates.datetime2epochms(DateTime(year(x), month(x), day(x), hour(x))) - Dates.datetime2epochms(DateTime(2018)))/3600000)+1)) => :hour)

df_18.hour  
df_18.hour[:35039:35040]

describe(df_18)
select!(df_18, r"hour", r"solar", r"wind_onshore",r"nuclear", r"coal", r"DE_load_actual")
describe(df_18)

df_m = combine(groupby(df_18, :hour), All() .=> mean)

# Exercise 2

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
    sum(cost[t]*x[t, h] for t in technology, h in hours)
)

@constraint(m, Curt[h=hours],
    sum(x[t, h]-curtailment[h] for t in technology) == demand[h]
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

println(m)

status = optimize!(m)

println(objective_value(m))