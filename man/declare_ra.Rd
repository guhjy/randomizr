% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/declare_ra.R
\name{declare_ra}
\alias{declare_ra}
\title{Declare a random assignment procedure.}
\usage{
declare_ra(N = NULL, block_var = NULL, clust_var = NULL, m = NULL,
  m_each = NULL, prob = NULL, prob_each = NULL, block_m = NULL,
  block_m_each = NULL, block_prob = NULL, block_prob_each = NULL,
  num_arms = NULL, condition_names = NULL, simple = FALSE,
  check_inputs = TRUE)
}
\arguments{
\item{N}{The number of units. N must be a positive integer. (required)}

\item{block_var}{A vector of length N that indicates which block each unit belongs to.}

\item{clust_var}{A vector of length N that indicates which cluster each unit belongs to.}

\item{m}{Use for a two-arm design in which m units (or clusters) are assigned to treatment and N-m units (or clusters) are assigned to control. In a blocked design, exactly m units in each block will be treated. (optional)}

\item{m_each}{Use for a multi-arm design in which the values of m_each determine the number of units (or clusters) assigned to each condition. m_each must be a numeric vector in which each entry is a nonnegative integer that describes how many units (or clusters) should be assigned to the 1st, 2nd, 3rd... treatment condition. m_each must sum to N. (optional)}

\item{prob}{Use for a two-arm design in which either floor(N*prob) or ceiling(N*prob) units (or clusters) are assigned to treatment. The probability of assignment to treatment is exactly prob because with probability 1-prob, floor(N*prob) units (or clusters) will be assigned to treatment and with probability prob, ceiling(N*prob) units (or clusters) will be assigned to treatment. prob must be a real number between 0 and 1 inclusive. (optional)}

\item{prob_each}{Use for a multi-arm design in which the values of prob_each determine the probabilties of assignment to each treatment condition. prob_each must be a numeric vector giving the probability of assignment to each condition. All entries must be nonnegative real numbers between 0 and 1 inclusive and the total must sum to 1. Because of integer issues, the exact number of units assigned to each condition may differ (slightly) from assignment to assignment, but the overall probability of assignment is exactly prob_each. (optional)}

\item{block_m}{Use for a two-arm design in which block_m describes the number of units to assign to treatment within each block. Note that in previous versions of randomizr, block_m behaved like block_m_each.}

\item{block_m_each}{Use for a multi-arm design in which the values of block_m_each determine the number of units (or clusters) assigned to each condition. block_m_each must be a matrix with the same number of rows as blocks and the same number of columns as treatment arms. Cell entries are the number of units (or clusters) to be assigned to each treatment arm within each block. The rows should respect the ordering of the blocks as determined by sort(unique(block_var)). The columns should be in the order of condition_names, if specified.}

\item{block_prob}{Use for a two-arm design in which block_prob describes the probability of assignment to treatment within each block. Differs from prob in that the probability of assignment can vary across blocks.}

\item{block_prob_each}{Use for a multi-arm design in which the values of block_prob_each determine the probabilties of assignment to each treatment condition. block_prob_each must be a matrix with the same number of rows as blocks and the same number of columns as treatment arms. Cell entries are the probabilites of assignment to treatment within each block. The rows should respect the ordering of the blocks as determined by sort(unique(block_var)). Use only if the probabilities of assignment should vary by block, otherwise use prob_each. Each row of block_prob_each must sum to 1.}

\item{num_arms}{The number of treatment arms. If unspecified, num_arms will be determined from the other arguments. (optional)}

\item{condition_names}{A character vector giving the names of the treatment groups. If unspecified, the treatment groups will be named 0 (for control) and 1 (for treatment) in a two-arm trial and T1, T2, T3, in a multi-arm trial. An execption is a two-group design in which num_arms is set to 2, in which case the condition names are T1 and T2, as in a multi-arm trial with two arms. (optional)}

\item{simple}{logical, defaults to FALSE. If TRUE, simple random assignment is used. When simple = TRUE, please do not specify m, m_each, block_m, or block_m_each.}

\item{check_inputs}{logical. Defaults to TRUE.}
}
\value{
A list of class "declaration".  The list has five entries:
  $ra_function, a function that generates random assignments according to the declaration.
  $ra_type, a string indicating the type of random assignment used
  $probabilities_matrix, a matrix with N rows and num_arms columns, describing each unit's probabilities of assignment to conditions.
  $block_var, the blocking variable.
  $clust_var, the clustering variable.
}
\description{
Declare a random assignment procedure.
}
\examples{
# The declare_ra function is used in three ways:

# 1. To obtain some basic facts about a randomization:
declaration <- declare_ra(N=100, m_each=c(30, 30, 40))
declaration

# 2. To conduct a random assignment:

Z <- conduct_ra(declaration)
table(Z)

# 3. To obtain observed condition probabilities

probs <- obtain_condition_probabilities(declaration, Z)
table(probs, Z)

# Simple Random Assignment Declarations

declare_ra(N=100, simple = TRUE)
declare_ra(N=100, prob = .4, simple = TRUE)
declare_ra(N=100, prob_each=c(0.3, 0.3, 0.4),
           condition_names=c("control", "placebo", "treatment"), simple=TRUE)

# Complete Random Assignment Declarations

declare_ra(N=100)
declare_ra(N=100, m_each = c(30, 70),
           condition_names = c("control", "treatment"))
declare_ra(N=100, m_each=c(30, 30, 40))


# Block Random Assignment Declarations

block_var <- rep(c("A", "B","C"), times = c(50, 100, 200))

block_m_each <- rbind(c(10, 40),
                 c(30, 70),
                 c(50, 150))
declare_ra(block_var = block_var, block_m_each = block_m_each)


# Cluster Random Assignment Declarations

clust_var <- rep(letters, times = 1:26)
declare_ra(clust_var = clust_var)
declare_ra(clust_var = clust_var, m_each = c(7, 7, 12))

# Blocked and Clustered Random Assignment Declarations

clust_var <- rep(letters, times=1:26)
block_var <- rep(NA, length(clust_var))
block_var[clust_var \%in\% letters[1:5]] <- "block_1"
block_var[clust_var \%in\% letters[6:10]] <- "block_2"
block_var[clust_var \%in\% letters[11:15]] <- "block_3"
block_var[clust_var \%in\% letters[16:20]] <- "block_4"
block_var[clust_var \%in\% letters[21:26]] <- "block_5"

table(block_var, clust_var)

declare_ra(clust_var = clust_var, block_var = block_var)
declare_ra(clust_var = clust_var, block_var = block_var, prob_each = c(.2, .5, .3))

}
