function pick!(bobby, obj, grasp_angle)
    rotate_gripper!(bobby, grasp_angle)
    bobby.holding = obj 
end

function place!(bobby)
    obj = bobby.holding
    bobby.holding = nothing
    back_up!(bobby, 0.25)
end