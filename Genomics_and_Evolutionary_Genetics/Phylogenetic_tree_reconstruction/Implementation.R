#########################################################
#######        COMPUTATIONAL BIOLOGY         ############
#######             HOMEWORK 3               ############
#########################################################
#                                                       #
# Reconstruct the phylogenetic tree of given sequences  #
# using UPGMA with hamming, JC69, K80 distances.        #
#                                                       #
#########################################################
#########################################################

#########################################################
######    Code below this should not be changed   #######
#########################################################

library(ape)

transform_to_phylo = function(sequences, named_edges, edge_lengths, node_description) {
    # Produce a tree of the phylo class from the matrix of edges, vector of lengths and
    # the dataframe  containing node descriptions.
    #    sequences: a list of the original sequences;
    #    named_edges: an Mx2 matrix of pairs of nodes connected by an edge,
    #                 where the M rows are the different edges and the 2 columns
    #                 are the parent node and the child node of an edge.
    #    edge_lengths: a vector of length M of the corresponding edge lengths.
    #    node_description: a data frame of the node descriptions as defined in
    #                      initialize_node_description and extended by the upgma code.
    
    edges = named_edges
    for (name in rownames(node_description)) {
        index = which(rownames(node_description) == name)
        edges[which(edges == name)] = as.numeric(index)
    }
    edges = matrix(as.numeric(edges), ncol = 2)
    
    edges[which(edges > length(sequences))] = - edges[which(edges > length(sequences))]
    root = setdiff(edges[,1], edges[,2])
    edges[which(edges==root)] = length(sequences) + 1
    
    k = length(sequences) + 2
    for(x in unique(edges[which(edges < 0)])) {
        edges[which(edges==x)] = k
        k = k + 1
    }
    
    tree = list()
    class(tree) = "phylo"
    tree$edge = edges
    tree$edge.length = edge_lengths
    tree$Nnode = as.integer(length(sequences) - 1)
    tree$tip.label = names(sequences)
    
    # Return the tree in the form of the phylo class from ape
    return(tree)
}

plot_tree = function(tree) {
    # Plot the phylogenetic tree with node labels and edge lengths.
    #    tree: an object of class phylo from the ape package

    plot(tree)
    edgelabels(format(tree$edge.length, digits = 2))
}

initialize_node_description = function(sequences) {
    # Initialize the structure that will hold node descriptions.
    # The created structure is a data frame where the rows are node names, and the columns are
    # node_height -- distance from the node to any tip in the ultrametric tree, and
    # node_size -- number of tips that this node is ancestral to.
    #    sequences: a list of the original sequences;

    N = length(sequences)
    node_names = names(sequences)
    node_sizes = rep(1, times = N)
    node_heights = rep(0, times = N)
    node_description = data.frame(node_sizes, node_heights)
    rownames(node_description) = node_names

    # Return a data frame that contains information on currently existing tip nodes.
    # node_description: a dataframe containing information on the currently existing nodes.
    #                   The row names are the names of the currently existing tips, i.e.
    #                   are the same as the names in the sequence list, node_height is
    #                   0 and node_size is 1 as the all the currently existing nodes are tips.
    return(node_description)
}

add_new_node = function(node_description, merging_nodes) {
    # Add new merged node to the node description data frame.
    # The new node is a combination of the nodes supplied in the merging_nodes,
    # e.g. if one needs to merge nodes "bird" and "fish", the new node in the
    # dataframe will be called "bird.fish".
    #    node_description: the dataframe created by initialize_node_description, containing
    #                      current node sizes and node heights
    #    merging_nodes: a vector of two names of the nodes being merged

    new_node_name = paste(merging_nodes, collapse = ".")
    new_node_row = data.frame(node_sizes = 0, node_heights = 0)
    rownames(new_node_row) = new_node_name
    new_node_description = rbind(node_description, new_node_row)
    
    # Return the node_description dataframe with a row for the new node added, and
    # the new node name.
    #    node_description: the dataframe where the rows are labelled by current nodes and columns
    #                      contain the node heights and sizes.
    #    new_node_name: the name of the newly added node, created from names in merging_nodes.
    return(list(node_description = new_node_description, new_node_name = new_node_name))
}

