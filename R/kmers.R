#' Build kmer database for classifying 16S rRNA and other gene sequences to
#' a genus when a kmer size is provided.
#'
#' @param sequences A vector of reference sequences for which we have
#'                  genus-level taxonomic information in the same order as the
#'                  value for genera.
#' @param genera    A vector of genus-level taxonomic information for reference
#'                  sequences in the same order as the value for sequences.
#'                  Ideally, taxonomic information will be provided back to the
#'                  domain level with each level separated by semicolons and no
#'                  spaces.
#' @param kmer_size The length of the nucleotide word to base our classification
#'                  on (default = 8)
#'
#' @return  A TBD object containing the genus level conditional probability of
#'          seeing each kmer in a given genus as well as the genus names
#' @export
build_kmer_database <- function(sequences, genera, kmer_size = 8) {

  genera_indices <- genera_str_to_index(genera)

  detected_kmers <- detect_kmers_across_sequences(sequences,
                                                  kmer_size = kmer_size)

  priors <- calc_word_specific_priors(detected_kmers, kmer_size)

  cond_prob <- calc_genus_conditional_prob(detected_kmers, genera_indices,
                                           priors)
  genera_names <- get_unique_genera(genera)

  return(list(conditional_prob = cond_prob,
              genera = genera_names))
}


#' @noRd
#' @importFrom stringi stri_length stri_sub
get_all_kmers <- function(x, kmer_size = 8){

  seq_length <- stringi::stri_length(x)
  n_kmers <- seq_length - kmer_size + 1
  seq_kmers <- stringi::stri_sub(x, 1:n_kmers, kmer_size:seq_length)

  return(seq_kmers)
}


#' @noRd
#' @importFrom stringi stri_trans_toupper stri_replace_all_charclass stri_trans_char
seq_to_base4 <- function(sequence) {

  stringi::stri_trans_toupper(sequence) |>
    stringi::stri_replace_all_charclass(str = _,
                                        pattern = "[^ACGT]",
                                        replacement = "N")  |>
    stringi::stri_trans_char(str = _, pattern = "ACGT", replacement = "0123")

}


#' @noRd
#' @importFrom stats na.omit
base4_to_index <- function(base4_str) {
  # I want output to be indexed to start at position 1 rather than 0 so we're
  # adding 1 to all base10 values
  stats::na.omit(strtoi(base4_str, base = 4) + 1) |> as.numeric()
}


#' @noRd
detect_kmers <- function(sequence, kmer_size = 8) {

  seq_to_base4(sequence) |>
    get_all_kmers(kmer_size) |>
    base4_to_index()

}


#' @noRd
detect_kmers_across_sequences <- function(sequences, kmer_size = 8) {

  n_sequences <- length(sequences)
  kmer_list <- vector(mode = "list", length = n_sequences)

  for(i in seq_along(1:n_sequences)){
    kmer_list[[i]] <- detect_kmers(sequences[[i]], kmer_size = kmer_size)
  }

  return(kmer_list)
}


#' @noRd
calc_word_specific_priors <- function(detect_list, kmer_size) {

  priors <- detect_list |> unlist() |> tabulate(bin = _, nbins = 4^kmer_size)

  (priors + 0.5) / (length(detect_list) + 1)

}


#' @noRd
#(m(wi) + Pi) / (M + 1)
calc_genus_conditional_prob <- function(detect_list,
                                        genera, #needs to be an integer not char
                                        word_specific_priors) {

  genus_counts <- tabulate(genera)
  n_genera <- length(genus_counts)
  n_sequences <- length(genera)
  n_kmers <- length(word_specific_priors)

  kmer_genus_count <- matrix(0,
                        nrow = n_kmers,
                        ncol = n_genera)

  for(i in 1:n_sequences) {
    kmer_genus_count[detect_list[[i]], genera[i]] <-
      kmer_genus_count[detect_list[[i]], genera[i]] + 1
  }

  #transpose = 10.0s
  #log(t(t(kmer_genus_count + word_specific_priors) / (genus_counts + 1)))

  #mat mult = forever
  #log((kmer_genus_count + word_specific_priors) %*% diag(1/(genus_counts + 1)))

  #sweep = 10.2s
  #log(sweep(kmer_genus_count + word_specific_priors, 2, genus_counts + 1, "/"))

  #rep = 6.2s
  log(
    (kmer_genus_count + word_specific_priors) /
      rep(genus_counts + 1, each = n_kmers)
    )

  #replace = 10.8
  #log((kmer_genus_count + word_specific_priors) / t(replace(t(kmer_genus_count), TRUE, genus_counts + 1)))

  #col = 8.9
  # log((kmer_genus_count + word_specific_priors) /(genus_counts + 1)[col(kmer_genus_count)])

  #rcpp = 10.3
  # calculate_log_probability(kmer_genus_count, word_specific_priors, genus_counts)
}


