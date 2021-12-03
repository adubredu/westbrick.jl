using Revise
using bob 
using MeshCat
using StaticArrays
using CoordinateTransformations

bobby = load_bob()
render(bobby.mvis)

obj = create_object!([0.75, 0.3, 0], [0.4,0.4,0.4], 1, bobby)
pick!(bobby, obj, 0.0)

# position = SVector(2., 0., 0.)
# translate!(bobby, position)
# turn!(bobby, -pi/3.)


position = SVector(-2,-2, 0.)
go_to!(bobby, position, 0.0)

place!(bobby)