module DiffusionProfile

# Write your package code here.

#include
include("parse.jl")

#using
using DelimitedFiles
using Statistics
using Plots
using BenchmarkTools




#import
obj = readdlm("/Users/seb/Desktop/CO2O2HCO3_graphene_project/wham/HCO3/HCO3fullLj_unLP_wc_PC_wham_window51.dat")

(zdot,Udot,Di) = diff_i(obj)
println(zdot," angstroms/femtoseconds")
println(Udot," kcal/mol*angstrom")
println(Di," cm^2/s")

@btime diff_i(obj)



#Do stuff
vol = sphere_vol(4)
# @printf allows number formatting but does not automatically append the \n to statements, see below
using Printf
@printf "volume = %0.3f\n" vol
#> volume = 113.097

quad3, quad4 = quadratic2(2.0, -2.0, -12.0)
println("result 3 ", quad3)
#> result 1: 3.0
println("result 4: ", quad4)
#> result 2: -2.0



end