#' @noRd
genera_str_to_index <- function(string) {

  factor(string) |> as.numeric()

}


#' @noRd
get_unique_genera <- function(string) {

  factor(string) |> levels()
}



#' @noRd
bootstrap_kmers <- function(kmers, kmer_size = 8){

  n_kmers <- as.integer(length(kmers) / kmer_size)
  sample(kmers, n_kmers, replace = TRUE)

}


#' @noRd
#' @importFrom Rfast colsums
classify_bs <-function(unknown_kmers, db) {

  probabilities <- Rfast::colsums(db$conditional_prob[unknown_kmers,])
  which.max(probabilities)

}


#' @noRd
consensus_bs_class <- function(bs_class, db){

  taxonomy <- db[["genera"]][bs_class]
  taxonomy_split <- stringi::stri_split_fixed(taxonomy, pattern = ";")

  n_levels <- length(taxonomy_split[[1]])

  consensus_list <- lapply(1:n_levels,
         \(i) sapply(taxonomy_split,
                     \(p) paste(p[1:i], collapse = ";")) |>
           get_consensus()
  )

  list(taxonomy = stringi::stri_split_fixed(consensus_list[[n_levels]][["id"]],
                                            pattern = ";") |>
         unlist(),
       confidence = sapply(consensus_list, `[[`, "frac"))
}


#' @noRd
get_consensus <- function(taxonomy) {

  n_bs <- length(taxonomy)
  taxonomy_table <- table(taxonomy)
  max_index <- which.max(taxonomy_table)

  list(frac = taxonomy_table[[max_index]]/n_bs,
       id = names(max_index))
}


#' @noRd
filter_taxonomy <- function(classification, min_confidence = 0.80) {

  high_confidence <- which(classification$confidence >= min_confidence)

  filtered <- list()
  filtered[["taxonomy"]] <- classification[["taxonomy"]][high_confidence]
  filtered[["confidence"]] <- classification[["confidence"]][high_confidence]

  return(filtered)
}


#' @noRd
print_taxonomy <- function(consensus, n_levels = 6) {

  original_levels <- length(consensus$taxonomy)
  given_levels <- original_levels

  while(given_levels < n_levels) {

    consensus$taxonomy[given_levels+1] <- paste(consensus$taxonomy[original_levels],
                                                "unclassified", sep = "_")
    consensus$confidence[given_levels+1] <- consensus$confidence[original_levels]
    given_levels <- given_levels + 1
  }

  pretty_confidence <- paste0("(", 100*consensus$confidence, ")")

  paste(consensus$taxonomy, pretty_confidence, sep = "", collapse = ";")

}


#' Title
#'
#' @param unknown
#' @param database
#' @param kmer_size
#' @param num_bootstraps
#'
#' @return
#' @export
#'
#' @examples
classify_sequence <- function(unknown = unknown_sequence, database = db,
                              kmer_size = 8, num_bootstraps = 100){

  kmers <- detect_kmers(sequence = unknown, kmer_size)

  bs_class <- numeric(length = num_bootstraps)

  for(i in 1:num_bootstraps){
    bs_kmers <- bootstrap_kmers(kmers, kmer_size)
    bs_class[[i]] <- classify_bs(bs_kmers, database)
  }

  consensus_bs_class(bs_class, database)

}
