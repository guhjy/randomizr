

//
//  simulator.cpp
//  
//
//  Created by Yu Wang on 10/10/16.
//
//

#include <stdio.h>
#include <RcppArmadilloExtensions/sample.h>
//[[Rcpp::depends(RcppArmadillo)]]
#include <Rcpp.h>
#include <complete_randomizer.h>
using namespace Rcpp;


//[[Rcpp::export]]





NumericMatrix simulator (int N, int m, int t)
{
  NumericMatrix resC(N,t+1);
  for (int i = 0; i < t; i++)
  {
    NumericVector r = randomSample(N,m);
   for (int j = 0; j < N; j++)
     resC(j,i) = r[i];
  }
  //calculate the average
  for (int i = 0; i < N; i++)
  {
    for (int j = 0; i < t; j++)
    {
      resC(i,t+1)+= resC(i,j);
    }
    resC(i,t+1) /= t;
  }
  return resC;
}