#########################################################
######    Code above this should not be changed   #######
#########################################################

get_hamming_distance = function(sequence1, sequence2) {
    # Compute the Hamming distance between two sequences.
    #    sequence1: first sequence 
    #    sequence2: second sequence

    # ???
    distance <- 0
    for (i in 1:nchar(sequence1)) {
      if (substr(sequence1,i,i) != substr(sequence2,i,i)) {
        distance <- distance + 1
      }
    }
    # Return the numerical value of the distance
    return(distance)
}

get_JC69_distance = function(sequence1, sequence2) {
    # Compute the JC69 distance between two sequences.
    #    sequence1: first sequence
    #    sequence2: second sequence

    # ???
    p <- get_hamming_distance(sequence1, sequence2)/(nchar(sequence1))
    distance <- (-3/4)*log(1 - ((4/3)*p))

    # Return the numerical value of the distance
    return(distance)
}

get_K80_distance = function(sequence1, sequence2) {
    # Compute the K80 distance between two sequences.
    #    sequence1: first sequence
    #    sequence2: second sequence

    # ???
    S <- 0
    V <- 0
    for (i in 1:nchar(sequence1)) {
      if (substr(sequence1,i,i) != substr(sequence2,i,i)) {
        if (substr(sequence1,i,i) == "C" || substr(sequence1,i,i) == "T") {
          if (substr(sequence2,i,i) == "C" || substr(sequence2,i,i) == "T") {
            S <- S+1
          } else if (substr(sequence2,i,i) == "A" || substr(sequence2,i,i) == "G") {
            V <- V+1
          }
        } else if (substr(sequence1,i,i) == "A" || substr(sequence1,i,i) == "G") {
          if (substr(sequence2,i,i) == "A" || substr(sequence2,i,i) == "G") {
            S <- S+1
          } else if (substr(sequence2,i,i) == "C" || substr(sequence2,i,i) == "T") {
            V <- V+1
          }
        }
      }
    }
        
    S <- S/(nchar(sequence1))
    V <- V/(nchar(sequence1))
    distance <- ((-1/2)*log(1-(2*S)-V))-((1/4)*log(1-(2*V)))

    # Return the numerical value of the distance
    return(distance)
}

compute_initial_distance_matrix = function(sequences, distance_measure) {
    # Compute the initial distance matrix using one of the distance measures.
    # The matrix is of dimension NxN, where N is the number of sequences.
    # The matrix columns and rows should be labelled with tip names, each row and column
    # corresponding to the appropriate sequence.
    # The matrix can be filled completely (i.e symmetric matrix) or only the upper half
    # (as shown in the lecture).
    # The diagonal elements of the matrix should be Inf.
    #    sequences: the sequence alignment in the form of a list of species names and 
    #               the associated genetic sequences
    #    distance_measure: a string indicating whether the 'hamming', 'JC69' or 'K80' 
    #                      distance measure should be used
  
    N <- length(sequences)
    distance_matrix <- matrix(nrow = N, ncol = N)
    diag(distance_matrix) <- Inf
    rownames(distance_matrix) <- names(sequences)
    colnames(distance_matrix) <- names(sequences)

    # ???
    # Check which distance metric is required and calculate the corresponding distance matrix
    for (i in 1:N) {
      for (j in 1:N) {
        if (j != i) {
          sequence1 <- sequences[[i]]
          sequence2 <- sequences[[j]]
          if (distance_measure == "hamming") {
            distance_matrix[i,j] <- get_hamming_distance(sequence1, sequence2)
          } else if (distance_measure == "JC69") {
            distance_matrix[i,j] <- get_JC69_distance(sequence1, sequence2)
          } else if (distance_measure == "K80"){
            distance_matrix[i,j] <- get_K80_distance(sequence1, sequence2)
          }
        }
      }
    }

    # Return the NxN matrix of inter-sequence distances with Inf on the diagonal
    return(distance_matrix)
}

