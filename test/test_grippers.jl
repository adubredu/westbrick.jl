using Revise
using bob 
using MeshCat
using StaticArrays
using CoordinateTransformations

robot, state, mvis = load_bob()
render(mvis)

close_gripper!(robot, state, mvis)
open_gripper!(robot, state, mvis)

position = SVector(1., 0., 0.)
settransform!(mvis.visualizer["world/base"], Translation(position))
# settransform!(mvis.visualizer["world/rack"], Translation(position))


# follow_trajectory!(robot, state, mvis, -pi)
rotate_bob!(robot, state, mvis, pi, position)