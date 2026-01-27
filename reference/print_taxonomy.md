# Print taxonomy for an unknown sequence

The `print_taxonomy()` will output the consensus taxonomy for an unknown
sequence with confidence scores for each taxonomic level and each
taxonomic level separated by semi-colons

## Usage

``` r
print_taxonomy(consensus, n_levels = 6)
```

## Arguments

- consensus:

  A list object that contains two slots each with an equal sized vector.
  The `taxonomy` vector contains the classification at each taxonomic
  level and the `confidence` vector contains the percentage of
  bootstraps that had the specified classification

- n_levels:

  An integer indicating the number of taxonomic levels to expect. If the
  number of observed levels is less than this value, then missing levels
  will have "\_unclassified" to the end of the last named classification

## Value

A character string indicating the classification at each taxonomic level
with the corresponding confidence in parentheses. Each taxonomic level
is separated by a semi-colon

## Examples

``` r
oscillospiraceae <- list(
  taxonomy = c(
    "Bacteria", "Bacillota", "Clostridia",
    "Eubacteriales", "Oscillospiraceae"
  ),
  confidence = c(100, 100, 99, 99, 98)
)

print_taxonomy(oscillospiraceae, n_levels = 6)
#> [1] "Bacteria(100);Bacillota(100);Clostridia(99);Eubacteriales(99);Oscillospiraceae(98);Oscillospiraceae_unclassified(98)"
```
