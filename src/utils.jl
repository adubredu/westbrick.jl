function load_robot()
    robot = Robot([0.,0.,0.], [0.,0.,0.], 0.1, 0.3, nothing)
    return robot
end

function load_object(pose, dimensions, id)
    dimensions = [0.4, 0.4] 
    object = Object(id, pose, dimensions)
    return object
end

function init_environment(num_objects, positions)
    dimensions = [0.4, 0.4]
    objects = []
    for i=1:num_objects
        push!(objects, load_object(positions[i][1:2], dimensions, i))
    end
    return objects 
end