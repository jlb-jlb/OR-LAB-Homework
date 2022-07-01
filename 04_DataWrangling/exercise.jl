using DataFrames
using CSV
using Statistics

df = CSV.read("04_DataWrangling/dataset_large.csv", DataFrame)

describe(df)
df

dropmissing!(df)

filter(row -> row.p_max >= (800), df)

gbr = groupby(df, :region)

gbr
combine(gbr, :p_max => sum => :total_production)

transform!(df)

gbr
# transform!(df, :region => sum => :total_production)
transform!(df, [sc_1] => ByRow(+) => :total_production)
transform!(df, [:sc_1, :sc_2, :sc_3] => ByRow(+) => :total_sc)
describe(df)

