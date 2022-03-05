using Revise
using westbrick 

# specifying number of packages
num_objects = 8 

# setting initial poses of packages
positions = [[i,j] for (i,j) in zip(rand(3:8, num_objects),rand(-8:-3, num_objects))]

# setting placement poses of packages
place_pose = [[-2, 2, 0.],[-2, 3, 0.],[-2, 4, 0.], [-2, 5, 0.],[-2, 6, 0.], [-1, 2, 0.], [0, 2, 0.], [1, 2, 0.]]

# initializing warehouse environment
objects = init_environment(num_objects, positions)
obs_dict, ax, fig = visualize_environment!(objects)

# loading robot
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

# running sequences of pick-move-place action primitives to 
# place packages at placement poses
for i = 1:num_objects
    lay_block!(i) 
end

# visualizing the simulation
# To save the simulation as a gif, specify a file name that ends in .gif. To save the simulation as a video, specify a file name that ends in .mp4
println("visualizing...")
visualize_trajectory!(bobby, traj, obj_traj, obs_dict, ax, fig;name="media/build_L.gif")