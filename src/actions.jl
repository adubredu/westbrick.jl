function pick!(obj, bobby)
    bobby.holding = obj 
    
end

function place!(bobby, dest_position, dest_orientation)
    obj = bobby.holding
    bobby.holding = nothing
end