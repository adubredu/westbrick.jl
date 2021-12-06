function animate!(robot, env, trajectory, obj_trajectory)
    fig = Figure()
    ax = Axis(fig[1,1], aspect=DataAspect(), limits=(-10.,10.,-10.,10.))
    T = length(trajectory)
 
    gait = Node(1) 
    θ = Node(0.0)
    x = Node(Point2f0(0.,0.))
    ox = Node(Point2f0(0.,0.))
    oθ = Node(0.0)
    img = Node(load("models/left_swing.png"))
    scatter!(ax, x; rotation=θ, marker=img, markersize=40)
    scatter!(ax, ox; rotation=oθ, marker=:rect, markersize=25)
    hidedecorations!(ax)
    

    function gaits!(t) 
        stride=10
        x[] = Point2f0(trajectory[t][1:2]...) 
        θ[] = trajectory[t][3] - π/2.

        ox[] = Point2f0(obj_trajectory[t][1:2]...) 
        oθ[] = obj_trajectory[t][3] - π/2.
        
        img[] = t % (stride*2) <= stride ? load("models/left_swing_bg.png") : load("models/right_swing_bg.png")
        sleep(0.01)
    end

    record(fig, "media/go_to2.gif", 1:T, framerate=60) do t 
        gaits!(t)
    end


end