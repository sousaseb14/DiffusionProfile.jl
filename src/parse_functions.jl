# function to calculate the <δz(t)δ(0)> and its itegration in time
# for local diffusion coefficient from time series of single observable.

#construct correlator from umbrella window time series.
function corr_i(W)
    dt = 2 #2 fs timestep
    tCorr = 7500 #time over which correlations expected to die off.
    z = @view W[:,2] # z time series
    nSamp = length(z)
    corr = zeros(tCorr,2) #initilize array that will contain correlation averges for a given t.
    norm = zeros(tCorr,1) #array of normalizations for different t.
    for i in 1:(nSamp-tCorr-1) #loop over all samples
        tMax = nSamp
        if i == 1
            tMax = tCorr
        end
        if i+tCorr<nSamp
            tMax = (i-1) + tCorr
        end
        for j in (i+1):tMax
            t = (j - i)
            corr[t,2] = corr[t,2] + z[j]*z[i]
            corr[t,1] = t*dt/1000 #conv to picoseconds.
            norm[t] = norm[t] + 1
            #println(j)
        end
        if i % tCorr == 0
            println(norm[1])
        end
    end
    for k = 1:tCorr
        corr[k,2] = corr[k,2]/norm[k]
    end

    return corr
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
