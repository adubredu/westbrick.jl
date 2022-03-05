mutable struct Robot 
    pose 
    velocity 
    kp
    kv  
    holding
end

mutable struct Object 
    id 
    pose
    dimensions 
    color
end