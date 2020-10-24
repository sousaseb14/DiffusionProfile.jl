# function to calculate the <δz(t)δ(0)> and its itegration in time
# for local diffusion coefficient from time series of single observable.

#construct correlator from umbrella window time series.
function corr_i(W)
    dt = 2 #2 fs timestep
    tCorr = 3000 #time over which correlations expected to die off.
    z =  W[:,2] .+ 15.0 # z time series
    nSamp = length(z)
    corr = zeros(tCorr,2) #initilize array that will contain correlation averges for a given t.
    norm = zeros(tCorr,1) #array of normalizations for different t.
    for i in 1:(nSamp-tCorr-1) #loop over all samples (as separate time origins)
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

    ##################################
    #Below I make the resolution for longer times more coarse, to get rid of some of the noise
    #that might impact numerical integration.
    corr_cut = zeros(trunc(Int,750+2250/150),2)
    idx = 1
    for kk = 1:750
        corr_cut[kk,2] = corr[kk,2]
        corr_cut[kk,1] = corr[kk,1]
        idx = idx + 1
    end
    for jj in 751:150:tCorr
        corr_cut[idx,2] = corr[jj,2]
        corr_cut[idx,1] = corr[jj,1]
        idx = idx + 1
    end
    ##################################

    return corr_cut
end
