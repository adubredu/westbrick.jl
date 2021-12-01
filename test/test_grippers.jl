using Revise
using bob 
using MeshCat

robot, state, mvis = load_bob()
render(mvis)

close_gripper!(robot, state, mvis)
open_gripper!(robot, state, mvis)

follow_trajectory!(robot, state, mvis, -pi)