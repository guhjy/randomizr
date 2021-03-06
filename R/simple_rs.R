#' Simple Random Sampling
#'
#' simple_rs implements a random sampling procedure in which units are independently sampled. Because units are sampled independently, the number of units that are sampled can vary from sample to sample. For most applications in which the number of units in the sampling frame is known in advance, \code{\link{complete_rs}} is better because the number of units sampled is fixed across sampled.\cr\cr
#'
#' @param N The number of units. N must be a positive integer. (required)
#' @param prob prob is the probability of being sampled must be a real number between 0 and 1 inclusive. (optional)
#' @param check_inputs logical. Defaults to TRUE.
#'
#' @return A numeric vector of length N that indicates if a unit is sampled (1) or not (0).
#' @export
#'
#' @importFrom stats rbinom
#'
#' @examples
#'
#' S <- simple_rs(N = 100)
#' table(S)
#'
#' S <- simple_rs(N = 100, prob = 0.3)
#' table(S)
#'
simple_rs <-
  function(N, prob = NULL,
           check_inputs = TRUE) {
    
    if(check_inputs){
      
      input_check <-
        check_samplr_arguments(N = N,
                               prob = prob)
    }
    
    if (is.null(prob)) {
      prob <- 0.5
    }
    
    assignment <- rbinom(n = N, size = 1, prob = prob)
    return(assignment)
  }