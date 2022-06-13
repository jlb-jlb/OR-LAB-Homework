## Packages and Environments ##

# There are different types of packages: Standard Library, registered in the General registry, "self-made"
# The documentation for all packages in the Standard Library is found in the Julia Documentation
# https://docs.julialang.org/en/v1/

# Different ressources to browse the General registry can be found here
# https://julialang.org/packages/

# "Self-made" versions can be downloaded e.g. directly from github
# Hot, new dev-versions that are slightly faster but break all the time

#Two different ways to use the package manager
# Using the package manager directly via terminal:
# Pressing "]" opens the Pkg-REPL
# status
# help 

#Using the package manager outside of the Pkg-REPL
#Installing and using packages
using Pkg #To install and use packages withoute the Pkg-REPL, we use the Pkg package which is pre-installed
Pkg.status() #Checking the packages that are installed in our (default) environment
Pkg.add("JuMP") #Installs the JuMP package

Pkg.generate("OR-LAB") #generates an error
Pkg.generate("ORLAB") #generates an environment
Pkg.activate("ORLAB") #we are now working in that environment
Pkg.status() #it starts of clean

#installs a package directly from github into our environment.
#If it breaks something, our default environment will not be affected.
Pkg.add("https://github.com/jump-dev/JuMP.jl")
Pkg.add("Statistics")
Pkg.exit() #Quits julia, after restaring julia we are back in the default environment.

# using Pkg
# Pkg.add("Statistics") #Packages only need to be installed once.
mean([1,2,3,5]) #Without a package, julia does not know a function called "mean".


# Let us explore the package that we want to use as an example.
# It is part of the standard library, therefore we can find its documentation right on the julia webpage.
# https://docs.julialang.org/en/v1/stdlib/Statistics/ 
using Statistics

mean([1,2,3,5])
