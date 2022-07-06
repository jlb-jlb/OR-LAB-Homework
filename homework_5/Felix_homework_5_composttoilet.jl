using Makie, CairoMakie, Random, Statistics

# data
days = 365
H = 1:(24*days)
p_wind = max.( (-sin.(2*π*H/(length(H))) .+ (Random.rand(-1:0.01:5, length(H)) )),0)
p_solar = max.( (-cos.(days*2*π*H/(length(H)) ) .+ 0.25 .+ (Random.rand(-0.4:0.1:0.4, length(H)) ) .- (H.-length(H)/2).^2 ./length(H)^2 ) , 0)

# data reshaped daily
p_wind_daily = reshape(p_wind, 24, 365)
p_solar_daily = reshape(p_solar, 24, 365)

# Exercise 1
fig3d = Figure(resolution = (1000,500))
surface(fig3d[1, 1], 1:24, 1:365, p_wind_daily, axis=(type=Axis3, xlabel = "Hour", ylabel = "Day", zlabel = "P[W]",), colormap = :inferno)
surface(fig3d[1, 2], 1:24, 1:365, p_solar_daily, axis=(type=Axis3, xlabel = "Hour", ylabel = "Day", zlabel = "P[W]",), colormap = :inferno)
fig3d

# Exercise 2
daily_average_wind = mean(p_wind_daily, dims=1)
daily_average_solar = mean(p_solar_daily, dims=1)

figure_daily = Figure(resolution = (1000,1000))

ax1 = Axis(figure_daily[1,1],
    xlabel = "Day",
    ylabel = "Daily Average [MW]"
)
ax2 = Axis(figure_daily[2,1],
    xlabel = "Day",
    ylabel = "Daily Average [MW]"
)
ax3 = Axis(figure_daily[1,2]

)
ax4 = Axis(figure_daily[2,2]

)

linkyaxes!(ax1, ax3)
linkyaxes!(ax2, ax4)

daily_w = scatter!(ax1, 1:365, vec(daily_average_wind), color = :royalblue1, label = "Wind")
daily_s = scatter!(ax2, 1:365, vec(daily_average_solar), color = :gold, label = "Solar")

means = Dict(zip([:dailywind,:dailysolar], [mean(daily_average_wind),mean(daily_average_solar)]))

dense_w = density!(ax3, vec(daily_average_wind), color = :royalblue1, direction = :y, label = "Density Wind")
dense_s = density!(ax4, vec(daily_average_solar), color = :gold, direction = :y, label = "Density Solar")

mean_all = hlines!(ax1, means[:dailywind], color = :red, linestyle = :dash, label = "Mean")
hlines!(ax2, means[:dailysolar], color = :red, linestyle = :dash, label = "Mean")
hlines!(ax3, means[:dailywind], color = :red, linestyle = :dash, label = "Mean")
hlines!(ax4, means[:dailysolar], color = :red, linestyle = :dash, label = "Mean")

Legend(figure_daily[3, 1:2], [daily_w, daily_s, mean_all, dense_w, dense_s], ["Wind", "Solar", "Mean", "Density Wind", "Density Solar"], orientation = :horizontal)
figure_daily