get_merge_node_distance = function(node_description, distance_matrix, merging_nodes, existing_node) {
    # Compute the new distance between the newly created merge node and an existing old node in the tree
    #    node_description: a dataframe containing information on the currently existing nodes
    #    distance_matrix: the matrix of current distances between nodes
    #    merging_nodes: a vector of two node names that are being merged in this step
    #    existing_node: one of the previously existing nodes, not included in the new node
  
    # ???
    node_size1 <- node_description[merging_nodes[1], "node_sizes"]
    node_size2 <- node_description[merging_nodes[2], "node_sizes"]
    distance1 <- node_size1 * distance_matrix[merging_nodes[1], existing_node]
    distance2 <- node_size2 * distance_matrix[merging_nodes[2], existing_node]
    new_distance <- (distance1 + distance2)/(node_size1 + node_size2)
  
    # Returns the distance between the newly created merge node and the existing node
    return(new_distance)
}

update_distance_matrix = function(node_description, distance_matrix, merging_nodes, new_node_name) {
    # Update the distance matrix given that two nodes are being merged.
    #    node_description: a dataframe containing information on the currently existing nodes
    #    distance_matrix: the current distance matrix that needs to be updated
    #    merging_nodes: a vector of two node names that need to be merged in this step
    #    new_node_name: the name with which the merged node should be labelled
    # The resulting matrix should be one column and one row smaller, i.e. if the given distance matrix
    # was MxM, then the updated matrix will be M-1xM-1, where the 2 rows and cols represent the separate
    # nodes undergoing the merge are taken out and a new row and col added that represents the new node.

    # ???
    # Update distance matrix: 
    # 1. Delete the nodes that are being clustered together.
    deleted_nodes <- rownames(distance_matrix) %in% merging_nodes == T
    updated_distance_matrix <- distance_matrix
    updated_distance_matrix <- updated_distance_matrix[!deleted_nodes,!deleted_nodes]
    
    # 2. Generates a new row and column for the clustered node.
    updated_distance_matrix <- rbind(updated_distance_matrix, 0)
    updated_distance_matrix <- cbind(updated_distance_matrix, 0)
    colnames(updated_distance_matrix)[ncol(updated_distance_matrix)] <- new_node_name
    rownames(updated_distance_matrix)[nrow(updated_distance_matrix)] <- new_node_name
    diag(updated_distance_matrix) <- Inf
    
    # 3. Then the new distances between the merged and exisiting nodes are calculated.
    for (j in 1:length(colnames(updated_distance_matrix))) {
      if (updated_distance_matrix[new_node_name,j] != Inf) {
        updated_distance_matrix[new_node_name, j] <- get_merge_node_distance(node_description, distance_matrix, merging_nodes, existing_node = colnames(updated_distance_matrix)[j])
      }
    }
    
    for (i in 1:length(rownames(updated_distance_matrix))) {
      if (updated_distance_matrix[i, new_node_name] != Inf) {
        updated_distance_matrix[i, new_node_name] <- get_merge_node_distance(node_description, distance_matrix, merging_nodes, existing_node = rownames(updated_distance_matrix)[i])
      }
    }

    # Returns the updated matrix of cluster distances
    return(updated_distance_matrix)
}

