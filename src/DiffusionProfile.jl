module DiffusionProfile

# Write your package code here.

#include
include("parse_functions.jl")

#using
using DelimitedFiles
using Statistics
using Plots
using BenchmarkTools




#import
obj = readdlm("/Users/seb/Desktop/CO2O2HCO3_graphene_project/wham/HCO3/HCO3fullLj_unLP_wc_PC_wham_window51.dat")

corr = corr_i(obj)

display(plot(corr[:,1],corr[:,2],color = :red,linewidth = 4,xlabel = "t (ps)",ylabel = "< δz(t)δz(0) >",label = "< δz(t)δz(0) >", ylims = (-0.001,0.02)))
savefig("Corr_HCO3_unLP_win51.png")
#@btime corr_i(obj)




end
