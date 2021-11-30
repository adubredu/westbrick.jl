using MeshCat
using MeshCatMechanisms
rbd = MeshCatMechanisms.rbd

vis =  Visualizer()
render(vis)

urdf = "models/bob.urdf"
robot = MeshCatMechanisms.parse_urdf(urdf)
mvis = MechanismVisualizer(robot, URDFVisuals(urdf), vis)

neck = rbd.findjoint(robot, "neck")
robotstate = rbd.MechanismState(robot)
rbd.set_configuration!(mvis, neck, 1.0)

left_gripper = rbd.findjoint(robot, "rack_to_left_fork")
rbd.set_configuration!(mvis, left_gripper, 0.1)

right_gripper = rbd.findjoint(robot, "rack_to_right_fork")
rbd.set_configuration!(mvis, right_gripper, -0.1)

rbd.configuration(robotstate)