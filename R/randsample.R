#Take a dataframe df and figure out how long it is
#and a number m(how many rows are )
#assign random 1's
##return a logic variable in the data frame

##@return: a numeric vector of size of nrows(df) with 0's and 1's in it.

library(Rcpp)
library(RcppArmadillo)
#library(randomizr)

Rcpp::compileAttributes()

#Rcpp::sourceCpp('src/simulator.cpp')
#random_Sample_imp<-function(N,m)
#{.Call("randomSample", N, m, PACKAGE = "randomizr")}

#simulator_imp<-function(a,b,c)
#{.Call("simulator",a,b,c,PACKAGE = "randomizr")}
#random_Sample_imp(10,1)
#simulator(10,1,1)

set.seed()
# C simulation
startC <- proc.time()
Cmatrix <- simulator(1000,100,1)
Ctime <- proc.time() - startC

#R
#complete_ra <- source('R/complete_ra.R')[[1]]
startR <- proc.time()
a <- complete_ra(1000,100)
Rtime <- proc.time() - startR
