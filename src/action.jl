function move!(bobby, pose, traj, obj_traj)
    go_to!(bobby, pose, traj, obj_traj) 
end

function pick!(bobby, stance, object, traj, obj_traj)
    turn!(bobby, stance, traj, obj_traj)
    bobby.holding = object 
end

function place!(bobby, stance, traj, obj_traj)
    turn!(bobby, stance, traj, obj_traj)
    bobby.holding = nothing
end