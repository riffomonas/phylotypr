% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/print_taxonomy.R
\name{print_taxonomy}
\alias{print_taxonomy}
\title{Print taxonomy for an unknown sequence}
\usage{
print_taxonomy(consensus, n_levels = 6)
}
\arguments{
\item{consensus}{A list object that contains two slots each with an equal
sized vector. The \code{taxonomy} vector contains the
classification at each taxonomic level and the \code{confidence}
vector contains the percentage of bootstraps that had the
specified classification}

\item{n_levels}{An integer indicating the number of taxonomic levels to
expect. If the number of observed levels is less than this
value, then missing levels will have "_unclassified" to the
end of the last named classification}
}
\value{
A character string indicating the classification at each taxonomic
level with the corresponding confidence in parentheses. Each taxonomic
level is separated by a semi-colon
}
\description{
The \code{print_taxonomy()} will output the consensus taxonomy for an unknown
sequence with confidence scores for each taxonomic level and each taxonomic
level separated by semi-colons
}
\examples{
oscillospiraceae <- list(
  taxonomy = c(
    "Bacteria", "Bacillota", "Clostridia",
    "Eubacteriales", "Oscillospiraceae"
  ),
  confidence = c(100, 100, 99, 99, 98)
)

print_taxonomy(oscillospiraceae, n_levels = 6)
}
