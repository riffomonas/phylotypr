# Build kmer database

Build kmer database for classifying 16S rRNA and other gene sequences to
a genus when a kmer size is provided.

## Usage

``` r
build_kmer_database(sequences, genera, kmer_size = 8)
```

## Arguments

- sequences:

  A vector of reference sequences for which we have genus-level
  taxonomic information in the same order as the value for genera.

- genera:

  A character vector of genus-level taxonomic information for reference
  sequences in the same order as the value for sequences. Ideally,
  taxonomic information will be provided back to the domain level with
  each level separated by semicolons and no spaces.

- kmer_size:

  An integer indicating the length of the nucleotide word to base our
  classification on (default = 8)

## Value

A list object containing the genus level conditional probability
(`conditional_prob`) of seeing each kmer in a given genus as well as the
genus names (`genera`)

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

build_kmer_database(sequences, genera, kmer_size)
#> $conditional_prob
#>           [,1]      [,2]      [,3]      [,4]      [,5]      [,6]      [,7]
#> [1,] -2.772589 -2.772589 -2.772589 -2.772589 -2.772589 -2.772589 -2.772589
#> [2,] -3.178054 -3.178054 -3.178054 -3.178054 -3.178054 -3.178054 -3.178054
#>           [,8]      [,9]     [,10]     [,11]     [,12]     [,13]     [,14]
#> [1,] -2.772589 -2.772589 -2.772589 -2.772589 -2.772589 -2.772589 -2.772589
#> [2,] -3.178054 -3.178054 -3.178054 -3.178054 -3.178054 -3.178054 -3.178054
#>            [,15]     [,16]     [,17]     [,18]     [,19]     [,20]     [,21]
#> [1,] -0.06453852 -2.772589 -2.772589 -2.772589 -2.772589 -2.772589 -2.772589
#> [2,] -0.04255961 -3.178054 -3.178054 -3.178054 -3.178054 -3.178054 -3.178054
#>          [,22]     [,23]     [,24]     [,25]       [,26]     [,27]     [,28]
#> [1,] -2.772589 -2.772589 -2.772589 -2.772589 -0.06453852 -2.772589 -2.772589
#> [2,] -3.178054 -3.178054 -3.178054 -3.178054 -0.04255961 -3.178054 -3.178054
#>           [,29]      [,30]     [,31]     [,32]     [,33]     [,34]     [,35]
#> [1,] -0.3746934 -1.1631508 -2.772589 -2.772589 -2.772589 -2.772589 -2.772589
#> [2,] -2.0794415 -0.1335314 -3.178054 -3.178054 -3.178054 -3.178054 -3.178054
#>          [,36]     [,37]     [,38]       [,39]       [,40]     [,41]     [,42]
#> [1,] -2.772589 -2.772589 -2.772589 -0.06453852 -0.06453852 -2.772589 -2.772589
#> [2,] -3.178054 -3.178054 -3.178054 -0.04255961 -0.04255961 -3.178054 -3.178054
#>          [,43]     [,44]     [,45]     [,46]     [,47]     [,48]     [,49]
#> [1,] -2.772589 -2.772589 -2.772589 -2.772589 -2.772589 -2.772589 -2.772589
#> [2,] -3.178054 -3.178054 -3.178054 -3.178054 -3.178054 -3.178054 -3.178054
#>          [,50]     [,51]     [,52]     [,53]     [,54]     [,55]     [,56]
#> [1,] -2.772589 -2.772589 -2.772589 -2.772589 -2.772589 -2.772589 -2.772589
#> [2,] -3.178054 -3.178054 -3.178054 -3.178054 -3.178054 -3.178054 -3.178054
#>          [,57]       [,58]     [,59]     [,60]     [,61]     [,62]     [,63]
#> [1,] -2.772589 -0.06453852 -2.772589 -2.772589 -2.772589 -2.772589 -2.772589
#> [2,] -3.178054 -0.04255961 -3.178054 -3.178054 -3.178054 -3.178054 -3.178054
#>          [,64]
#> [1,] -2.772589
#> [2,] -3.178054
#> 
#> $genera
#> [1] "A" "B"
#> 
```
