module DiffusionProfile
# This module calculates the corrrelation function <δz(t)δ(0)> and its itegration in time
# for local diffusion coefficient from time series of single observable.

#include
include("my_functions.jl")

#using
using DelimitedFiles
using Statistics
using Plots
using BenchmarkTools

Nwins = 101
z0 = -15.0
dz = 0.3
#Cycle through all umbrella windows to extract D(z)
for win in 1:1
    #import umbrella window time series, calculate <δz(t)δ(0)>.
    obj = readdlm("/Users/seb/Desktop/CO2O2HCO3_graphene_project/wham/HCO3/O2_charged_window$win.dat")
    (corr,corr_cut,var0,tCorr) = corr_i(obj,-15.0+(win-1)*dz)

    #Integrate correlation function from 0 → "∞"
    int_corr = Nint_corr(corr_cut)
    println("Window $win:")
    println("< δz(0)δz(0) > = ",var0," Å^2")
    println("∫< δz(t)δz(0) >dt = ",int_corr," Å^2 ⋅ ps")

    D_i = (var0^2/int_corr)*1e-4
    println("Local diffusion coefficient = ",D_i," cm^2/s")
    println(" ")

    #visualize <δz(t)δ(0)>
    l = length(corr_cut[:,1])
    dash0 = zeros(l,2)
    display(plot(corr_cut[:,1],[corr_cut[:,2],dash0[:,2]],color = [:gray :red],linewidth = [4 1.2],xlabel = "t (ps)",ylabel = "< δz(t)δz(0) >",label = ["< δz(t)δz(0) >"  " 0 "], ylims = (-0.017,0.03),linestyle = [:solid :dashdot]))

    savefig("Corr_O2_charged_win1.png")
end


#@btime corr_i(obj,-15.0)

end
