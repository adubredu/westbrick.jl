function close_gripper!(bobby) 
    robot = bobby.mechanism 
    state = bobby.state 
    mvis = bobby.mvis
    left_joint = rbd.findjoint(robot, "rack_to_left_fork")
    right_joint = rbd.findjoint(robot, "rack_to_right_fork")  

    rbd.set_configuration!(state, left_joint, 0.05)
    rbd.set_configuration!(state, right_joint, -0.05)

    rbd.set_configuration!(mvis, rbd.configuration(state))
    
end


function open_gripper!(bobby) 
    robot = bobby.mechanism 
    state = bobby.state 
    mvis = bobby.mvis
    left_joint = rbd.findjoint(robot, "rack_to_left_fork")
    right_joint = rbd.findjoint(robot, "rack_to_right_fork") 
 
    rbd.set_configuration!(state, left_joint, 0.0)
    rbd.set_configuration!(state, right_joint, -0.0)

    rbd.set_configuration!(mvis, rbd.configuration(state))
    
end


function rotate_gripper!(bobby, angle)
    robot = bobby.mechanism 
    state = bobby.state 
    mvis = bobby.mvis
    neck_joint = rbd.findjoint(robot, "neck")
    rbd.set_configuration!(state, neck_joint, angle)
    rbd.set_configuration!(mvis, rbd.configuration(state))
end

function rotate_bob!(bobby, angle)
    robot = bobby.mechanism 
    state = bobby.state 
    mvis = bobby.mvis
    position = bobby.position
    r = LinearMap(RotZ(angle)) 
    tf = compose(Translation(position[1],position[2],position[3]),r) 
    settransform!(mvis.visualizer["world/base"], tf)
    bobby.orientation = [0.,0.,angle]
end

function move_forward!(bobby, position)
    mvis = bobby.mvis
    tf = compose(Translation(position), LinearMap(RotZ(bobby.orientation[3])))
    settransform!(mvis.visualizer["world/base"], tf)
    bobby.position = position
end

function turn!(bobby, angle; tol=1e-2)
    while abs(norm(angle-bobby.orientation[3])) > tol 
        u = bobby.kp*(angle-bobby.orientation[3]) + bobby.kv*(bobby.angular_velocity[3])
        rotate_bob!(bobby, u+bobby.orientation[3])
        println("turning ",bobby.orientation[3])
        sleep(0.01)
    end
    println("done turning")

end

function translate!(bobby, position; tol=1e-2)
    while abs(norm(position-bobby.position)) > tol 
        u = bobby.kp*(position-bobby.position) + bobby.kv*(bobby.linear_velocity)
        move_forward!(bobby, u+bobby.position)
        println("translating ",bobby.position)
        sleep(0.01)
    end
    println("done translating")
end

function go_to!(bobby, position)
    angle = atan(position[2]-bobby.position[2], position[1]-bobby.position[1])
    turn!(bobby, angle)
    sleep(0.2)
    translate!(bobby, position)

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