using Revise
using westbrick


obs_dict, ax, fig = visualize_environment!([])
bobby = load_robot()
traj, obj_traj = init_visualization()

pose = [5.0, 4., 0.0]
move!(bobby, pose, traj, obj_traj) 

pose = [1.0, 5.0, 0.0]
move!(bobby, pose, traj, obj_traj)

pose = [3., 5.0, 0.0]
move!(bobby, pose, traj, obj_traj)

pose = [0, 5.0, 0.0]
move!(bobby, pose, traj, obj_traj)

visualize_trajectory!(bobby, traj, obj_traj, obs_dict, ax, fig;name="media/move_test.gif")