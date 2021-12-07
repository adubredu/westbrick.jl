function move_forward!(bobby, Δx, traj, obj_traj)
    θ = bobby.pose[3]
    x = Δx[1]*cos(θ)
    y = Δx[2]*sin(θ)
    pose = [bobby.pose[1]+x, bobby.pose[2]+y, θ] 
    push!(traj, pose)
    bobby.pose = pose
    if !isnothing(bobby.holding)
        obpose = [bobby.holding.pose[1]+x, bobby.holding.pose[2]+y, θ]
        bobby.holding.pose = obpose 
        push!(obj_traj, [obpose...,bobby.holding.id])
    else
        push!(obj_traj, nothing)
    end
end

function translate!(bobby, pose, traj, obj_traj; tol=1e-2) 
    while(abs(norm(pose[1:2]-bobby.pose[1:2])) > tol)
        u = bobby.kp*abs.(pose[1:2]-bobby.pose[1:2]) + bobby.kv*(bobby.velocity[1:2])
        move_forward!(bobby, u, traj, obj_traj)  
    end
    return traj
end

function rotate!(bobby, Δθ, traj, obj_traj)
    θ = bobby.pose[3] + Δθ
    pose = [bobby.pose[1], bobby.pose[2], θ]
    push!(traj, pose)
    bobby.pose = pose
    if !isnothing(bobby.holding)
        R = [cos(θ) -sin(θ); 
             sin(θ)  cos(θ)] 
        Δxy = [0.6, 0.]
        oxy = R*Δxy
        obpose = [bobby.pose[1]+oxy[1], bobby.pose[2]+oxy[2], θ]

        bobby.holding.pose = obpose 
        push!(obj_traj, [obpose...,bobby.holding.id])
    else
        push!(obj_traj, nothing)
    end
end


function turn!(bobby, angle, traj, obj_traj; tol=1e-2) 
    while(abs(norm(angle-bobby.pose[3])) > tol)
        u = bobby.kp*(angle-bobby.pose[3]) + bobby.kv*(bobby.velocity[3])
        rotate!(bobby, u, traj, obj_traj)
    end
    return traj
end

function go_to!(bobby, pose, traj, obj_traj) 
    θ = atan(pose[2]-bobby.pose[2], pose[1]-bobby.pose[1])
    println("rotating")
    turn!(bobby, θ, traj, obj_traj)
    println("translating")
    translate!(bobby, pose, traj, obj_traj)
    println("rotating")
    turn!(bobby, pose[3], traj, obj_traj) 
end