#gripper functions
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


#rotation functions
function rotate_bob!(bobby, Δθ)
    angle = Δθ + bobby.orientation[3]
    robot = bobby.mechanism 
    state = bobby.state 
    mvis = bobby.mvis
    position = bobby.position
    r = LinearMap(RotZ(angle)) 
    tf = compose(Translation(position[1],position[2],position[3]),r) 
    settransform!(mvis.visualizer["world/base"], tf)
    bobby.orientation = [0.,0.,angle]
    if !isnothing(bobby.holding)
        object = bobby.holding
        obj_angle = Δθ + object.orientation[3] 
        obj_position = object.position
        obj_r = recenter(LinearMap(RotZ(angle)), position)
        obj_tf = compose(obj_r, Translation(obj_position[1],obj_position[2],obj_position[3]))
        settransform!(mvis.visualizer[object.id], obj_tf)
        object.orientation = [0.,0.,obj_angle]
        return obj_tf.translation
    end
end

function turn!(bobby, angle; tol=1e-2)
    while abs(norm(angle-bobby.orientation[3])) > tol 
        u = bobby.kp*(angle-bobby.orientation[3]) + bobby.kv*(bobby.angular_velocity[3])
        trans = rotate_bob!(bobby, u)
        println("turning ",bobby.orientation[3])
        sleep(0.01)
        # if !isnothing(bobby.holding)
        #     bobby.holding.position = trans 
        # end
    end
    println("done turning")
    

end


#translation functions
function move_forward!(bobby, Δx)
    position = Δx + bobby.position
    mvis = bobby.mvis
    tf = compose(Translation(position), LinearMap(RotZ(bobby.orientation[3])))
    settransform!(mvis.visualizer["world/base"], tf)
    bobby.position = position
    if !isnothing(bobby.holding)
        object = bobby.holding
        obj_position = Δx + object.position 
        obj_tf = compose(Translation(obj_position), LinearMap(RotZ(object.orientation[3])))
        settransform!(mvis.visualizer[object.id], obj_tf)
        object.position = obj_position
    end

end

function translate!(bobby, position; tol=1e-2)
    while abs(norm(position-bobby.position)) > tol 
        u = bobby.kp*(position-bobby.position) + bobby.kv*(bobby.linear_velocity)
        move_forward!(bobby, u)
        println("translating ",bobby.position)
        sleep(0.01)
    end
    println("done translating")
end


#motion functions
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