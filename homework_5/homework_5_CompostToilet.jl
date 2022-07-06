# Homework 5

# Add the code for each homework task below the lecture code. 
# This allows you to use
# already generated/calculated data etc

# Exercise 1 - Axis Labels

# i) In he lecture, a surface plot was created for the power outputs. However, if you
#    take a close look, it does not have any axis labels.

using CairoMakie
using Random
using Statistics
using Makie
using DataFrames

#####       Data generation: 
days = 365
H = 1:(24*days)
p_wind = max.((-sin.(2 * π * H / (length(H))) .+ (Random.rand(-1:0.01:5, length(H)))), 0)
p_solar = max.((-cos.(days * 2 * π * H / (length(H))) .+ 0.25 .+ (Random.rand(-0.4:0.1:0.4, length(H))) .- (H .- length(H) / 2) .^ 2 ./ length(H)^2), 0)
p_wind_daily = reshape(p_wind, 24, 365)
p_solar_daily = reshape(p_solar, 24, 365)


# ii) Add the correct labels on the x, y, and z axis and change the figure resoultion to
#     1000x500.

# Hint: Note that Axis() is intended for 2D, however there exists an equivalent
# approach for 3D, which you may find in the documentations.


#####       In case we preferred, we could have also plotted the results in 3 dimensions: 
fig3d = Figure(
    figure_padding=1,
    backgroundcolor=:lightblue,
    resolution=(1000, 500)
)

# axw = Axis3(fig3d[1, 1], title="Wind power output daily", xlabel="Hour", ylabel="Day",)
# axs = Axis3(fig3d[1, 2], title="Solar power output daily", xlabel="Hour", ylabel="Day",)

plot1 = surface(fig3d[1, 1], 1:24, 1:365, p_wind_daily, axis=(type=Axis3, title="Wind power output daily", xlabel="Hour", ylabel="Day", zlabel="P[W]",), colormap=:inferno)
plot2 = surface(fig3d[1, 2], 1:24, 1:365, p_solar_daily, axis=(type=Axis3, title="Solar power output daily", xlabel="Hour", ylabel="Day", zlabel="P[W]",), colormap=:inferno)

fig3d
save(joinpath(@__DIR__, "SurfacePlot_with_axis.svg"), fig3d)


# Exercise 2 - Scatter Plots


# ercise 2 - Scatter Plots
# a) i) Find and plot the daily average of wind and solar outputs as a scatter plot.
# ii) The markers should use the same colors for generation modes as in the lecture.
# iii) Visualize the mean of daily averages using a dashed red line and give correct
# axis labels.
# iv) Hint: You should consult the documentation and examples to check out scatter
# plots.
# b) i) Check out the layout tutorial (https://makie.juliaplots.org/stable/tutorials/
# layout-tutorial/) and create two density plots (using density!()) to the right
# of wind and solar daily averages.
# ii) Plot a legend in the middle below both plots


# average daily outputs as scatter

mean(p_wind_daily)

df_wind = DataFrame(p_wind_daily, :auto)
df_solar = DataFrame(p_solar_daily, :auto)
daily_average_wind = describe(df_wind).mean
daily_average_solar = describe(df_solar).mean

fig = Figure(
    figure_padding=1,
    backgroundcolor=:lightblue,
    resolution=(1000, 1000)
)
generation_labels = ["Solar", "Wind"]
generation_colors = [:gold, :royalblue1]
axis_1 = Axis(fig[1, 1], xlabel="DAY", ylabel="Daily Average [MW]")

axis_2 = Axis(fig[1, 2])

axis_3 = Axis(fig[2, 1], xlabel="DAY", ylabel="Daily Average [MW]")

axis_4 = Axis(fig[2, 2])


# linkyaxes!(axis_1, axis_3)
# linkyaxes!(axis_2, axis_4)

# daily_average_wind = convert(Vector{Float32}, daily_average_wind)
wind_daily = scatter!(axis_1, 1:365, daily_average_wind, color=generation_colors[2], label=generation_labels[2])
solar_daily = scatter!(axis_3, 1:365, daily_average_solar, color=generation_colors[1], label=generation_labels[1])


total_avg_wind = mean(daily_average_wind)
total_avg_solar = mean(daily_average_solar)

m = hlines!(axis_1, total_avg_wind, color=:red, linestyle="-", label="Mean")
hlines!(axis_2, total_avg_wind, color=:red, linestyle="-", label="Mean")
hlines!(axis_3, total_avg_solar, color=:red, linestyle="-", label="Mean")
hlines!(axis_4, total_avg_solar, color=:red, linestyle="-", label="Mean")

density_wind= density!(axis_2, daily_average_wind, color=generation_colors[2], label="Wind Density", direction=:y)
density_solar = density!(axis_4, daily_average_solar, color=generation_colors[1], label="Solar Density", direction=:y)

Legend(
    fig[3, 1:2], 
    [
        wind_daily, 
        solar_daily,
        m,
        density_wind,
        density_solar,
    ],
    [
        "Wind",
        "Solar",
        "Mean",
        "Density Wind",
        "Density Solar",
    ],
    orientation=:horizontal
)
fig
save(joinpath(@__DIR__, "4erPlot.svg"), fig);







plot_range = 1:365
generation = vcat(zeros(plot_range)', daily_average_solar[plot_range]', daily_average_wind[plot_range]')
generation_labels = ["Solar", "Wind"]
generation_colors = [:gold, :royalblue1]
cumulated_generation = cumsum(generation, dims=1)
figcum = Figure(
    figure_padding=1,
    backgroundcolor=:lightblue,
    resolution=(1000, 500)
)
axcum = Axis(figcum[1, 1], ylabel="MW", xlabel="Day", title="Power Generation")
for row in 1:size(cumulated_generation, 1)-1
    band!(
        axcum,
        plot_range,
        cumulated_generation[row, :],
        cumulated_generation[row+1, :],
        linewidth=0,
        label=generation_labels[row],
        color=generation_colors[row]
    )
end
Legend(figcum[1, 2], axcum)
figcum
save(joinpath(@__DIR__, "PowerOutputDailyAcc.svg"), figcum);


