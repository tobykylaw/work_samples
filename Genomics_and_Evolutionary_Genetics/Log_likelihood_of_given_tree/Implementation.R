#########################################################
#######        COMPUTATIONAL BIOLOGY         ############
#######             HOMEWORK 4               ############
#########################################################
#                                                       #
# Compute the log likelihood of an alignment on a given #
# tree using the Felsenstein's tree-pruning algorithm   #
#########################################################
#########################################################

#########################################################
######    Code below this should not be changed   #######
######    or deleted.                             #######
#########################################################

library(ape)
library(Matrix)

nucleotides = c("T", "C", "A", "G")

get_number_from_nucleotide = function(nuc) {
    # Transform a nucleotide letter into the appropriate number
    return(which(nucleotides == nuc))
}

transform_to_numbers = function(sequence) {
    # Transform a sequence of nucleotide characters into the appropriate number sequence
    num_sequence = simplify2array(lapply(strsplit(sequence, split=c())[[1]], get_number_from_nucleotide))
    return(num_sequence)
}

get_sequence_at_tip_node = function(node, tree, sequences) {
    # Get the sequence at the appropriate tip, represented by a numeric vector
    if (node > length(tree$tip.label)) {
        return(NULL)
    }
    tip_name = tree$tip.label[node]
    sequence = sequences[[tip_name]]
    return(transform_to_numbers(sequence))
}

get_node_children = function(node, tree) {
    # Return the two child nodes of the given node.
    # In a bifurcating tree, a node will have either two child nodes, if it is an internal node,
    # or zero child nodes if it is a tip node.
    # For an internal node, return the two child node numbers and the branch lengths leading to them,
    # for a tip node return NULL.
    #   node: the node for which child nodes should be returned
    #   tree: the tree encoded in an object of class phylo.

    if (node <= length(tree$tip.label)) {
        return(NULL)
    }

    children = which(tree$edge[,1] == node)
    child1 = tree$edge[children[1],2]
    branch_length1 = tree$edge.length[children[1]]
    child2 = tree$edge[children[2],2]
    branch_length2 = tree$edge.length[children[2]]

    # Return the child nodes and the branch lengths leading to them.
    #   child1: first child of the given node
    #   branch_length1: the length of the branch leading to child1
    #   child2: second child of the given node
    #   branch_length2: the length of the branch leading to child2
    return(list(child1 = child1, branch_length1 = branch_length1,
                child2 = child2, branch_length2 = branch_length2))
}

#########################################################
######    Code above this should not be changed   #######
######    or deleted.                             #######
#########################################################

create_TN93_Q_matrix = function(pi, alpha1, alpha2, beta) {
    # Create the TN93 transition rate matrix Q as specified in the assignment.
    # The nucleotide order should be (T, C, A, G).
    #   pi: the stationary frequencies of nucleotides
    #   alpha1: rate coefficient for the C <-> T transition
    #   alpha2: rate coefficient for the A <-> G transition
    #   beta: rate coefficient for transversions

    # ???
    # Calculate the substitution rates for when the starting nucleotide is T, C, A, G, organize them into rows, and initialize
    # the value where the nucleotide remains the same (the diagonal of the matrix)) to 0.
    row_t <- c(0, alpha1*pi[2], beta*pi[3], beta*pi[4])
    row_c <- c(alpha1*pi[1], 0, beta*pi[3], beta*pi[4])
    row_a <- c(beta*pi[1], beta*pi[2], 0, alpha2*pi[4])
    row_g <- c(beta*pi[1], beta*pi[2], alpha2*pi[3], 0)
  
    #bind the rows together to give the substitution rate matrix Q
    Q <- rbind(row_t, row_c, row_a, row_g)
  
    #extract of sum of rates in each row, take its negative value and append it to the diagonal values of Q. Now the sum of 
    #each row adds up to 0.
    sum_row <- rowSums(Q)
    diag(Q) <- sum_row * -1

    # Return the transition rate matrix
    # Q: 4 by 4 matrix of rates
    return(Q)
}

