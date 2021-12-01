module bob

using MeshCat
using MeshCatMechanisms
using Colors
using CoordinateTransformations
using Rotations 
using RigidBodyDynamics

rbd = MeshCatMechanisms.rbd 

include("utils.jl")
include("control.jl")

export load_bob,
       open_gripper!,
       close_gripper!,
       follow_trajectory!

end
