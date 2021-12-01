using MeshCat 
using CoordinateTransformations
using Rotations 
using GeometryBasics: HyperRectangle, Vec, Point 
using Colors: RGBA, RGB 
using StaticArrays


function rotate_in_place(vis, angle, position, dimensions)
    r = LinearMap(RotZ(angle))
    ox = dimensions[1]/2. + position[1]
    oy = dimensions[2]/2. + position[2]
    oz = dimensions[3]/2. + position[3]
    rot = recenter(r, SVector(ox, oy, oz))
    settransform!(vis, rot)
end


vis = Visualizer()
render(vis)

dimensions = SVector(1., 1., 1.)
box = HyperRectangle(Vec(0.,0.,0.), Vec(1., 1., 1.))
setobject!(vis, box)


position = SVector(2., 0., 0.)
settransform!(vis, Translation(position))

rotate_in_place(vis, pi/4., position, dimensions)



# rot = LinearMap(RotZ(-pi/4.))
# rot = recenter(rot, [0.5, 0.5, 0.5])
# # transrot = compose(rot, Translation(4.,5.,0))
# settransform!(vis, rot)