calculate_likelihood_from_subtree_likelihoods = function(N, Q,
                                                         subtree1_likelihood, subtree1_branch_length,
                                                         subtree2_likelihood, subtree2_branch_length) {
    # Calculate the likelihood of each nucleotide at each site on an internal node, from the two subtree likelihoods.
    #   N: number of sites in the alignment
    #   Q: the substitution rate matrix
    #   subtree1_likelihood: an N by 4 matrix containing the per site per nucleotide likelihoods
    #                        at the first child node
    #   subtree1_branch_length: the length of the branch leading to the first child node
    #   subtree2_likelihood: an N by 4 matrix containing the per site per nucleotide likelihoods
    #                        at the second child node
    #   subtree2_branch_length: the length of the branch leading to the second child node

    # ???
    # Initialize the likelihood_per_site matrix
    likelihood_per_site <- matrix(0, nrow = N, ncol = 4)
    
    for (i in 1:N) {
      for (x in 1:4) {
        L1 <- 0
        L2 <- 0
        for (y in 1:4) {
          P1 <- expm(Q*subtree1_branch_length)
          P2 <- expm(Q*subtree2_branch_length)
          L1 <- L1 + P1[x,y]*subtree1_likelihood[i,y]
          L2 <- L2 + P2[x,y]*subtree2_likelihood[i,y]
        }
        likelihood_sitei_nucx <- L1*L2
        likelihood_per_site[i,x] <- likelihood_sitei_nucx
      }
    }
    
  

    # Return the per site nucleotide likelihoods on the internal node.
    #   likelihood_per_site: an N by 4 matrix representing the nucleotide likelihoods per site
    return(likelihood_per_site)
}

get_likelihood_from_sequence = function(N, sequence) {
    # Get the matrix of likelihoods of each nucleotide at each site at a tip given the sequence at this tip.
    # The matrix should be of size N x 4, where rows represent the sites in the alignment and
    # the columns represent a nucleotide in the order (T, C, A, G).
    # For each site, the likelihood should be 1 in the column representing
    # the nucleotide at this site and 0 in all other columns.
    #   N: number of sites in the alignment
    #   sequence: the sequence at the tip, encoded as a vector of nucleotide numeric values.

    # ???
    likelihood_per_site <- matrix(0, nrow = N, ncol = 4)
    for (i in 1:N) {likelihood_per_site[i,sequence[i]] = 1}
    
    # Return the per site nucleotide likelihoods at the tip.
    #   likelihood_per_site: an N by 4 matrix representing the nucleotide likelihoods per site
    return(likelihood_per_site)
}

get_subtree_likelihood = function(node, tree, sequences, Q) {
    # Return the matrix of likelihoods per site per nucleotide for the subtree below the given node.
    # The matrix should be of size N x 4, where rows represent the sites in the alignment and
    # the columns represent a nucleotide in the order (T, C, A, G).
    # If the node is a tip, the likelihood per site should be a vector with a 1 in the column representing
    # the nucleotide at this site and 0 in all other columns.
    # Use the get_sequence_at_tip_node function to get the numeric representation of the sequence at the
    # given tip.
    # If the node is an internal node, the likelihood for each nucleotide should be computed
    # from the likelihoods of each of the child subtrees.
    #   node: the node for which likelihoods should be computed
    #   tree: the tree encoded in an object of class phylo
    #   sequences: a list of aligned sequences (as character strings) at the tips of the tree
    #   Q: the substitution rate matrix

    N = nchar(sequences[[1]])

    if (node <= length(tree$tip.label)) {
        # node is a tip: compute the likelihood for each site and each nucleotide on this node

        # ???
        # first get the numeric representation of the node sequence, then get the likelihood_per_site matrix
        #using get_likelihood_from sequence function
        node_sequence_numeric <- get_sequence_at_tip_node(node, tree, sequences)
        likelihood_per_site <- get_likelihood_from_sequence(N, sequence = node_sequence_numeric)
      
    } else {
        # node is an internal node: compute the likelihood for each site and each nucleotide on this node

        # ???
        # Find the child nodes of the current node, using the get_node_children function
        # Then find the subtree likelihoods of the child nodes and the branch lengths between the parent(current node) its children
        child_nodes <- get_node_children(node, tree)
        child1_likelihood <- get_subtree_likelihood(node = child_nodes[["child1"]], tree, sequences, Q)
        child1_branch <- child_nodes[["branch_length1"]]
        child2_likelihood <- get_subtree_likelihood(node = child_nodes[["child2"]], tree, sequences, Q)
        child2_branch <- child_nodes[["branch_length2"]]
        
        # Calculate the likelihood of the current internal node
        likelihood_per_site <- calculate_likelihood_from_subtree_likelihoods(N, Q, subtree1_likelihood = child1_likelihood, subtree1_branch_length = child1_branch,
                                                      subtree2_likelihood = child2_likelihood, subtree2_branch_length = child2_branch)
        
    }

    # Return the per site nucleotide likelihoods at this node.
    #   likelihood_per_site: an N by 4 matrix representing the nucleotide likelihoods per site
    return(likelihood_per_site)
}

