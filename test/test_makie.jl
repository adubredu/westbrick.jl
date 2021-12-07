using GLMakie

fig = Figure()
ax = Axis(fig[1,1], aspect=DataAspect())

function square_scatter!()
    scatter!(ax, [1.,3.],[3., 5.]; marker=:circle)
end

function circle_scatter!()
    scatter!(ax, [0.,4.], [5.,6.]; marker=:rect)
end

square_scatter!()
circle_scatter!() 
current_figure()