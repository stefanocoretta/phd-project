params <-
list(version = "3.0.9000", `version-date` = "2019/10/09")

## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = FALSE, warning = FALSE, fig.path = "./", fig.lp = "f:", fig.process = function(x) {
  x2 = sub('-\\d+([.][a-z]+)$', '\\1', x)
  if (file.rename(x, x2)) x2 else x
})
knitr::opts_knit$set(root.dir = here::here())
library(usdm)
library(tidyverse)
theme_set(theme_minimal())
library(lme4)
library(lmerTest)
library(effects)
library(broom)
library(broom.mixed)
library(knitr)
library(kableExtra)


## ----read-data, include=FALSE, message=FALSE-----------------------------
load("./papers/2018-relrel/datasets/duration_data.Rdata")
durations_filtered <- durations_filtered %>%
  mutate(vor = (c2_rel - v1_ons) * 1000)
round_2 <- function(...) {
  round(..., digits = 2)
}


## ----vow-lm, include=FALSE, cache=TRUE-----------------------------------
vow_lm <- lmer(
  v1_duration ~
    c2_phonation *
    vowel *
    language +
    c2_place +
    speech_rate_c +
    (1+c2_phonation|speaker) +
    (1|item),
  data = durations_filtered
)
summary(vow_lm)


## ----Figure2, include=TRUE, fig.cap = "Raw data and boxplots of the duration in milliseconds of vowels in Italian (top row) and Polish (bottom row), for the vowels /a, o, u/ when followed by a voiceless or voiced stop", fig.lp="f:", out.extra="width=\\linewidth", cache=TRUE, dpi=300----
durations_filtered %>%
  ggplot(aes(c2_phonation, v1_duration)) +
  geom_boxplot(alpha = 0.5) +
  geom_jitter(alpha = 0.1, width = 0.2) +
  facet_grid(language ~ vowel) +
  labs(x = "C2 voicing", y = "Vowel duration (ms)")


## ----vow-descr, cache=TRUE-----------------------------------------------
vow_descr <- durations_filtered %>%
  group_by(language, c2_phonation) %>%
  summarise(mean = mean(v1_duration, na.rm = TRUE), sd = sd(v1_duration, na.rm = TRUE))


## ----clo-lm, include=FALSE, cache=TRUE-----------------------------------
clo_lm <- lmer(
  c2_clos_duration ~
    c2_phonation *
    vowel *
    language +
    c2_place +
    speech_rate_c +
    (1+c2_phonation|speaker) +
    (1|item),
  data = durations_filtered
)
summary(clo_lm)


## ----Figure3, echo=FALSE, include=TRUE, fig.cap = "Raw data and boxplots of closure duration in milliseconds of voiceless and voiced stops in Italian (top row) and Polish (bottom row) when preceded by the vowels /a, o, u/", fig.lp="f:", out.extra="width=\\linewidth", cache=TRUE, dpi=300----
durations_filtered %>%
  ggplot(aes(c2_phonation, c2_clos_duration)) +
  geom_boxplot(alpha = 0.5) +
  geom_jitter(alpha = 0.1, width = 0.2) +
  facet_grid(language ~ vowel) +
  labs(x = "C2 voicing", y = "C2 closure duration (ms)")


## ----clos-descr, cache=TRUE----------------------------------------------
clos_descr <- durations_filtered %>%
  group_by(language, c2_phonation) %>%
  summarise(mean = mean(c2_clos_duration, na.rm = TRUE), sd = sd(c2_clos_duration, na.rm = TRUE))


## ----vow-clo-lm, include=FALSE, cache=TRUE-------------------------------
vow_clo_lm <- lmer(
  v1_duration ~
    c2_clos_duration *
    vowel *
    speech_rate_c +
    (1|speaker) +
    (1|item),
  data = durations_filtered
)
summary(vow_clo_lm)


