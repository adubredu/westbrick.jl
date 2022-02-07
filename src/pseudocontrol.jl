# function move_forward!(bobby, Δx, traj, obj_traj)
#     println("translating")
#     θ = bobby.pose[3]
#     x = Δx[1]*cos(θ)
#     y = Δx[2]*sin(θ)
#     pose = [bobby.pose[1]+x, bobby.pose[2]+y, θ] 
#     push!(traj, pose)
#     bobby.pose = pose
#     if !isnothing(bobby.holding)
#         obpose = [bobby.holding.pose[1]+x, bobby.holding.pose[2]+y, θ]
#         bobby.holding.pose = obpose 
#         push!(obj_traj, [obpose...,bobby.holding.id])
#     else
#         push!(obj_traj, nothing)
#     end
# end

# function translate!(bobby, pose, traj, obj_traj; tol=1e-1) 
#     while !(abs(pose[1]-bobby.pose[1]) < tol && abs(pose[2]-bobby.pose[2]) < tol)
#         # u = bobby.kp*abs.(pose[1:2]-bobby.pose[1:2]) + bobby.kv*(bobby.velocity[1:2])
#         u = [0.001, 0.001]
#         println("Current pose: $(bobby.pose) Goal pose: $(pose)")
#         println("Control $u\n")
        
#         move_forward!(bobby, u, traj, obj_traj)   
#     end
#     return traj
# end


# function rotate!(bobby, Δθ, traj, obj_traj) 
#     θ = bobby.pose[3] + Δθ
#     pose = [bobby.pose[1], bobby.pose[2], θ]
#     push!(traj, pose)
#     bobby.pose = pose
#     if !isnothing(bobby.holding)
#         R = [cos(θ) -sin(θ); 
#              sin(θ)  cos(θ)] 
#         Δxy = [0.6, 0.]
#         oxy = R*Δxy
#         obpose = [bobby.pose[1]+oxy[1], bobby.pose[2]+oxy[2], θ]

#         bobby.holding.pose = obpose 
#         push!(obj_traj, [obpose...,bobby.holding.id])
#     else
#         push!(obj_traj, nothing)
#     end
# end


# function turn!(bobby, angle, traj, obj_traj; tol=1e-2) 
#     while(abs(norm(angle-bobby.pose[3])) > tol)
#         # u = bobby.kp*(angle-bobby.pose[3]) + bobby.kv*(bobby.velocity[3])
#         Δ = angle - bobby.pose[3]
#         if Δ < 0.0 u = -0.001 else u = 0.001 end
#         rotate!(bobby, u, traj, obj_traj)
#     end
#     return traj
# end

function turn!(bobby, angle, traj, obj_traj; τ=1e-1)
    Δ = angle - bobby.pose[3]
    if Δ < 0.0 θs = bobby.pose[3]:-τ:angle
    else θs = bobby.pose[3]:τ:angle end 
    [push!(traj, [bobby.pose[1], bobby.pose[2], θ]) for θ in θs]
    for θ in θs
        bobby.pose[3] = θ
        if !isnothing(bobby.holding)
            R = [cos(θ) -sin(θ); 
                sin(θ)  cos(θ)] 
            Δxy = [0.6, 0.0]
            oxy = R*Δxy
            obpose = [bobby.pose[1]+oxy[1], bobby.pose[2]+oxy[2], θ] 
            bobby.holding.pose = obpose 
            push!(obj_traj, [obpose...,bobby.holding.id])
        else
            push!(obj_traj, nothing)
        end
    end 
end

# function translate!(bobby, pose, traj, obj_traj; τ=1e-1) 
#     Δx = pose[1] - bobby.pose[1]
#     Δy = pose[2] - bobby.pose[2]
#     if Δx < 0.0 xs = bobby.pose[1]:-τ:pose[1]
#     else xs = bobby.pose[1]:τ:pose[1] end 
#     if Δy < 0.0 ys = bobby.pose[2]:-τ:pose[2]
#     else ys = bobby.pose[2]:τ:pose[2] end 
#     xs = collect(xs)
#     ys = collect(ys)
#     nleft = length(xs) - length(ys)
#     if nleft > 0 
#         for i = 1:nleft push!(ys, ys[end]) end 
#     else 
#         for i = 1: abs(nleft) push!(xs, xs[end]) end 
#     end 
#     [push!(traj, [x, y, bobby.pose[3]]) for (x,y) in zip(xs, ys)]
#     for (x,y) in zip(xs, ys)
        
#         if !isnothing(bobby.holding)
#             obpose = [bobby.holding.pose[1]+x-bobby.pose[1], bobby.holding.pose[2]+y-bobby.pose[2], bobby.pose[3]]
#             bobby.holding.pose = obpose 
#             push!(obj_traj, [obpose...,bobby.holding.id])
#         else
#             push!(obj_traj, nothing)
#         end
#         bobby.pose = [x,y,bobby.pose[3]]
#     end
# end

function translate!(bobby, pose, traj, obj_traj; τ=1e-1) 
    Δx = pose[1] - bobby.pose[1]
    Δy = pose[2] - bobby.pose[2]
    δ = Δy/Δx
    b = pose[2] - δ*pose[1]
    θ = bobby.pose[3]
    if abs(Δx) ≥ abs(Δy)
        if Δx < 0.0 xs = bobby.pose[1]:-τ:pose[1]
        else xs = bobby.pose[1]:τ:pose[1] end
        xs = collect(xs)
        ys = []
        for x in xs  push!(ys, δ*x+b) end 
    else
        if Δy < 0.0 ys = bobby.pose[2]:-τ:pose[2]
        else ys = bobby.pose[2]:τ:pose[2] end 
        ys = collect(ys)
        xs = []
        for y in ys push!(xs, (y-b)/δ) end 
    end   
    # println("$δ xs $xs"); println("ys $ys\n")
    [push!(traj, [x, y, bobby.pose[3]]) for (x,y) in zip(xs, ys)]
    for (x,y) in zip(xs, ys)
        
        if !isnothing(bobby.holding)
            obpose = [bobby.holding.pose[1]+x-bobby.pose[1], bobby.holding.pose[2]+y-bobby.pose[2], bobby.pose[3]]
            bobby.holding.pose = obpose 
            push!(obj_traj, [obpose...,bobby.holding.id])
        else
            push!(obj_traj, nothing)
        end
        bobby.pose = [x,y,bobby.pose[3]]
    end
end


#RTR motion controller
function go_to!(bobby, pose, traj, obj_traj;last=false) 
    # println(pose)
    # println(bobby.pose)
    θ = atan(pose[2]-bobby.pose[2], pose[1]-bobby.pose[1]) 
    turn!(bobby, θ, traj, obj_traj) 
    translate!(bobby, pose, traj, obj_traj) 
    if last turn!(bobby, pose[3], traj, obj_traj) end
end