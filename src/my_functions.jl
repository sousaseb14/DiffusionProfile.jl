#Construct correlator from umbrella window time series.
function corr_i(W,mean)
    dt = 2 #2 fs timestep
    tCorr = 3000 #time over which correlations expected to die off.
    z =  W[:,2] .- mean # z time series (centered)
    nSamp = length(z)
    corr = zeros(tCorr+1,2) #initilize array that will contain correlation averges for a given t.
    norm = zeros(tCorr+1,1) #array of normalizations for different t.
    corr[1,1] = 0.0
    var0 = var(z)
    corr[1,2] = var0
    for i in 1:(nSamp) #loop over all samples (as separate time origins)
        tMax = nSamp
        if i+tCorr<nSamp
            tMax = i + tCorr
        end
        idx = 2 #shift index to account for  <δz(0)δ(0)> term.
        for j in (i+1):tMax
            t = (j - i)
            corr[idx,2] = corr[idx,2] + z[j]*z[i]
            corr[idx,1] = t*dt/1000 #conv to picoseconds.
            norm[idx] = norm[idx] + 1
            idx = idx + 1
        end
        #if i % tCorr == 0
        #    println(norm[2])
        #end
    end
    for k = 2:length(corr[:,1])
        corr[k,2] = corr[k,2]/norm[k]
    end

    #println(corr[length(corr[:,2]),1]," ",corr[length(corr[:,2]),2])

    ##################################
    #Below I make the resolution for longer times more coarse, to get rid of some of the noise
    #that might impact numerical integration.
    corr_cut = zeros(trunc(Int,1+750+2250/150),2)
    idx = 1
    for kk = 1:750
        corr_cut[kk,2] = corr[kk,2]
        corr_cut[kk,1] = corr[kk,1]
        idx = idx + 1
    end
    for jj in 751:150:(tCorr+1)
        corr_cut[idx,2] = corr[jj,2]
        corr_cut[idx,1] = corr[jj,1]
        idx = idx + 1
    end
    ###################################


    return corr, corr_cut, var0, tCorr
end

#Integrate correlation function from 0 → "∞". Trapezoid rule.
function Nint_corr(δδ)
    l = length(δδ[:,2])
    s = 0
    for i in 1:(l-1)
        s = s + (δδ[i+1,1] - δδ[i,1])*0.5*(δδ[i+1,2] + δδ[i,2])
    end
    return s
end
