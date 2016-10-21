//
//  complete_randomizer.cpp
//
//
//  Created by Yu Wang on 10/4/16.
//
//

#include <stdio.h>
#include <RcppArmadilloExtensions/sample.h>
//[[Rcpp::depends(RcppArmadillo)]]
#include <Rcpp.h>
using namespace Rcpp;


//[[Rcpp::export]]


NumericVector randomSample(int N, int m=-1)
{
    NumericVector num(N), chosen(N,0.);
      for (int i = 0; i < N; i++)
        num[i] = i+1;
    NumericVector index = Rcpp::RcppArmadillo::sample(num, m, false);
    for (int i = 0; i < m; i++)
      chosen[index[i]] = 1;
    return chosen;
}


