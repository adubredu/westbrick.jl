
function init_visualization()
    traj = []
    obj_traj = []
    return traj, obj_traj
end

function visualize_environment!(objects)
    fig = Figure()
    ax = Axis(fig[1,1], aspect=DataAspect(), limits=(-10.,10.,-10.,10.))
    obs_dict = Dict()
    for ob in objects 
        ox = Observable(Point2f(ob.pose...)) 
        θ = Observable(0.0) 
        scatter!(ax, ox; rotation=θ, marker=:rect, markersize=25, color=ob.color)
        obs_dict[ob.id] = (ox,θ)
    end
    return obs_dict, ax, fig
end


function visualize_trajectory!(bobby, trajectory, obj_trajectory, obs_dict, ax, fig; 
                                name="media/test.gif")    
    T = length(trajectory) 
    θ = Observable(0.0)
    x = Observable(Point2f(0.,0.))
    img = Observable(load("models/left_swing.png"))
    scatter!(ax, x; rotation=θ, marker=img, markersize=40)
    # hidedecorations!(ax) 

    function gaits!(t) 
        stride=10
        x[] = Point2f(trajectory[t][1:2]...) 
        θ[] = trajectory[t][3] - π/2.

        if !isnothing(obj_trajectory[t])
            ind = obj_trajectory[t][4]
            ox, oθ = obs_dict[ind] 
            ox[] = Point2f(obj_trajectory[t][1:2]...) 
            oθ[] = obj_trajectory[t][3] - π/2.
        end
        
        img[] = t % (stride*2) <= stride ? load("models/left_swing_bg.png") : load("models/right_swing_bg.png")
        sleep(0.01)
    end

    record(fig, name, 1:T, framerate=60) do t 
        gaits!(t)
    end
    empty!(ax)


end