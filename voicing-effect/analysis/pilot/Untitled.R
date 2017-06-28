library(tidyverse)
library(cowplot)
theme_set(theme_bw())
library(gss)
library(stringr)
library(lme4)
library(afex)
library(effects)
library(gamm4)
library(mgcv)
library(itsadug)
library(rticulate)

languages <- read_csv("./voicing-effect/stimuli/languages.csv")
words <- read_csv("./voicing-effect/stimuli/nonce.csv")

columns <- c(
    "speaker",
    "seconds",
    "rec.date",
    "prompt",
    "label",
    "TT.displacement.sm",
    "TT.velocity",
    "TT.velocity.abs",
    "TD.displacement.sm",
    "TD.velocity",
    "TD.velocity.abs"
)

splines <- read_aaa("./voicing-effect/results/ultrasound/pl04-tongue-cart.tsv", columns) %>%
    mutate(word = word(prompt, 2)) %>%
    left_join(y = languages) %>%
    left_join(y = words) %>%
    mutate_if(is.character, as.factor)

splines$c2phonation.ord <- as.ordered(splines$c2phonation)
splines$c2place.ord <- as.ordered(splines$c2place)
splines$vowel.ord <- as.ordered(splines$vowel)
contrasts(splines$c2phonation.ord) <- "contr.treatment"
contrasts(splines$c2place.ord) <- "contr.treatment"
contrasts(splines$vowel.ord) <- "contr.treatment"
max <- splines %>%
    filter(label %in% c("max_TT", "max_TD")
    ) %>%
    na.omit() %>%
    arrange(rec.date, fan)


event <- as.character(pull(max, rec.date))
previous <- ""
event.start <- NULL

for (i in 1:length(event)) {
    current <- event[i]
    if (current == previous) {
        event.start.current <- FALSE
    } else {
        event.start.current <- TRUE
    }
    
    previous <- current
    
    event.start <- c(event.start, event.start.current)
}

max <- max %>%
    mutate(start.event = event.start)

max.pl.gamm <- bam(
    Y ~
        c2phonation.ord +
        c2place.ord +
        vowel.ord +
        s(X, bs = "cr") +
        s(X, by = c2phonation.ord, bs = "cr") +
        s(X, rec.date, bs="fs", xt="cr", m=1, k=5) +
        #        s(X, speaker, bs="fs", xt="cr", m=1, k=5) +
        s(X, by = c2place.ord, bs = "cr") +
        s(X, by = vowel.ord, bs = "cr"),
    data = max,
    method = "fREML"
)

max.pl.gamm.null <- bam(
    Y ~
#        c2phonation.ord +
        c2place.ord +
        vowel.ord +
        s(X, bs = "cr") +
#        s(X, by = c2phonation.ord, bs = "cr") +
        s(X, rec.date, bs="fs", xt="cr", m=1, k=5) +
        #        s(X, speaker, bs="fs", xt="cr", m=1, k=5) +
        s(X, by = c2place.ord, bs = "cr") +
        s(X, by = vowel.ord, bs = "cr"),
    data = max,
    method = "fREML"
)

summary(max.pl.gamm)

r1 <- start_value_rho(max.pl.gamm)

max.pl.gam.AR <- bam(
    Y ~
        c2phonation.ord +
        c2place.ord +
        vowel.ord +
        s(X, bs = "cr") +
        s(X, by = c2phonation.ord, bs = "cr")+
        s(X, rec.date, bs="fs", xt="cr", m=1, k=5) +
        s(X, by = c2place.ord, bs = "cr") +
        s(X, by = vowel.ord, bs = "cr"),
    data = max,
    method = "fREML",
    rho = r1,
    AR.start = max$start.event
)

summary(max.pl.gam.AR)

r1.null <- start_value_rho(max.pl.gamm.null)

max.pl.gam.AR.null <- bam(
    Y ~
#        c2phonation.ord +
        c2place.ord +
        vowel.ord +
        s(X, bs = "cr") +
#        s(X, by = c2phonation.ord, bs = "cr") +
        s(X, rec.date, bs="fs", xt="cr", m=1, k=5) +
        s(X, by = c2place.ord, bs = "cr") +
        s(X, by = vowel.ord, bs = "cr"),
    data = max,
    method = "fREML",
    rho = r1,
    AR.start = max$start.event
)

summary(max.pl.gam.AR.null)

acf_resid(max.pl.gam.AR.null, split_pred = "AR.start")

compareML(max.pl.gam.AR.null, max.pl.gam.AR)

plot_smooth(max.pl.gam.AR, view = "X",
            plot_all= "c2phonation.ord", rug = FALSE,
            cond = list(vowel.ord = "o", c2place = "velar"))
plot_diff(max.pl.gam.AR, view = "X",
          comp = list(c2phonation.ord = c("voiceless", "voiced")),
          cond = list(vowel.ord = "o", c2place = "velar"))

plot_smooth(max.pl.gam.AR, view = "X",
            plot_all= "c2place.ord", rug = FALSE)
plot_diff(max.pl.gam.AR, view = "X",
          comp = list(c2place.ord = c("coronal", "velar")))

plot_smooth(max.pl.gam.AR, view = "X",
            plot_all= "vowel.ord", rug = FALSE)
plot_diff(max.pl.gam.AR, view = "X",
          comp = list(vowel.ord = c("o", "u")))

ggplot(max, aes(X, Y, colour = c2phonation, group = rec.date)) +
    geom_point(alpha = 0.5) +
    facet_grid(vowel ~ c2place)
