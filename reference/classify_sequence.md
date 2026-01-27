# Classify 16S rRNA gene sequence fragment

The `classify_sequence()` function implements the Wang et al. naive
Bayesian classification algorithm for 16S rRNA gene sequences.

## Usage

``` r
classify_sequence(
  unknown_sequence,
  database,
  kmer_size = 8,
  num_bootstraps = 100
)
```

## Arguments

- unknown_sequence:

  A character object representing a DNA sequence that needs to be
  classified

- database:

  A kmer database generated using
  [`build_kmer_database`](https://mothur.org/phylotypr/reference/build_kmer_database.md)

- kmer_size:

  An integer value (default of 8) indicating the size of kmers to use
  for classifying sequences. Higher values use more RAM with potentially
  more specificity Lower values use less RAM with potentially less
  specificity. Benchmarking has found that the default of 8 provides the
  best specificity with the lowest possible memory requirement and
  fastest execution time.

- num_bootstraps:

  An integer value (default of 100). The value of `num_bootstraps` is
  the number of randomizations to perform where `1/kmer_size` of all
  kmers are sampled (without replacement) from `unknown_sequence`.
  Higher values will provide greater precision on the confidence score.

## Value

A list object of two vectors. One vector (`taxonomy`) is the taxonomic
assignment for each level. The second vector (`confidence`) is the
percentage of `num_bootstraps` that the classifier gave the same
classification at that level

## References

Wang Q, Garrity GM, Tiedje JM, Cole JR. Naive Bayesian classifier for
rapid assignment of rRNA sequences into the new bacterial taxonomy. Appl
Environ Microbiol. 2007 Aug;73(16):5261-7.
doi:[10.1128/AEM.00062-07](https://pubmed.ncbi.nlm.nih.gov/17586664/)
PMID: 17586664; PMCID: PMC1950982.

## Examples

``` r
kmer_size <- 3
sequences <- c("ATGCGCTA", "ATGCGCTC", "ATGCGCTC")
genera <- c("A", "B", "B")

db <- build_kmer_database(sequences, genera, kmer_size)
unknown_sequence <- "ATGCGCTC"

classify_sequence(
  unknown_sequence = unknown_sequence,
  database = db,
  kmer_size = kmer_size
)
#> $taxonomy
#> [1] "B"
#> 
#> $confidence
#> [1] 100
#> 
```
