
library(lme4)
library(effects)
library(ggplot2)

results_raw <- read.csv("./pilot/results/SC01_vowel_duration.csv")
words <- read.csv("./pilot/stimuli/nonce.csv")
results <- merge(results_raw, words, by.x = "word", by.y = "word")

model <- lmer(duration ~ c2phonation * vowel + c1phonation + c2place + (1|word), data = results)

plot(allEffects(model))
summary(model)

ggplot(results, aes(c1phonation, duration)) + facet_grid(. ~ vowel + c2place) +
    geom_violin(draw_quantiles = 0.5)
ggplot(results, aes(c1phonation, duration)) + geom_boxplot()
