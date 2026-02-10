library(phylotypr)
library(tidyverse)
library(furrr)
library(bench)
library(microbenchmark)

set.seed(19760620)

plan(strategy = multisession, workers = 8)
options(future.globals.maxSize = 1e10)

db <- build_kmer_database(
  trainset9_pds$sequence,
  trainset9_pds$taxonomy
)

miseq <- read_fasta(phylotypr_example("miseq_sop.fasta.gz"))

m <- function() {
  miseq %>%
    mutate(taxonomy = map_chr(sequence,
      ~ classify_sequence(unknown = .x, database = db) %>%
        filter_taxonomy() %>%
        print_taxonomy(),
      .progress = TRUE
    ))
}

fm <- function() {
  miseq %>%
    mutate(taxonomy = future_map_chr(sequence,
      ~ classify_sequence(unknown = .x, database = db) %>%
        filter_taxonomy() %>%
        print_taxonomy(),
      .progress = TRUE,
      .options = furrr_options(seed = 19760620)
    ))
}

mark(
  iterations = 1,
  fm(), # 10.1 seconds w/ 4 workers; 10.3 seconds w/ 8 workers
  m(), # 20.1 seconds
  check = FALSE
)

microbenchmark(
  fm(), # 10.37 seconds w/ 4 workers; 10.5 seconds w/ 8 workers
  m(), # 18.90 seconds
  times = 1
)
