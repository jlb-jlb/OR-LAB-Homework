
using CSV
using DataFrames
using Dates, TimeZones
using Statistics

df = CSV.read("./data/timeseries.csv", DataFrame, dateformat="yyyy-mm-ddTHH:MM:SSZ")

df[!, 1] = DateTime.(df[!, 1], "yyyy-mm-ddTHH:MM:SSz")
df[!, 2] = DateTime.(df[!, 2], "yyyy-mm-ddTHH:MM:SSzzzz")

df
describe(df)
sort!(df, (:utc_timestamp))




df_18 = filter(:utc_timestamp => x -> 2018 == year(x) , df)

df[1,:utc_timestamp]
df_18.utc_timestamp

transform!(df_18, :utc_timestamp => ByRow(x -> ( month(x) * day(x) * (hour(x)+1)) ) => :hour)

d = DateTime(2018)
Dates.datetime2epochms(d)

transform!(df_18, :utc_timestamp => ByRow(x -> trunc(Int,((Dates.datetime2epochms(DateTime(year(x), month(x), day(x), hour(x))) - Dates.datetime2epochms(d))/3600000)+1)) => :hour)

df_18.hour  
df_18.hour[:35039:35040]

df_18

describe(df_18)
select!(df_18, r"hour", r"solar", r"wind_onshore",r"nuclear", r"coal")
describe(df_18)
df_18.utc_timestamp

df_m = combine(groupby(df_18, :hour), All() .=> mean)
df_m

# Execise 2


tech
hours
production
cost
x
curtailment



