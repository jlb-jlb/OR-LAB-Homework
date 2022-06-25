using Pkg
using JuMP
# Pkg.add("Cbc")
using Cbc

# EXERCISE 1 - LINEAR PROBLEM


m = Model(Cbc.Optimizer)
# define variables
@variable(m, 0 <= x_1 <= 40)
@variable(m, 0 <= x_2 <= 10)
@variable(m, 0 <= x_3 <= 75)
#objective
@objective(m, Max, 11 * x_1 + 9 * x_2 + 8 * x_3)

@constraint(m, 3x_1 + 3x_2 + 4x_3 <= 200)

print(m)

status = optimize!(m)

println("Objective value: ", objective_value(m))
println("x_1 = ", value(x_1))
println("x_2 = ", value(x_2))
println("x_3 = ", value(x_3))


# EXERCISE 2 - Integer Programming



m2 = Model(Cbc.Optimizer)

# diesmal mit der cheat methode


plants = ["Seattle", "San Diego"]
markets = ["New York", "Chicago", "Topeka"]
supply = Dict(zip(plants, [350, 600]))
demand = Dict(zip(markets, [325.5, 300.5, 275.5]))
shipping_cost = Dict(zip(plants, [(Dict(zip(markets, [0.255, 0.153, 0.162]))), (Dict(zip(markets, [0.255, 0.162, 0.126])))]))

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