function load_robot()
    robot = Robot([0.,0.,0.], [0.,0.,0.], 0.1, 0.3, nothing)
    return robot
end

function load_object!(bobby, id)
    dimensions = [0.4, 0.4]
    pose = [0.6, 0., 0.]
    object = Object(id, pose, dimensions)
    bobby.holding = object 
end