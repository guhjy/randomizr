#' Obtain Permutation Matrix from a Random Assignment Declaration
#'
#' @param declaration A random assignment declaration, created by \code{\link{declare_ra}}.
#' @param maximum_permutations If the number of possible random assignments exceeds maximum_permutations, obtain_permutation_matrix will return a random sample of maximum_permutations permutations. Defaults to 10,000.
#'
#' @return a matrix of all possible (or a random sample of all possible) random assignments consistent with a declaration.
#' @importFrom utils combn
#' @importFrom partitions restrictedparts
#' @importFrom partitions restrictedparts
#' @export
#'
#' @examples
#'
#' # complete
#'
#' declaration <- declare_ra(N = 4)
#' perms <- obtain_permutation_matrix(declaration)
#' dim(perms)
#' obtain_num_permutations(declaration)
#'
#' # blocked
#'
#' block_var <- c("A", "A", "B", "B", "C", "C", "C")
#' declaration <- declare_ra(block_var = block_var)
#' perms <- obtain_permutation_matrix(declaration)
#' dim(perms)
#' obtain_num_permutations(declaration)
#'
#' # clustered
#'
#' clust_var <- c("A", "B", "A", "B", "C", "C", "C")
#' declaration <- declare_ra(clust_var = clust_var)
#' perms <- obtain_permutation_matrix(declaration)
#' dim(perms)
#' obtain_num_permutations(declaration)
#'
#' # large
#'
#' declaration <- declare_ra(20)
#' choose(20, 10)
#' perms <- obtain_permutation_matrix(declaration)
#' dim(perms)
#'
#'
obtain_permutation_matrix <-
  function(declaration, maximum_permutations = 10000) {
    num_permutations = obtain_num_permutations(declaration)
    if (num_permutations > maximum_permutations) {
      #warning(paste0("The number of possible permutations (", num_permutations,") exceeds maximum_permtations (", maximum_permutations, "), so obtain_permutation_matrix will return a random sample of ", maximum_permutations, " possible permutations. You can increase maximum_permtations if you wish."))
      return(replicate(maximum_permutations, declaration$ra_function()))
    }
    
    if (declaration$ra_type == "simple")  {
      N = nrow(declaration$probabilities_matrix)
      prob_each = declaration$probabilities_matrix[1, ]
      r_parts <- partitions::restrictedparts(N, length(prob_each))
      perms <- permutations(length(prob_each))
      
      r_parts_perms <-
        sapply(1:ncol(r_parts),
               function(i) {
                 apply(perms, 1, function(x)
                   r_parts[, i][x])
               }, simplify = FALSE)
      
      m_eaches <- unique(do.call(cbind, r_parts_perms), MARGIN = 2)
      
      perms_list <- sapply(1:ncol(m_eaches), function(j) {
        permutations_m_each(m_each = m_eaches[, j], declaration$cleaned_arguments$condition_names)
      })
        
      perms <- do.call(cbind, perms_list)
      
    }
    
    if (declaration$ra_type == "complete") {
      perms <-
        complete_ra_permutations(
          N = nrow(declaration$probabilities_matrix),
          prob_each = declaration$probabilities_matrix[1,],
          condition_names = declaration$cleaned_arguments$condition_names
        )
    }
    
    if (declaration$ra_type == "blocked") {
      block_spots <-
        unlist(split(1:length(declaration$block_var), declaration$block_var), FALSE, FALSE)
      
      block_prob_each_local <-
        by(
          declaration$probabilities_matrix,
          INDICES = declaration$block_var,
          FUN = function(x) {
            x[1,]
          }
        )
      block_prob_each_local <-
        lapply(block_prob_each_local, as.vector, mode = "numeric")
      
      ns_per_block_list <-
        lapply(split(declaration$block_var,
                     declaration$block_var),
               length)
      
      condition_names_list <- lapply(1:length(ns_per_block_list),
                                     function(x)
                                       declaration$cleaned_arguments$condition_names)
      
      perms_by_block <- mapply(FUN = complete_ra_permutations,
                               ns_per_block_list,
                               block_prob_each_local,
                               condition_names_list,
                               SIMPLIFY = FALSE)

      perms <-
        Reduce(expand_matrix, x = perms_by_block)
      
      perms <- perms[order(block_spots), ]
      
    }
    
    if (declaration$ra_type == "clustered") {
      prob_each_local <-
        declaration$probabilities_matrix[1,]
      
      n_per_clust <-
        tapply(declaration$clust_var, declaration$clust_var, length)
      n_clust <- length(n_per_clust)
      
      perms <-
        complete_ra_permutations(
          N = n_clust,
          prob_each = declaration$probabilities_matrix[1,],
          condition_names = declaration$cleaned_arguments$condition_names
        )
      
      # expand
      perms <- perms[rep(1:n_clust, n_per_clust),]
      # arrange
      perms <-
        perms[order(unlist(split(
          1:length(declaration$clust_var), declaration$clust_var
        ), FALSE, FALSE)), ]
      
    }
    
    if (declaration$ra_type == "blocked_and_clustered") {
      # Setup: obtain unique clusters
      n_per_clust <-
        tapply(declaration$clust_var, declaration$clust_var, length)
      n_clust <- length(n_per_clust)
      
      # get the block for each cluster
      clust_blocks <-
        tapply(declaration$block_var, declaration$clust_var, unique)
      
      block_prob_each_local <-
        by(
          declaration$probabilities_matrix,
          INDICES = declaration$block_var,
          FUN = function(x) {
            x[1,]
          }
        )
      block_prob_each_local <-
        lapply(block_prob_each_local, as.vector, mode = "numeric")
      
      ns_per_block_list <-
        lapply(split(clust_blocks,
                     clust_blocks),
               length)
      
      condition_names_list <- lapply(1:length(ns_per_block_list),
                                     function(x)
                                       declaration$cleaned_arguments$condition_names)
      
      perms_by_block <- mapply(FUN = complete_ra_permutations,
                               ns_per_block_list,
                               block_prob_each_local,
                               condition_names_list,
                               SIMPLIFY = FALSE)
      
      perms <-
        Reduce(expand_matrix, x = perms_by_block)
      
      # arrange by blocks
      block_spots <-
        unlist(split(1:length(clust_blocks), clust_blocks), FALSE, FALSE)
      
      perms <- perms[order(block_spots), ]
      
      # expand
      perms <- perms[rep(1:n_clust, n_per_clust),]
      
      # arrange
      perms <-
        perms[order(unlist(split(
          1:length(declaration$clust_var), declaration$clust_var
        ), FALSE, FALSE)), ]
      
    }
    
    return(perms)
    
  }


