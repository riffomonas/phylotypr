# Filter taxonomy

The `filter_taxonomy()` function will filter a consensus taxonomy to
remove any taxonomic levels where the confidence score is below a
`min_confidence` level

## Usage

``` r
filter_taxonomy(consensus, min_confidence = 80)
```

## Arguments

- consensus:

  A list object that contains two slots each with an equal sized vector.
  The `taxonomy` vector contains the classification at each taxonomic
  level and the `confidence` vector contains the percentage of
  bootstraps that had the specified classification

- min_confidence:

  A double value between 0 and 100 (default = 80). The minimum
  percentage of bootstrap replicates that had the same classification.
  Any confidence score below this value will have the corresponding
  taxonomy removed

## Value

A list object containing two equally sized vectors that are filtered to
remove low confidence taxonomies. One vector, `taxonomy`, contains the
taxonomy at each taxonomic level and the other vector, `confidence`
contains the confidence score for that taxonomy. There will be no
taxonomies or confidence scores below `min_confidence`

## Examples

``` r
oscillospiraceae <- list(
  taxonomy = c(
    "Bacteria", "Bacillota", "Clostridia",
    "Eubacteriales", "Oscillospiraceae",
    "Flintibacter"
  ),
  confidence = c(100, 100, 99, 99, 98, 58)
)

filter_taxonomy(oscillospiraceae, min_confidence = 80)
#> $taxonomy
#> [1] "Bacteria"         "Bacillota"        "Clostridia"       "Eubacteriales"   
#> [5] "Oscillospiraceae"
#> 
#> $confidence
#> [1] 100 100  99  99  98
#> 
```
