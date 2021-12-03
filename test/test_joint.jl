using Revise 
using RigidBodyDynamics
using CoordinateTransformations
using Rotations 
using GeometryBasics: HyperRectangle, Vec, Point 
using Colors: RGBA, RGB 
using StaticArrays
using MeshCatMechanisms
using MeshCat

vis = Visualizer()
render(vis)

urdf = "/home/alphonsus/research/projects/bob/models/block.urdf"
block1 = parse_urdf(urdf; floating=true)
block2 = parse_urdf(urdf; floating=true)
mvis = MechanismVisualizer(block1, URDFVisuals(urdf), vis["block1"])
mvis2 = MechanismVisualizer(block2, URDFVisuals(urdf), vis["block2"])
 
settransform!(vis["block2"], Translation(SVector(1., 5., 0.)))


holdjoint = Joint("holding", Fixed{Float64}())

# world = RigidBody{Float64}("world")
# robot = Mechanism(world)
robo = attach!(block1, bodies(block1)[2], bodies(block2)[2], holdjoint)

mvis3 = MechanismVisualizer(robo, URDFVisuals(urdf), vis["robo"])
rob = attach!(block1, bodies(block1)[2], block2)
settransform!(vis["block1"], Translation(SVector(1.5,1.5, 0.)))
state = MechanismState(robo)
state.