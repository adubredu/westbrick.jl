
packagepath() = joinpath(@__DIR__,"..")
urdfpath() = joinpath(packagepath(), "models", "bob.urdf")
blockurdf()= joinpath(packagepath(), "models", "block.urdf")
left_joint = nothing 
right_joint = nothing 
neck_joint = nothing
dimensions = SVector(0.3, 0.6, 0.3)


function default_background!(mvis)
    vis = mvis.visualizer
    setvisible!(vis["/Background"], true)
    setprop!(vis["/Background"], "top_color", RGBA(1.0, 1.0, 1.0, 1.0))
    setprop!(vis["/Background"], "bottom_color", RGBA(0.0, 0.0, 0.0, 1.0))
    setvisible!(vis["/Axes"], false)
end


function load_bob()
    robot = RigidBodyDynamics.parse_urdf(urdfpath(); floating=true) 
    vis = Visualizer()
    mvis = MechanismVisualizer(robot, URDFVisuals(urdfpath(), package_path=[packagepath()]))  
    state = rbd.MechanismState(robot)
    default_background!(mvis)
    settransform!(vis["world/base"], Translation(0.0,0.0,0.15))
    settransform!(vis["/Cameras/default"],
            compose(Translation(0.0, 0.0, 3.0), LinearMap(RotY(-pi/2.  )))) 
    bobby = Robot([0.,0.,0.], [0.,0.,0.], [0.,0.,0.], [0.,0.,0.], 0.01, 0.3,
                 robot, mvis, state, nothing)
    return bobby 
end

function load_block(id, bobby)
    block = RigidBodyDynamics.parse_urdf(blockurdf(); floating=true) 
    vis = Visualizer()
    mvis = MechanismVisualizer(block, URDFVisuals(blockurdf(), package_path=[packagepath()]))  
    state = rbd.MechanismState(block)
    default_background!(mvis)
    strid = "world/block"*string(id)
    settransform!(vis[strid], Translation(0.0,0.0,0.15))
    settransform!(vis["/Cameras/default"],
            compose(Translation(0.0, 0.0, 3.0), LinearMap(RotY(-pi/2.  )))) 
    bobby = Robot([0.,0.,0.], [0.,0.,0.], [0.,0.,0.], [0.,0.,0.], 0.01, 0.3,
                 robot, mvis, state, nothing)
    return bobby 


    obj = RigidBodyDynamics.parse_urdf(blockurdf(); floating=true)
    idstr = "world/block"*string(id)
    setobject!(bobby.mvis.visualizer[idstr], obj)
    settransform!(bobby.mvis.visualizer[idstr], Translation(position))
    object =  Object(idstr, obj, position, [0.,0.,0.], dimensions)
    return object 
end

function create_object!(position, dimensions, id, bobby; geometry_type=:cube)
    obj = HyperRectangle(Vec(-0.5,-0.5,0), Vec(dimensions...))
    idstr = "world/"*string(id)
    setobject!(bobby.mvis.visualizer[idstr], obj)
    settransform!(bobby.mvis.visualizer[idstr], Translation(position))
    object =  Object(idstr, obj, position, [0.,0.,0.], dimensions)
    return object 
end
