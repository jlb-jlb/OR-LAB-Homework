using Pkg
Pkg.add("JuMP")
Pkg.add("Cbc")
using JuMP, Cbc


# Exercise 1
m = Model(Cbc.Optimizer)

cost = [11, 9, 8]
capacity = [40, 10, 75]
values = [3, 3, 4]

ind = 1:3

@variable(m, x[ind] >= 0)

@objective(m, Max,
    sum(cost[i]*x[i] for i in ind)
)

@constraint(m, 
    sum(values[i]*x[i] for i in ind) <= 200
)

@constraint(m, Capacity[i in ind],
    x[i] <= capacity[i]
)

print(m)

status = optimize!(m)

println(objective_value(m))

for i in ind
    println("x[i] = ", value(x[i]))
end

# Exercise 2
m2 = Model(Cbc.Optimizer)

plants = ["Seattle", "San Diego"]
markets = ["New York", "Chicago", "Topeka"]
supply = Dict(zip(plants, [350, 600]))
demand = Dict(zip(markets, [325.5, 300.5, 275.5]))
shipping_cost =  Dict(zip(plants, [(Dict(zip(markets, [0.255, 0.153, 0.162]))), (Dict(zip(markets, [0.255, 0.162, 0.126])))]))

@variable(m2, x[plants, markets] >= 0, Int)

@objective(m2, Min, 
    sum(shipping_cost[p][m] * x[p, m] for p in plants, m in markets)
)

@constraint(m2, Supply[p=plants],
    sum(x[p, m] for m in markets) <= supply[p]
)

@constraint(m2, Demand[m=markets],
    sum(x[p, m] for p in plants) >= demand[m]
)

println(m2)

status = optimize!(m2)

println(objective_value(m2))

for p in plants
    for m in markets
        print("x[$p, $m] = ", value(x[p, m]), "     ")
    end
    println()
end