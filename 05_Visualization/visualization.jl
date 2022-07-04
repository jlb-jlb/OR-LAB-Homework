#####       Lecture on data and results visualization
#####       Further examples can be found at https://makie.juliaplots.org/stable/

#####       Packages: 
using CairoMakie
using Random
using Statistics
using Makie

#####       Data generation: 
days = 365
H = 1:(24*days)
p_wind = max.( (-sin.(2*π*H/(length(H))) .+ (Random.rand(-1:0.01:5, length(H)) )),0)
p_solar = max.( (-cos.(days*2*π*H/(length(H)) ) .+ 0.25 .+ (Random.rand(-0.4:0.1:0.4, length(H)) ) .- (H.-length(H)/2).^2 ./length(H)^2 ) , 0)


#####       Our first plot:
f = Figure(resolution = (1000, 1000))
ax1 = Axis(f[1, 1],
    title = "Wind power output",
    xlabel = "Hour",
    ylabel = "MW",
    aspect = 1
)
lines!(ax1, H, p_wind, linewidth = 1, color = :royalblue1, label = "Wind")

ax2 = Axis(f[1, 2],
    title = "Solar power output",
    xlabel = "Hour",
    ylabel = "MW",
    aspect = 1
)
lines!(ax2, H, p_solar, linewidth = 1, color = :gold, label = "Solar")

#####       In class exercise: Plot below the power outputs of the first week
#####       Your code here
ax3 = Axis(f[2,1],
    title = "Wind First Week",
    xlabel = "Hour",
    ylabel = "MW",
    aspect = 1,
)
lines!(ax3, 1:(24*7), p_wind[1:24*7], linewidth = 1, color = :red, label = "Wind")

ax4 = Axis(f[2,2],
    title = "Solar First Week",
    xlabel = "Hour",
    ylabel = "MW",
    aspect = 1,
)
lines!(ax4, 1:(24*7), p_solar[1:24*7], linewidth = 1, color = :red, label = "Wind")


#####       Now, let us take a look at the relative distributions of power outputs: 
p_wind_sorted = sort(p_wind)
p_solar_sorted = sort(p_solar)
ax5 = Axis(f[3, 1],
    title = "Wind power output sorted",
    xlabel = "Hour",
    ylabel = "MW",
    aspect = 1
)
lines!(ax5, H, p_wind_sorted, linewidth = 2, color = :royalblue1, label = "Wind")

ax6 = Axis(f[3, 2],
    title = "Solar power output sorted",
    xlabel = "Hour",
    ylabel = "MW",
    aspect = 1
)
lines!(ax6, H, p_solar_sorted, linewidth = 2, color = :gold, label = "Solar")

f
#####       We can also plot other informative aspects
#####       For example, we can plot the mean: 
means = Dict(zip([:wind,:solar], [mean(p_wind),mean(p_solar)]))
# for i in 1:3
#     hlines!( eval(Meta.parse("ax$(2*i -1)")), means[:wind], color = :red, label = "Mean")
#     hlines!( eval(Meta.parse("ax$(2*i   )")), means[:solar], color = :red, label = "Mean")
# end
hlines!( ax1, means[:wind], color = :red, label = "Mean")
hlines!( ax2, means[:solar], color = :red, label = "Mean")
hlines!( ax3, means[:wind], color = :red, label = "Mean")
hlines!( ax4, means[:solar], color = :red, label = "Mean")
hlines!( ax5, means[:wind], color = :red, label = "Mean")
hlines!( ax6, means[:solar], color = :red, label = "Mean")
#####       Or we can draw a line at how many hours are below a threshhold (here zero):
thresholds = Dict(zip([:wind,:solar], [count(i -> i<=0, p_wind),count(i -> i<=0,p_solar)]))
vlines!( ax5, thresholds[:wind], color = :red, linestyle=:dash, label = "Threshhold")
vlines!( ax6, thresholds[:solar], color = :red, linestyle=:dash, label = "Threshhold")
axislegend(ax5, position = :lt)
axislegend(ax6, position = :lt)

f
save(joinpath(@__DIR__,"my_1st_plot.svg"),f)

#####       Now that we have taken a look at the data in total, let us proceed by taking a look at intra-day structures.
p_wind_daily = reshape(p_wind, 24, 365)
p_solar_daily = reshape(p_solar, 24, 365)
fig = Figure(resolution = (1000, 1000))
axw = Axis(fig[1, 1], title = "Wind power output daily", xlabel = "Hour", ylabel = "Day",  )
axs = Axis(fig[1, 2], title = "Solar power output daily", xlabel = "Hour", ylabel = "Day",  )
hmw = heatmap!(axw, 1:24, 1:365, p_wind_daily, colormap = :inferno )
hms = heatmap!(axs, 1:24, 1:365, p_solar_daily, colormap = :inferno )
Colorbar(fig[2, 1], hmw, vertical = false, label = "Power in MW")
Colorbar(fig[2, 2], hms, vertical = false, label = "Power in MW") 
fig
#####       One may argue that this representation is misguiding, since it uses the same color coding for different absolute values. Instead, it may be desirable to use a similar mapping for both subfigures:
outputlimits = (0,max(p_wind...,p_solar...))
axwc = Axis(fig[4, 1], title = "Wind power output daily (scaled)", xlabel = "Hour", ylabel = "Day",  )
axsc = Axis(fig[4, 2], title = "Solar power output daily (scaled)", xlabel = "Hour", ylabel = "Day",  )
hmwc = heatmap!(axwc, 1:24, 1:365, p_wind_daily, colormap = :inferno, colorrange = outputlimits )
hmsc = heatmap!(axsc, 1:24, 1:365, p_solar_daily, colormap = :inferno, colorrange = outputlimits )
Colorbar(fig[5, 1:2], colormap = :inferno, colorrange = outputlimits, vertical = false, label = "Power in MW (scaled)") 
fig
save(joinpath(@__DIR__,"my_2nd_plot.svg"),fig)


#####       In case we preferred, we could have also plotted the results in 3 dimensions: 
fig3d = Figure()
surface(fig3d[1, 1], 1:24, 1:365, p_wind_daily, axis=(type=Axis3,), colormap = :inferno)
surface(fig3d[1, 2], 1:24, 1:365, p_solar_daily, axis=(type=Axis3,), colormap = :inferno)
fig3d
save(joinpath(@__DIR__,"my_3rd_plot.svg"),fig3d)


#####       In energy applications it is often useful to plot aggregated quantities, while still showing individual contributions: 

plot_range = 1:48
generation = vcat(zeros(plot_range)',p_solar[plot_range]',p_wind[plot_range]')
generation_labels = ["Solar", "Wind"]
generation_colors = [:gold,:royalblue1]
cumulated_generation = cumsum(generation, dims = 1)
figcum = Figure()
axcum = Axis(figcum[1, 1], ylabel = "MW", xlabel="Hour", title="Power Generation")
for row in 1:size(cumulated_generation, 1)-1
    band!(
        axcum,
        plot_range,
        cumulated_generation[row,:],
        cumulated_generation[row+1,:],
        linewidth=0,
        label = generation_labels[row],
        color = generation_colors[row]
    )
end
Legend(figcum[1, 2], axcum)
figcum
save(joinpath(@__DIR__,"my_4th_plot.svg"),figcum);


Legend(f[4,1:2], [linetst], ["testlabel"])