//
//  complete_randomizer.h
//  
//
//  Created by Yu Wang on 10/11/16.
//
//

#ifndef complete_randomizer_h
#define complete_randomizer_h


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
            num[i] = i;
        NumericVector index = RcppArmadillo::sample(num, m, false);
        for (int i = 0; i < m; i++)
            chosen[index[i]] = 1;
        return chosen;
    }




#endif /* complete_randomizer_h */