## ----Figure4, include=TRUE, fig.cap = "Raw data, estimated regression lines, and 95 per cent confidence intervals of the effect of closure duration on vowel duration for the vowels /a, o, u/ (from a mixed-effects model fitted to data pooled from Italian and Polish, see text for details)", fig.lp="f:", out.extra="width=\\linewidth", cache=TRUE, dpi=300----
as_tibble(effect("c2_clos_duration:vowel:speech_rate_c", vow_clo_lm)) %>%
  filter(speech_rate_c == -3e-04) %>%
  ggplot(aes(c2_clos_duration, fit)) +
  geom_point(data = durations_filtered, aes(y = v1_duration), alpha = 0.1) +
  geom_line() +
  geom_ribbon(aes(ymax = upper, ymin = lower), alpha = 0.2) +
  geom_rug(data = durations_filtered, aes(y = v1_duration), alpha = 0.1) +
  facet_grid(~ vowel) +
  coord_fixed() +
  labs(x = "Closure duration (ms)", y = "Vowel duration (ms)")


## ----word-bf, cache=TRUE-------------------------------------------------
word_lm <- lme4::lmer(
  word_duration ~
    c2_phonation +
    vowel +
    c2_place +
    language +
    speech_rate_c +
    (1+c2_phonation|speaker) +
    (1|item),
  data = durations_filtered,
  REML = FALSE
)

word_lm_null <- lme4::lmer(
  word_duration ~
    # c2_phonation +
    vowel +
    c2_place +
    language +
    speech_rate_c +
    (1+c2_phonation|speaker) +
    (1|item),
  data = durations_filtered,
  REML = FALSE
)

word_bf <- round(exp((BIC(word_lm) - BIC(word_lm_null)) / 2))


## ----word-descr, cache=TRUE----------------------------------------------
word_descr <- word_filtered %>%
  group_by(language, c2_phonation) %>%
  summarise(mean = mean(word_duration, na.rm = TRUE), sd = sd(word_duration, na.rm = TRUE))


## ----Figure5, include=TRUE, fig.cap="Raw data and boxplots of the duration in milliseconds of the release to release interval in Italian (left) and Polish (right) when C2 is voiceless or voiced", out.extra="width=\\linewidth", cache=TRUE, warning=FALSE, dpi=300----
rel_filtered %>%
  ggplot(aes(c2_phonation, rel_rel)) +
  geom_boxplot(alpha = 0.5) +
  geom_jitter(alpha = 0.1, width = 0.3) +
  facet_grid(~ language) +
  labs(x = "C2 voicing", y = "release to release duration (ms)") +
  theme(legend.position = "none")


## ----rr-bf, cache=TRUE---------------------------------------------------
rr_lm <- lme4::lmer(
  rel_rel ~
    c2_phonation +
    vowel +
    c2_place +
    language +
    speech_rate_c +
    (1+c2_phonation|speaker) +
    (1|item),
  data = durations_filtered,
  REML = FALSE
)

rr_lm_null <- lme4::lmer(
  rel_rel ~
    # c2_phonation +
    vowel +
    c2_place +
    language +
    speech_rate_c +
    (1+c2_phonation|speaker) +
    (1|item),
  data = durations_filtered,
  REML = FALSE
)

rr_bf <- round(exp((BIC(rr_lm) - BIC(rr_lm_null)) / 2))


## ----rr-descr, cache=TRUE------------------------------------------------
rr_descr <- word_filtered %>%
  group_by(language, c2_phonation) %>%
  summarise(mean = mean(rel_rel, na.rm = TRUE), sd = sd(rel_rel, na.rm = TRUE))


## ----Figure6, include=TRUE, fig.cap = "By-speaker random coefficients and error bars for the effect of C2 voicing on vowel duration, extracted from a mixed-effect model (Section 3.1)", fig.lp="f:", out.extra="width=\\linewidth", cache=TRUE, warning=FALSE, dpi=300----
as_tibble(coef(vow_lm)$speaker[,1:2], rownames = "speaker") %>%
  rename("intercept" = `(Intercept)`, "ve" = c2_phonationvoiced) %>%
  mutate(language = ifelse(str_detect(speaker, "^it"), "Italian", "Polish"), speaker = toupper(speaker)) %>%
    ggplot(aes(ve, reorder(speaker, ve), colour = language)) +
  geom_point(size = 3) +
  geom_errorbarh(aes(xmin = ve - 4.422, xmax = ve + 4.422)) +
  scale_colour_manual(values = c("black", "gray")) +
  labs(
    y = "Speaker",
    x = "Voicing effect (ms)"
  )

