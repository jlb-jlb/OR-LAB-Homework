using CSV, DataFrames, JuMP, Cbc, Statistics

producers = CSV.read("./homework_4/producers.csv", DataFrame)
market = CSV.read("./homework_4/markets.csv", DataFrame)

producers = mapcols(x -> map(y -> ismissing(y) ? mean(skipmissing(x)) : y, x), producers)

producers = groupby(producers, :region)
producers = combine(producers, :p_max => sum, :sc_to_poland => mean, :sc_to_switzerland => mean, :sc_to_netherlands => mean, :sc_to_austria => mean)
transform!(producers, r"sc" => ByRow(+) => :total_sc)
transform!(producers, :total_sc => ByRow(x -> x /4) => :total_sc)
transform!(producers, [:total_sc, :p_max_sum] => ByRow(/) => :total_sc)

plants = producers[!,:region]
markets = market[!, :markets]
supply = Dict(zip(plants, producers[!, :p_max_sum]))
demand = Dict(zip(markets, market[!, :demand]))
shipping_cost = Dict(zip(plants, [Dict(zip(markets, producers[1, 3:6])), Dict(zip(markets, producers[2, 3:6])), Dict(zip(markets, producers[3, 3:6])), Dict(zip(markets, producers[4, 3:6]))]))

m = Model(Cbc.Optimizer)

@variable(m, x[plants, markets] >= 0, Int)

@objective(m, Min, 
    sum(shipping_cost[p][ma] * x[p, ma] for p in plants, ma in markets)
)

@constraint(m, Supply[p=plants],
    sum(x[p, ma] for ma in markets) <= supply[p]
)

@constraint(m, Demand[ma=markets],
    sum(x[p, ma] for p in plants) >= demand[ma]
)

println(m)

status = optimize!(m)

println(objective_value(m))

for p in plants
    for m in markets
        print("x[$p, $m] = ", value(x[p, m]), "     ")
    end
    println()
end

println(producers)
println(market)