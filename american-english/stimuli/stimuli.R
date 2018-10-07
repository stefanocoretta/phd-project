library(stringr)

words <- c("pop", "pob", "popper", "pobber", "caulk", "cog", "cocker", "cogger")
stimuli <- paste("I said a", words, "again")

set.seed(8788)

for (participant in 1:20) {
  sink(paste0("./american-english/stimuli/e", str_pad(participant, 2, pad = "0"), ".txt"))

  cat("calibration\n")
  cat("swallow water")

  for (block in 1:10) {
    sampled <- sample(stimuli)
    cat("\n\n")
    cat(paste(sampled, collapse = "\n"))
  }

  cat("\n")

  sink()
}
