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

function rotate_bob!(robot, state, mvis, angle, position)
    r = LinearMap(RotZ(angle))
    rot = recenter(r, SVector(dimensions[1]/2.,dimensions[2]/2.,dimensions[3]/2.))
    tf = compose(Translation(position[1],position[2],position[3]),rot) 
    settransform!(mvis.visualizer["world/base"], tf)
end


function follow_trajectory!(robot, state, mvis, angle)
    settransform!(mvis.visualizer["base"], compose(Translation(0.0, 0.0, 0.0), LinearMap(RotZ(angle  ))))
end

# function rotate_in_place(vis, angle, position, dimensions)
#     r = LinearMap(RotZ(angle))
#     rot = recenter(r, SVector(dimensions[1]/2.,dimensions[2]/2.,dimensions[3]/2.))
#     tf = compose(Translation(position[1],position[2],position[3]),rot) 
#     settransform!(vis, tf)
# end