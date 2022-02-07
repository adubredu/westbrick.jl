using Revise
using westbrick 

num_objects = 13 
positions = [[i,j] for (i,j) in zip(rand(3:8, num_objects),rand(-8:-3, num_objects))]
place_pose = [[-2, 2, 0.],[-2, 3, 0.],[-2, 4, 0.], [-2, 5, 0.],[-2, 6, 0.],[-1, 5, 0.], [0, 4, 0.],[1, 5, 0.],[2, 6, 0.],[2, 5, 0.],[2, 4, 0.],[2, 3, 0.],[2, 2, 0.]]

objects = init_environment(num_objects, positions)
obs_dict, ax, fig = visualize_environment!(objects)

bobby = load_robot()
traj, obj_traj = init_visualization()

function lay_block!(i)
    pose = [positions[i][1], positions[i][2]+0.5, -π/2.]
    move!(bobby, pose, traj, obj_traj)
    pick!(bobby, -π/2., objects[i], traj, obj_traj)
    move!(bobby, place_pose[i], traj, obj_traj)
    place!(bobby, -π/2., traj, obj_traj)
    move!(bobby, [0.1,0.1, π/2.], traj, obj_traj)
end
 
for i = 1:num_objects
    lay_block!(i)
    # println("laid block ",i)
end

println("visualizing...")
visualize_trajectory!(bobby, traj, obj_traj, obs_dict, ax, fig;name="media/build_L.gif")
