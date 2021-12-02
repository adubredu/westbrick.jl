using Revise
using bob 
using MeshCat
using StaticArrays
using CoordinateTransformations

bobby = load_bob()
render(bobby.mvis)

close_gripper!(bobby)
open_gripper!(bobby)

position = SVector(0., 0., 0.)
translate!(bobby, position)  


# follow_trajectory!(robot, state, mvis, -pi)
bobby.kp=0.01
turn!(bobby, 0)

position = SVector(2,2, 0.)
go_to!(bobby, position)