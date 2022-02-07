module westbrick

using GLMakie
using FileIO
using LinearAlgebra

include("types.jl")
include("utils.jl")
include("visualize.jl")
include("pseudocontrol.jl")
include("action.jl")

#methods
export load_robot,
       load_object!,
       init_environment,
       init_visualization,
       visualize_trajectory!,
       visualize_environment!,
       translate!,
       turn!,
       go_to!,
       move!,
       pick!,
       place!

#types
export Object,
       Robot

end