# Helper functions --------------------------------------------------------




# https://stackoverflow.com/a/20199902/4172083
permutations <- function(n) {
  if (n == 1) {
    return(matrix(1))
  } else {
    sp <- permutations(n - 1)
    p <- nrow(sp)
    A <- matrix(nrow = n * p, ncol = n)
    for (i in 1:n) {
      A[(i - 1) * p + 1:p, ] <- cbind(i, sp + (sp >= i))
    }
    return(A)
  }
}

complete_ra_permutations <-
  function(N, prob_each, condition_names) {
    m_each_floor <- floor(N * prob_each)
    N_floor <- sum(m_each_floor)
    N_remainder <- N - N_floor
    
    if (N_remainder == 0) {
      perms <-
        permutations_m_each(m_each = m_each_floor, condition_names = condition_names)
      
    } else {
      prob_each_fix_up <- ((prob_each * N) - m_each_floor) / N_remainder
      
      fix_ups <-
        expand.grid(replicate(N_remainder, condition_names, simplify = FALSE),
                    stringsAsFactors = FALSE)
      fix_ups_probs <-
        c(prob_each_fix_up %*% t(prob_each_fix_up))
      
      m_each_es <-
        t(apply(fix_ups, 1,  function(x) {
          sapply(condition_names, function(i)
            sum(x %in% i))
        })) + m_each_floor
      
      perms <-
        sapply(1:ncol(m_each_es), function(j)
          permutations_m_each(m_each_es[, j], condition_names), simplify = FALSE)
      
      perms <- do.call(cbind, perms)
    }
    return(perms)
  }

replace_with_cond <-
  function(vec, pos, cond) {
    vec[pos] <- cond
    return(vec)
  }

permutations_m_each <- function(m_each, condition_names) {
  N <- sum(m_each)
  # intialize list
  
  old_pos <- combn(N, m_each[1], simplify = FALSE)
  
  ra_list <- replicate(n = length(old_pos),
                       expr = rep(NA, N),
                       simplify = FALSE)
  
  ra_list <- mapply(replace_with_cond,
                    ra_list,
                    old_pos,
                    cond = condition_names[1],
                    SIMPLIFY = FALSE)
  
  
  if (length(m_each) > 2) {
    for (j in 2:(length(m_each) - 1)) {
      local_positions <-
        combn(N - sum(m_each[1:(j - 1)]), m_each[j], simplify = FALSE)
      
      ra_list <-
        lapply(
          ra_list,
          FUN = replicate,
          n = length(local_positions),
          simplify = FALSE
        )
      ra_list <- unlist(ra_list, recursive = FALSE)
      
      new_pos <-
        sapply(1:length(local_positions),
               function(i) {
                 lapply(
                   X = old_pos,
                   FUN = function(x, y, N) {
                     (1:N)[-x][y]
                   },
                   y = local_positions[[i]],
                   N = N
                 )
               },
               simplify = FALSE)
      
      new_pos <- unlist(new_pos, recursive = FALSE)
      
      ra_list <- mapply(replace_with_cond,
                        ra_list,
                        new_pos,
                        cond = condition_names[j],
                        SIMPLIFY = FALSE)
      
      old_pos <- new_pos
      
    }
  }
  
  ra_list <-
    lapply(ra_list, function(x) {
      x[is.na(x)] <- condition_names[length(condition_names)]
      return(x)
    })
  
  return(do.call(cbind, ra_list))
}


expand_matrix <-
  function(mat_1, mat_2) {
    mat_list <-
      sapply(
        1:ncol(mat_2),
        FUN =
          function(j) {
            apply(
              mat_1,
              2,
              FUN = function(i)
                c(i, mat_2[, j])
            )
          },
        simplify = FALSE
      )
    
    return(do.call(cbind, mat_list))
    
  }