Felstensteins_pruning_loglikelihood = function(pi, alpha1, alpha2, beta, newick_tree, sequences) {
    # Compute the log likelihood of a sequence alignment on the given tree under the TN93 model
    # using Felsenstein's pruning algorithm.
    #   pi: the stationary frequencies of nucleotides
    #   alpha1: rate coefficient for the C <-> T transition
    #   alpha2: rate coefficient for the A <-> G transition
    #   beta: rate coefficient for transversions
    #   newick_tree: the tree in newick text format
    #   sequences: a list of aligned sequences (as character strings) at the tips of the tree
  
    # Transfrom the tree from text format to an object of the phylo class which represents the tree in R
    tree = read.tree(text = newick_tree)
    # Reorder the tree for easier traversing
    tree = reorder(tree, order = "cladewise");
    
    # Number of sites in the alignment
    N = nchar(sequences[[1]])

    # Initialize the Q matrix
    # ???
    Q <- create_TN93_Q_matrix(pi, alpha1, alpha2, beta)
    
    # Compute the likelihoods per site of the tree starting from the root
    root = length(tree$tip.label) + 1
    likelihood_per_site = get_subtree_likelihood(root, tree, sequences, Q)
    
    # Sum up the log likelihoods of each site
    # ???
    loglikelihood <- 0
    for (i in 1:N) {
      L <- 0
      for (x in 1:4) { # Finding the likelihood for each site in the sequence, which is the sum of the likelihood of TACG
        L <- L + likelihood_per_site[i,x]*pi[x]
      }
      loglikelihood <- loglikelihood + log(L) # Sum the likelihood over all sites N to get the likelihood of the root/whole tree given the alignment
    }

    # Return the final log likelihood of the alignment on the given tree, a single number computed of the 
    # per site per nucleotide likelihoods at the root of the tree.
    #   loglikelihood: the full log likelihood of the alignment on the tree
    return(loglikelihood)
}

test_tree_loglikelihood = function() {
    beta = 0.00135
    alpha1 = 0.5970915
    alpha2 = 0.2940435
    pi = c(0.22, 0.26, 0.33, 0.19)
    newick_tree = "(unicorn:15,(orangutan:13,(gorilla:10.25,(human:5.5,chimp:5.5):4.75):2.75):2);"
    sequences = list(orangutan = "ACCCCTCCCCTCATGTGTAC",
                     chimp = "ACCCCTCCCCTCATGTGTAC",
                     human = "ACCCCTCCCCTCATGTGTAC",
                     gorilla = "ACCCCTCCCCTCATGTGTAC",
                     unicorn = "TGCCCTCCCCTCATGTGTAC")
    expected_result = -89.4346738736

    result = Felstensteins_pruning_loglikelihood(pi, alpha1, alpha2, beta, newick_tree, sequences)
    print(sprintf("Log likelihood value: %.*f" , 10, result))

    comparison = all.equal(result, expected_result)
    if (isTRUE(comparison)) {
        print("The result matched the expected value.")
    } else {
        print(comparison)
    }
}

test_tree_loglikelihood()