upgma_one_step = function(node_description, distance_matrix, edges, edge_lengths) {
    # Performs one step of the upgma algorithm, i.e. the nodes with the smallest distance are merged, 
    # the node height of the new node is calculated and the distance matrix is newly calculated.
    # Values that are expected to be returned are listed below.
    #    node_description: a dataframe containing information on the currently existing nodes
    #    distance_matrix: the current distance matrix that needs to be updated (OxO)
    #    edges: an Mx2 matrix of pairs of nodes connected by an edge, where the M rows are the different
    #           edges and the 2 columns are the parent node and the child node of an edge.
    #    edge_lengths: a vector of length M of the corresponding edge lengths.
  
    # ???
    # Find the nodes with the minimum distance in the distance matrix (min_D), record its indices (min_D_index)
    min_D_index <- which(distance_matrix == min(distance_matrix, na.rm = TRUE), arr.ind = TRUE)[1,]
    min_D <- distance_matrix[min_D_index["row"], min_D_index["col"]]
    
    # Create the new node name of the merged nodes, in the vector merging_nodes
    row_name_vector <- rownames(distance_matrix)
    col_name_vector <- colnames(distance_matrix)
    merging_nodes <- c(row_name_vector[min_D_index["row"]], col_name_vector[min_D_index["col"]])
    
    # Create a new entry for the merged node in node_description: 
    # 1. Finding the new node_size: a sum of the node sizes of the nodes being merged
    adding_new_node <- add_new_node(node_description, merging_nodes)
    new_node_name <- adding_new_node$new_node_name
    node_description <- adding_new_node$node_description
    node_description[new_node_name, "node_sizes"] <- node_description[merging_nodes[1], "node_sizes"] + node_description[merging_nodes[2], "node_sizes"]
    
    # 2. Finding the new node height/distance_to_tip, which is min_D/2
    new_node_height <- min_D/2
    node_description[new_node_name, "node_heights"] <- new_node_height
    
    # Update the edge description matrix
    edges <- rbind(edges, c(new_node_name, merging_nodes[1]), c(new_node_name, merging_nodes[2]))
    
    # Find the edge length, then update the edge length vector
    edge_length1 <- new_node_height - node_description[merging_nodes[1], "node_heights"]
    edge_length2 <- new_node_height - node_description[merging_nodes[2], "node_heights"]
    edge_lengths <- append(edge_lengths, c(edge_length1,edge_length2))
    
    # Update the current distance matrix using the update_distance_matrix function
    distance_matrix <- update_distance_matrix(node_description, distance_matrix, merging_nodes, new_node_name)
    
    
    # Return the updated distance matrix, edge description matrix, edge length vector and 
    # node_description data frame
    #    node_description: data frame containing sizes and heights of all nodes 
    #        (to be updated using add_new_node())
    #    distance_matrix: the updated matrix of distances between nodes (O-1xO-1)
    #    edges: an Mx2 matrix of pairs of nodes connected by an edge, where the M rows are
    #    the different edges and the 2 columns are the parent node and the child node of an edge.
    #    edge_lengths: a vector of length M of the corresponding edge lengths.
    return(list(node_description = node_description, distance_matrix = distance_matrix,
                edges = edges, edge_lengths = edge_lengths))
}

build_upgma_tree = function(sequences, distance_measure) {
    # Build the tree from given sequences using the UPGMA algorithm.
    #    sequences: the sequences in the format of a list of species names and the associated genetic 
    #               sequences
    #    distance_measure: a string indicating whether the 'hamming', 'JC69' or 'K80' distance measure
    #                      should be used
    N <- length(sequences)
    # the node_description dataframe is initialized here
    node_description <- initialize_node_description(sequences)
    edges <- matrix(nrow = 0, ncol = 2)
    edge_lengths <- vector(mode = "numeric", length = 0)
  
    # ???
    distance_matrix <- compute_initial_distance_matrix(sequences, distance_measure)
    
    while (dim(distance_matrix)[1] != 1 && dim(distance_matrix)[2] != 1 ) {
      upgma_tree <- upgma_one_step(node_description, distance_matrix, edges, edge_lengths)
    }
    
    edges <- upgma_tree$edges
    edge_lengths<-upgma_tree$edge_lengths
    node_description <- upgma_tree$node_description
  
    # Return the UPGMA tree of sequences
    tree <- transform_to_phylo(sequences, edges, edge_lengths, node_description)
    return(tree)
}

test_tree_building = function() {
    sequences <- list(orangutan = "TCACACCTAAGTTATATCTATATATAATCCGGGCCGGG",
                     chimp = "ACAGACTTAAAATATACATATATATAATCCGGGCCGGG",
                     human = "AAAGACTTAAAATATATATATATATAATCCGGGCCGGG",
                     gorilla = "ACACACCCAAAATATATATATATATAATCCGGGCCGGG",
                     unicorn = "ACACACCCAAAATATATACGCGTATAATCCGGGCCGAA")
    distance_measure <- 'hamming'
    distance_measure <- 'JC69'
    distance_measure <- 'K80'

    tree <- build_upgma_tree(sequences, distance_measure)
    plot_tree(tree)
}

#test_tree_building()