using Revise
using westbrick 

num_objects = 5
positions = [[i,j] for (i,j) in zip([4.,3.,2.,2.5,0.3],[2.,3.,4.,2.,4.])]
objects = init_environment(num_objects, positions)
obs_dict = visualize_environment!(objects)

bobby = load_robot()
traj, obj_traj = init_visualization()

pose = [positions[1]...,π]
move!(bobby, pose, traj, obj_traj)
pick!(bobby, π, objects[1], traj, obj_traj)
move!(bobby, [-3.,-3., 0.], traj, obj_traj)
place!(bobby, -π, traj, obj_traj)
move!(bobby, [3.,-3., 0.], traj, obj_traj)

pose = [positions[5]...,π]
move!(bobby, pose, traj, obj_traj)
pick!(bobby, π, objects[5], traj, obj_traj)
move!(bobby, [-2.,-3., 0.], traj, obj_traj)
place!(bobby, -π, traj, obj_traj)
move!(bobby, [3.,-3., 0.], traj, obj_traj)

println("visualizing...")
visualize_trajectory!(bobby, traj, obj_traj, obs_dict)
