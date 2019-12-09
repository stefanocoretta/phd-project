plotpower <- function(nsubj = 20,
                      stddevquantiles = NULL,
                      posteriorquantiles = NULL,
                      posteriormeans = NULL,
                      mytitle = NULL) {
  sds <- seq(round(stddevquantiles[1]),
             round(stddevquantiles[2]), by = 1)

  powervals_upper <- rep(NA, length(sds))

  for (i in 1:length(sds)) {
    s <- sds[i]
    powervals_upper[i] <- power.t.test(
      d = posteriorquantiles[3],
      n = nsubj,
      sd = s,
      type = "one.sample",
      alternative = "two.sided"
    )$power
  }

  powervals_mean <- rep(NA, length(sds))

  for (i in 1:length(sds)) {
    s <- sds[i]
    powervals_mean[i] <- power.t.test(
      d = posteriormeans,
      n = nsubj,
      sd = s,
      type = "one.sample",
      alternative = "two.sided"
    )$power
  }

  powervals_lower <- rep(NA, length(sds))

  for (i in 1:length(sds)) {
    s <- sds[i]
    powervals_lower[i] <-
      power.t.test(
        d = posteriorquantiles[1],
        n = nsubj,
        sd = s,
        type = "one.sample",
        alternative = "two.sided"
      )$power
  }

  #powerdistn<-data.frame(sds=sds,powervals_upper=powervals_upper,
  #                       powervals_mean=powervals_mean,
  #                       powervals_lower=powervals_lower)

  plot(
    sds,
    powervals_upper,
    ylim = c(0, 1),
    type = "l",
    lty = 1,
    xlab = "standard deviations",
    ylab = "power",
    main = paste(nsubj, "participants", sep = " ")
  )
  text(50, powervals_upper[which(sds == 50)], as.character(posteriorquantiles[3]))
  abline(a = 0.8, b = 0, lty = 2)

  lines(sds, powervals_mean, lty = 1)
  text(50, powervals_mean[which(sds == 50)], as.character(posteriormeans))

  lines(sds, powervals_lower, lty = 1)
  text(50, powervals_lower[which(sds == 50)], as.character(posteriorquantiles[1]))
}

nsubj <- seq(2, 20, by = 1)

low_powermismatch <-
  power.t.test(
    d = 55,
    sd = 15,
    n = nsubj,
    type = "one.sample",
    alternative = "two.sided"
  )$power

mid_powermismatch <-
  power.t.test(
    d = 75,
    sd = 15,
    n = nsubj,
    type = "one.sample",
    alternative = "two.sided"
  )$power

high_powermismatch <-
  power.t.test(
    d = 95,
    sd = 15,
    n = nsubj,
    type = "one.sample",
    alternative = "two.sided"
  )$power

low_powermismatch2 <-
  power.t.test(
    d = 55,
    sd = 100,
    n = nsubj,
    type = "one.sample",
    alternative = "two.sided"
  )$power

mid_powermismatch2 <-
  power.t.test(
    d = 75,
    sd = 100,
    n = nsubj,
    type = "one.sample",
    alternative = "two.sided"
  )$power

high_powermismatch2 <-
  power.t.test(
    d = 95,
    sd = 100,
    n = nsubj,
    type = "one.sample",
    alternative = "two.sided"
  )$power

plot(
  nsubj,
  low_powermismatch,
  ylim = c(0, 1),
  type = "l",
  lty = 1,
  main = "sd=15 ms",
  xlab = "number of participants",
  ylab = "power"
)
text(45, 0.1, as.character(55))
lines(nsubj, mid_powermismatch, type = "l", lty = 1)
text(45, 0.2, as.character(75))
lines(nsubj, high_powermismatch, type = "l", lty = 1)
text(45, 0.35, as.character(95))

plot(
  nsubj,
  low_powermismatch2,
  ylim = c(0, 1),
  type = "l",
  lty = 1,
  main = "sd=100 ms",
  xlab = "number of participants",
  ylab = "power"
)

lines(nsubj, mid_powermismatch2, type = "l", lty = 1)
lines(nsubj, high_powermismatch2, type = "l", lty = 1)

subjects <- seq(2, 10, by = 2)
rows <- 2
cols <- 3
op <- par(mfrow = c(rows, cols))

for (nsubj in subjects) {
  plotpower(
    nsubj = nsubj,
    stddevquantiles = c(15, 100),
    posteriorquantiles = c(55, 75, 95),
    posteriormeans = 75,
    mytitle = paste(nsubj, "participants", sep = " ")
  )
}
par(op)

subjects <- seq(2, 10, by = 2)
rows <- 2
cols <- 3
op <- par(mfrow = c(rows, cols))

for (nsubj in subjects) {
  plotpower(
    nsubj = nsubj,
    stddevquantiles = c(15, 100),
    posteriorquantiles = c(7, 17.5, 30),
    posteriormeans = 17.5,
    mytitle = paste(nsubj, "participants", sep = " ")
  )
}

par(op)
