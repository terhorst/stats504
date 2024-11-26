#!/usr/bin/env Rscript

# Main function
main <- function() {
  # Check for valid input
  args <- commandArgs(trailingOnly = TRUE)
  if (length(args) != 1) {
    cat("Usage: ./predict {1, 24, 72}\n")
    quit(save = "no", status = 1)
  }
  
  # Parse the argument
  hours <- as.numeric(args[1])
  if (is.na(hours) || !(hours %in% c(1, 24, 72))) {
    cat("Invalid input. Please provide an integer: 1, 24, or 72.\n")
    quit(save = "no", status = 1)
  }

  # Example predictions (replace with actual logic)
  long_term_avgs <- list(
    "06001" = 52.2286465177398,
    "08013" = 54.5585864848109,
    "12001" = 41.6614987080103,
    "18105" = 39.88860598345,
    "25017" = 39.9160073037127,
    "26161" = 48.1587104773714,
    "37063" = 42.6643401015228,
    "41039" = 58.6314432989691,
    "42027" = 44.933044017359,
    "55025" = 47.7532216494845
  )

  # Create predictions
  predictions <- data.frame(
    fips = names(long_term_avgs),
    pred = unlist(long_term_avgs)
  )

  # Print CSV output
  write.csv(predictions, row.names = FALSE, quote = FALSE)
}

# Run main function
main()
