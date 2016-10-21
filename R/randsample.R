#Take a dataframe df and figure out how long it is
#and a number m(how many rows are )
#assign random 1's
##return a logic variable in the data frame

##@return: a numeric vector of size of nrows(df) with 0's and 1's in it.

library(Rcpp)
library(RcppArmadillo)
library(randomizr)

Rcpp::sourceCpp('Documents/Academic/DeclareDesign/local workspace/simulator.cpp')
Rcpp::sourceCpp('Documents/Academic/DeclareDesign/local workspace/complete_randomizer.cpp')


randomSample(10,1)
simulator(10,1,1)

# C simulation
startC <- proc.time()
Cmatrix <- simulator(1000,100,1)
Ctime <- proc.time() - startC

#R
complete_ra <- source('R/complete_ra.R')[[1]]
startR <- proc.time()
complete_ra(1000,100)
