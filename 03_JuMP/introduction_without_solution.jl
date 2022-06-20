# First we need to install the two packages we need. If you usually work in an environment, please switch into the respective environment first (Pkg.activate("<PackageName>")).
using Pkg
Pkg.add("JuMP")
Pkg.add("Cbc")

#Lets make sure we import the required packages.
using JuMP, Cbc

# The first particularity of JuMP is that we require a model object. The command is:
# <ModelName> = Model(<SolverName>.Optimizer)
m = Model(Cbc.Optimizer)

# For this first example, we will build a very simple obtimization problem and then later expand on it. For more information, see https://jump.dev/JuMP.jl/stable/
# Every optimization model consists of at least variables and constraints. A variable is created through the command:
# @variable(<ModelName>, <VariableName>)
# Additional information like the domain of the variable can be stated as well, example @variable(<ModelName>, <VariableName, Int) creates an integer variable.
# Also, lower and upper bounds of the variables can directly be defined in the variable definition, see the example below.
@variable(m, 0 <= x <= 2)
# In this case, the variable 'x' is created, assigned to the model 'm' and defined to be within 0 and 2.

# TASK: Create a variable 'y' which is always positive and never greater than 30.
@variable(m, 0 <= y <= 30)

# The equations in an optimization problem are either the objective function or constraints. As for the objective function, it is defined throgh the command:
# @objective(<ModelName>,<OptimizationDirection>,<ObjectiveExpression>)
# Where the <OptimizationDirection> is either 'Max' or 'Min' for a maximization or minimazation problem, respectively.
@objective(m, Max, 5x + 3y)

# Constraints are constructed the following way:
# @constraint(<ModelName>,<ConstraintExpression>)
# For the constraint expressions, the following syntax is important. 
# Less than or equal constraint: <=
# Greater than or equal constraint: >=
# Equality constraint: ==
# Task: Create a constraint which expresses the following: 5 times x plus 4 times y is less than or equal 25
# if we have a greater than 0 we can also say NOT <= 0
@constraint(m, 5x + 4y <= 25)



# We can take a look at the model object through the following command:
print(m)

# To solve the optimization problem, the 'optimize!(<ModelName>)' command can be used.
status = optimize!(m)

# we are more interested in the values of each variable instead of the optimal value.
# Additionally, we might want to know the exact values of our objective function and variables.
println("Objective value: ", objective_value(m))
println("x = ", value(x))
println("y = ", value(y))

# Example 2



# Using vectors can reduce the number of constraints you have to write. 
demand = [5, 8]

# TASK: Define a vector 'production_cost' with the values 2, 3 and 4
production_cost = [2, 3, 4]

# TASK: Define a vector 'production_capacity' with the values 2, 3 and 10
production_capacity = [2, 3, 10]

# Lets define what supplier and years are 
supplier = 1:3 # set supplier 3D
years = 1:2    # set year 2D

# TASK: Again, start by constructing the model object
m = Model(Cbc.Optimizer)

# Variables can also be defined multiple at a time, if they depend on diferent sets.
# QUESTION: How many single variables are created with the following command?
@variable(m, x[supplier, years] >= 0)

# We can also use functions in our objective function and constraints. One commonly used function is the sum function, see syntax below.
@objective(m, Min,
    sum(production_cost[s] * x[s, y] for s in supplier, y in years)
)

# Now that we are using vectors, we can use the compact form of writing constraints. 
# If we want to define a constraint for every element of a vector, we can state that vector in the name definition.
# @constraint(<ModelName>,<ConstraintName>[<Vector>],<ConstraintExpression>)
# The following constraint is constructed once for every element in year.
@constraint(m, Market[y=years],  # we can assign a name to a constraint
    sum(x[s, y] for s in supplier) >= demand[y]
)
# we create the constraint for every y there is (in our case 2) 
# here we don't have to tell the Model where the y come from



# TASK: Define the second constraint of the obtimization problem, also in the compact notation.
# Hint: You can separate different vectors through a comma when defining the constraint.
@constraint(m, Capacity[y=years, s=supplier],
    x[s, y] <= production_capacity[s]
)

# TASK: Print the model
println(m)

# TASK: Solve the model
status = optimize!(m)

# TASK: Print the objective value and variables
println("Objective value: ", objective_value(m))
# println("x = ", value(x))
println("y = ", value(y))
output = ["$index = $val, " for (val, index) in enumerate(x)]
# print(str_ for str_ in output)



# The variables could be displayed in a better way. One possibility is to write a loop which prints each variable.
for i in supplier
    for j in years
        println("x[$i,$j] = ", value(x[i, j]))
    end
end

### Example 2 again but formulated differently with dictionaries

# Now we don't have numbers as our set elements but strings. 
# This requires us to use dictionaries which match the single set elements to the respective values.
supplier = ["A", "B", "C"]
years = ["2021", "2022"]

# First the dictionaries:
demand = Dict(zip(years, [5, 8]))   # zip makes years the key and [5,8] the values

# TASK: create the objects 'production_cost' and 'production_capacities' using dictionaries. Use the same values as in example 2.
production_cost = Dict(zip(supplier, [2, 3, 4]))
production_capacity = Dict(zip(supplier, [2, 3, 10]))

# TASK: The model formulation stays exactly the same so nothing to change here. 
# Write the model, solve it and display the objective value and variables.
m = Model(Cbc.Optimizer)
@variable(m, x[supplier, years] >= 0)
@objective(m, Min,
    sum(production_cost[s] * x[s, y] for s in supplier, y in years)
)
@constraint(m, Market[y=years],  # we can assign a name to a constraint
    sum(x[s, y] for s in supplier) >= demand[y]
)
@constraint(m, Capacity[y=years, s=supplier],
    x[s, y] <= production_capacity[s]
)
println(m)

status = optimize!(m)


