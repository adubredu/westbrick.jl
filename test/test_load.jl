using Revise
using bob

bobby = load_robot() 
load_object!(bobby, 1)
traj, obj_traj = go_to!(bobby, [0.,7.,0.]) 
println("animating")
animate!(bobby, nothing, traj, obj_traj)