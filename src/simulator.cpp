

//
//  simulator.cpp
//  
//
//  Created by Yu Wang on 10/10/16.
//
//

#include <stdio.h>
#include <RcppArmadillo.h>
#include <RcppArmadilloExtensions/sample.h>
//[[Rcpp::depends(RcppArmadillo)]]
#include <Rcpp.h>
#include "complete_randomizer.h"
using namespace Rcpp;

//[[Rcpp::export]]





Rcpp::NumericMatrix simulator (int N, int m, int t)
{
  Rcpp::NumericMatrix resC(N,t+1);
  
  for (int i = 0; i < t; i++)
  {
    NumericVector r = randomSample(N,m);
    for (int j = 0; j < N; j++)
    {
      resC(j,i) = r(j);
    }
  }
  
  //calculate the average
  for (int i = 0; i < N; i++)
  {
    for (int j = 0; j < t; j++)
    {
      resC(i,t) = resC(i,t) + resC(i,j);
    }
    resC(i,t) /= (double) t;
  }
  
  return resC;
  
}
