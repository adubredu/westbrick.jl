using MeshCat 
using CoordinateTransformations
using Rotations 
using GeometryBasics: HyperRectangle, Vec, Point 
using Colors: RGBA, RGB 
using StaticArrays


function rotate_in_place(vis, angle, position, dimensions)
    r = LinearMap(RotZ(angle))
    rot = recenter(r, SVector(dimensions[1]/2.,dimensions[2]/2.,dimensions[3]/2.))
    tf = compose(Translation(position[1],position[2],position[3]),rot) 
    settransform!(vis, tf)
end


vis = Visualizer()
render(vis)

dimensions = SVector(1., 1., 1.)
box = HyperRectangle(Vec(-0.5,-0.5,0), Vec(1,1,1))
setobject!(vis, box)


position = SVector(1., 0., 0.)
settransform!(vis, Translation(position))

rotate_in_place(vis, pi/3, position, dimensions)



rot = LinearMap(RotZ(-pi/4.))
rot = recenter(rot, [0.5, 0.5, 0.5])
transrot = compose(rot, Translation(4.,5.,0))
# settransform!(vis, rot)
RotationVec(rot)
