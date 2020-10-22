# function to calculate the volume of a sphere
function sphere_vol(r)
    # julia allows Unicode names (in UTF-8 encoding)
    # so either "pi" or the symbol π can be used
    return 4/3*pi*r^3
end

function diff_i(W)
    dt = 2 #2 fs timestep
    t = @view W[:,1] #time time series
    z = @view W[:,2] # z time series
    U = @view W[:,3] # Potential energy time series
    dot = Array{Float64,2}(undef,(length(t)-1),2) #initilize array of velocities and energy gradients
    for i = 1:(length(z)-1)
        dz =  z[i+1] - z[i]
        dot[i,1] = (dz / dt)^2
        dot[i,2] = (U[i+1]-U[i]) / dz
    end
    zdot = sqrt(mean(dot[:,1]))
    Udot = mean(dot[:,2])


    Di = (zdot / (Udot / 0.593))*1e-1
    return zdot, Udot, Di

end


# functions can also be defined more succinctly
quadratic(a, sqr_term, b) = (-b + sqr_term) / 2a

# calculates x for 0 = a*x^2+b*x+c, arguments types can be defined in function definitions
function quadratic2(a::Float64, b::Float64, c::Float64)
    # unlike other languages 2a is equivalent to 2*a
    # a^2 is used instead of a**2 or pow(a,2)
    sqr_term = sqrt(b^2-4a*c)
    r1 = quadratic(a, sqr_term, b)
    r2 = quadratic(a, -sqr_term, b)
    # multiple values can be returned from a function using tuples
    # if the return keyword is omitted, the last term is returned
    r1, r2



end
