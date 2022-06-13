# Exercise 1
# 1)
pu239 = 15000 * 0.01
# 2)
convert(Float64, pu239)
# 3)
pu239_string = "pu239 is the amount of Plutonium-239 that accumulated as radioactive waste from nuclear power plats until 2016."
# 4)
println("$pu239_string , amount = $pu239")

# nuclear power plants shut down in 2021
npp_2021 = ["Grohnde","Gundremmingen C","Brokdorf"]
power_2021 = [1360, 1288, 1410]

# currently still active nuclear power plants
npp_2022 = ["Isar 2", "Emsland", "Neckarwestheim 2"]
power_2022 = [1485, 1400, 1400]

# Exercise 2
# 1)
allNPP = vcat(npp_2021, npp_2022)
# 2)
allNPP = push!(allNPP, "Fantasy")
# 3)
println(length(allNPP))
# 4)
allPower = hcat(power_2021, power_2022)
# 5)
maxPower = maximum(allPower)
# 6)
println("$(npp_2022[1]) is the largest NPP with a power output of $maxPower")

# Exercise 3
# 1)
tuple_1 = (name=npp_2021[1], power=power_2021[1])
tuple_2 = (name=npp_2021[2], power=power_2021[2])
tuple_3 = (name=npp_2021[3], power=power_2021[3])
# 2)
dict_2022 = Dict(npp_2022[1] => power_2022[1], npp_2022[2] => power_2022[2], npp_2022[3] => power_2022[3])