module bob

using MeshCat
using MeshCatMechanisms
using Colors
using CoordinateTransformations
using Rotations 
using StaticArrays
using RigidBodyDynamics
using LinearAlgebra
using GeometryBasics: HyperRectangle, Vec, Point 

rbd = MeshCatMechanisms.rbd 

include("types.jl")
include("utils.jl")
include("control.jl")
include("actions.jl")

export load_bob,
       open_gripper!,
       close_gripper!,
       follow_trajectory!,
       rotate_bob!,
       translate!,
       turn!,
       go_to!,
       create_object!,
       pick!, 
       place!

end
