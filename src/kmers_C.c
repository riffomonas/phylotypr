#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>

// Equivalent to which.max(Rfast::rowsums(conditional_prob[, unknown_kmers])),
// but much faster and more memory efficient.
SEXP classify_bs_C(SEXP unknown_kmers, SEXP conditional_prob) {
  // Dimensions of the conditional_prob[, unknown_kmers] submatrix
  const int NROW = INTEGER(Rf_getAttrib(conditional_prob, R_DimSymbol))[0];
  const int NCOL = Rf_length(unknown_kmers);

  // Pointers to read values from the input. unknown_kmers must be an integer
  // vector, and conditional_prob must be a matrix of doubles, or this will
  // throw an error.
  int *restrict punknown_kmers = INTEGER(unknown_kmers);
  double *restrict pconditional_prob = REAL(conditional_prob);

  // Allocate a vector of zeros to store the row sums
  SEXP probs = PROTECT(Rf_allocVector(REALSXP, NROW));
  double *restrict pprobs = REAL(probs);
  memset(pprobs, 0.0, NROW * sizeof(double)); // set all values to 0

  // Offset to jump to the first element of a column in conditional_prob
  int offset = 0;

  // Submatrix row sums ----
  for (int j = 0; j < NCOL; ++j) {
    // Subtract 1 to convert from a 1-based to a 0-based column index
    offset = (punknown_kmers[j] - 1) * NROW;

    for (int i = 0; i < NROW; ++i) {
      pprobs[i] += pconditional_prob[offset + i];
    }
  }

  // which.max ----
  double max_prob = pprobs[0]; // maximum value
  int out = 0; // index of the maximum value

  for (int i = 1; i < NROW; ++i) {
    // which.max reports the index of the first maximum if there are ties, so
    // check if i-th probability is strictly greater
    if (pprobs[i] > max_prob) {
      max_prob = pprobs[i];
      out = i;
    }
  }

  ++out; // convert from 0-based index to 1-based index

  UNPROTECT(1);

  // Return integer index as an SEXP
  return Rf_ScalarInteger(out);
}

