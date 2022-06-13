x = []



let(i)
    for i in 1:10
        if i % 2 != 0
            # append!(x, i)
            append!(x, i)
        end
    end
end
println(x)

# x = Array{:Int64}
# let i
#     for i in 1:10
#         if i % 2 != 0
#             println(i)
#             vcat(x, i)
#         end
#     end
# end
# println(x)


y = []
let (i = 1)
    while i <= 10
        if i % 2 != 0 
            append!(y, i)
        end
        i += 1
    end
end
println(y)
# println(i)  # i undefined

# y[5] = 0

let x_, y_
    for (x_, y_) in zip(x,y)
        if x_ != y_
            print("Arrays not the same\n")
            break
        end

        print(x_,"\t" ,y_, "\n")
    end
end

# print(x_) undefined






    



