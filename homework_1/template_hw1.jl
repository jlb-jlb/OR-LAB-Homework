# nuclear power plants shut down in 2021
npp_2021 = ["Grohnde","Gundremmingen C","Brokdorf"]
power_2021 = [1360, 1288, 1410]

# currently still active nuclear power plants
npp_2022 = ["Isar 2", "Emsland", "Neckarwestheim 2"]
power_2022 = [1485, 1400, 1400]


# Amount of PU_239 until 2016
PU_239 = 15000 * 0.01

println(typeof(PU_239))
convert(Float64, PU_239)
println(typeof(PU_239))

str_ = "The amount of PU_239 ($PU_239) makes up 1% of the total amount of radioactive waste in Germany"
println("$str_")


# Excercise 2
allNPP = vcat(npp_2021, npp_2022)
println(allNPP)
allNPP = vcat(allNPP, ["NewWorldPlant"])
println(allNPP )

println(length(allNPP))

allPower = hcat(power_2021, power_2022)
# allPower = allPower'
# allPower

max_power = findmax(allPower)
allNPP = hcat(npp_2021, npp_2022)
println("$(max_power[1]) :  $(allNPP[max_power[2]])")

# 3
power_2021
npp_2021
tuple_1 = (npp_2021[1], power_2021[1])
tuple_2 = (npp_2021[2], power_2021[2])
tuple_3 = (npp_2021[3], power_2021[3])
list_tuple = vcat(tuple_1, tuple_2, tuple_3)

println(typeof(tuple_1))
tuple_list = []
for (name, cap) in zip(npp_2021, power_2021)
    tuple_list = vcat(tuple_list, Tuple((name, cap)))
end
println(tuple_list)

dict_ = Dict()

# for entry in tuple_list
#     dict_[entry[1]] = entry[2]
# end
for entry in tuple_list
    dict_[entry[1]] = entry[2]
    push!(dict_, entry[1] => entry[2])
end

for (key, value) in dict_
    println("Key: $key --> $value")
end
