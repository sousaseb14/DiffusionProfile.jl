module DiffusionProfile


#include
include("parse_functions.jl")

#using
using DelimitedFiles
using Statistics
using Plots
using BenchmarkTools

#import umbrella window time series, calculate <δz(t)δ(0)>.
obj = readdlm("/Users/seb/Desktop/CO2O2HCO3_graphene_project/wham/HCO3/wham_window15.dat")
(corr,corr_cut,var0,tCorr) = corr_i(obj,-10.8)

#visualize <δz(t)δ(0)>
l = length(corr_cut[:,1])
dash0 = zeros(l,2)
display(plot(corr_cut[:,1],[corr_cut[:,2],dash0[:,2]],color = [:gray :red],linewidth = [4 1.2],xlabel = "t (ps)",ylabel = "< δz(t)δz(0) >",label = ["< δz(t)δz(0) >"  " 0 "], ylims = (-0.001,0.03),linestyle = [:solid :dashdot]))
println("< δz(0)δz(0) > = ",var0, " Å^2")

#Integrate correlation function from 0 → "∞"
int_corr = Nint_corr(corr_cut)
println("∫< δz(0)δz(0) >dt = ",int_corr," Å^2 ⋅ ps")

D_i = (var0^2/int_corr)*1e-4
println("Local diffusion coefficient = ",D_i," cm^2/s")


#savefig("Corr_HCO3_unLP_win15.png")
#@btime corr_i(obj,-15.0)

end
