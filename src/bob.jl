module bob

using GLMakie
using FileIO
using LinearAlgebra

include("types.jl")
include("utils.jl")
include("visualize.jl")
include("control.jl")

#methods
export load_robot,
       load_object!,
       animate!,
       translate!,
       turn!,
       go_to!

#types
export Object,
       Robot

end