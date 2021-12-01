function close_gripper!(robot, state, mvis) 
    left_joint = rbd.findjoint(robot, "rack_to_left_fork")
    right_joint = rbd.findjoint(robot, "rack_to_right_fork")  

    rbd.set_configuration!(state, left_joint, 0.05)
    rbd.set_configuration!(state, right_joint, -0.05)

    rbd.set_configuration!(mvis, rbd.configuration(state))
    
end


function open_gripper!(robot, state, mvis) 
    left_joint = rbd.findjoint(robot, "rack_to_left_fork")
    right_joint = rbd.findjoint(robot, "rack_to_right_fork") 
 
    rbd.set_configuration!(state, left_joint, 0.0)
    rbd.set_configuration!(state, right_joint, -0.0)

    rbd.set_configuration!(mvis, rbd.configuration(state))
    
end


function rotate_gripper!(robot, state, mvis, angle)
    neck_joint = rbd.findjoint(robot, "neck")
    rbd.set_configuration!(state, neck_joint, angle)
    rbd.set_configuration!(mvis, rbd.configuration(state))
end


function follow_trajectory!(robot, state, mvis, angle)
    settransform!(mvis.visualizer["base"], compose(Translation(0.0, 0.0, 0.0), LinearMap(RotZ(angle  ))))
end