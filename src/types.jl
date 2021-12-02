mutable struct Robot 
    position
    orientation
    linear_velocity 
    angular_velocity
    kp
    kv 
    mechanism 
    mvis 
    state 
    holding
end

mutable struct Object 
    id
    body
    position 
    orientation 
    dimensions 
end