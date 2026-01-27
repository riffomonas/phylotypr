# Get path to phylotypr example

phylotypr comes bundled with some example files in its `inst/extdata`
directory. This function make them easy to access.

## Usage

``` r
phylotypr_example(path = NULL)
```

## Arguments

- path:

  Name of file. If `NULL`, the example files will be listed.

## Value

A string indicating path to the file listed in `path`. If `NULL` is
given then the return value is a vector of file names in the `extdata/`
directory

## Examples

``` r
phylotypr_example()
#> [1] "miseq_sop.fasta.gz"
phylotypr_example("miseq_sop.fasta.gz")
#> [1] "/home/runner/work/_temp/Library/phylotypr/extdata/miseq_sop.fasta.gz"
```
