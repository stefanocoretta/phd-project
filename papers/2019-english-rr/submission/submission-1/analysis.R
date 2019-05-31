params <-
list(version = 1.1, `version-date` = "2019/05/31")

## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = FALSE, message = FALSE)
knitr::opts_knit$set(root.dir = normalizePath("../../"))
library(tidyverse)
theme_set(theme_minimal(base_family = "Arial Unicode MS"))
library(coretta2019eng) # https://github.com/stefanocoretta/coretta2019eng
data("eng_durations")
library(brms)
library(tidybayes)
library(broom.mixed)
library(knitr)
library(kableExtra)
eng_durations_rr <- na.omit(eng_durations)
eng_clos <- na.omit(eng_durations)


## ----rr-1----------------------------------------------------------------
priors <- c(
  set_prior("normal(200, 50)", class = "Intercept"),
  set_prior("normal(0, 25)", class = "b", coef = "voicingvoiced"),
  set_prior("normal(50, 25)", class = "b", coef = "num_sylmono"),
  set_prior("normal(50, 25)", class = "b", coef = "voicingvoiced:num_sylmono"),
  set_prior("normal(-25, 10)", class = "b", coef = "speech_rate_c"),
  set_prior("cauchy(0, 25)", class = "sd"),
  set_prior("lkj(2)", class = "cor"),
  set_prior("cauchy(0, 25)", class = "sigma")
)

rr_1 <- brm(
  rel_rel ~
    voicing +
    num_syl +
    voicing:num_syl +
    speech_rate_c +
    (1 + voicing | speaker) +
    (1 | word),
  family = gaussian(),
  data = eng_durations_rr,
  prior = priors,
  cores = 4,
  seed = 1234,
  file = "./data/cache/model_1_rr"
)


## ----rr-1-table----------------------------------------------------------
rr_1_tidy <- tidy(rr_1, effect = "fixed", conf.int = TRUE) %>% select(-effect, -component) %>% mutate(term = c("Intercept", "Voicing = voiced", "Num. syll. = monosyllabic", "Speech rate (cntr.)", "voiced × monosyll.")) %>% rename(Predictor = term, Mean = estimate, SD = std.error, Q2.5 = conf.low, Q97.5 = conf.high) %>% mutate(`CI width` = abs(Q2.5 - `Q97.5`))

kable(rr_1_tidy, format = "latex", booktabs = TRUE, linesep = "", digits = 2, caption = "Summary of the Bayesian regression fitted to release-to-release duration (model 1, see \\Cref{s:rr})") %>%
kable_styling(font_size = 8)


## ----rr-2----------------------------------------------------------------
priors <- c(
  set_prior("normal(200, 50)", class = "Intercept"),
  set_prior("normal(0, 30)", class = "b", coef = "voweler"),
  set_prior("normal(0, 30)", class = "b", coef = "vowelee"),
  set_prior("normal(0, 30)", class = "b", coef = "placelabial"),
  set_prior("normal(-25, 10)", class = "b", coef = "speech_rate_c"),
  set_prior("cauchy(0, 25)", class = "sd"),
  set_prior("cauchy(0, 25)", class = "sigma")
)

rr_2 <- brm(
  rel_rel ~
    vowel +
    place +
    speech_rate_c +
    (1 | speaker) +
    (1 | word),
  family = gaussian(),
  data = eng_durations_rr,
  prior = priors,
  cores = 4,
  seed = 1234,
  file = "./data/cache/model_2_rr"
)


## ----rr-2-table----------------------------------------------------------
rr_2_tidy <- tidy(rr_2, effect = "fixed", conf.int = TRUE) %>% select(-effect, -component) %>% mutate(term = c("Intercept", "Vowel = /ɜː/", "Vowel = /iː/", "C2 place = labial", "Speech rate (cntr.)")) %>% rename(Predictor = term, Mean = estimate, SD = std.error, Q2.5 = conf.low, Q97.5 = conf.high) %>% mutate(`CI width` = abs(Q2.5 - `Q97.5`))

kable(rr_2_tidy, format = "latex", booktabs = TRUE, linesep = "", digits = 2, caption = "Summary of the Bayesian regression fitted to release-to-release duration (model 2, see \\Cref{s:rr})") %>%
kable_styling(font_size = 8)


## ----rr-3----------------------------------------------------------------
priors <- c(
  set_prior("normal(200, 50)", class = "Intercept"),
  set_prior("normal(0, 25)", class = "b", coef = "voicingvoiced"),
  set_prior("normal(50, 25)", class = "b", coef = "num_sylmono"),
  set_prior("normal(50, 25)", class = "b", coef = "voicingvoiced:num_sylmono"),
  set_prior("normal(0, 30)", class = "b", coef = "voweler"),
  set_prior("normal(0, 30)", class = "b", coef = "vowelee"),
  set_prior("normal(0, 30)", class = "b", coef = "placelabial"),
  set_prior("normal(-25, 10)", class = "b", coef = "speech_rate_c"),
  set_prior("cauchy(0, 25)", class = "sd"),
  set_prior("lkj(2)", class = "cor"),
  set_prior("cauchy(0, 25)", class = "sigma")
)

rr_3 <- brm(
  rel_rel ~
    voicing +
    num_syl +
    voicing:num_syl +
    vowel +
    place +
    speech_rate_c +
    (1 + voicing | speaker) +
    (1 | word),
  family = gaussian(),
  data = eng_durations_rr,
  prior = priors,
  cores = 4,
  seed = 1234,
  file = "./data/cache/model_3_rr"
)


## ----rr-3-table----------------------------------------------------------
rr_3_tidy <- tidy(rr_3, effect = "fixed", conf.int = TRUE) %>% select(-effect, -component) %>% mutate(term = c("Intercept", "Voicing = voiced", "Num. syll. = monosyllabic", "Vowel = /ɜː/", "Vowel = /iː/", "C2 place = labial", "Speech rate (cntr.)", "voiced × monosyll.")) %>% rename(Predictor = term, Mean = estimate, SD = std.error, Q2.5 = conf.low, Q97.5 = conf.high) %>% mutate(`CI width` = abs(Q2.5 - `Q97.5`))

kable(rr_3_tidy, format = "latex", booktabs = TRUE, linesep = "", digits = 2, caption = "Summary of the Bayesian regression fitted to release-to-release duration and predictors from model 1 and 2 (model 3, see \\Cref{s:rr})") %>%
kable_styling(font_size = 8)


## ----rr-3-intervals, include=TRUE, fig.cap="Posterior distributions and Bayesian credible intervals of the effects on release-to-release duration (model 3). For each effect, the thick blue-coloured bars indicate (from darker to lighter) the 50\\%, 80\\%, and 95\\% CI. The black point with bars are the posterior median (the point), the 98\\% (thin bar) and 66\\% (thicker bar) CI. The shaded grey area around 0 is the ROPE.", fig.lp="f:", out.extra="width=\\linewidth"----
rr_3_draws <- rr_3 %>%
  gather_draws(b_voicingvoiced, b_num_sylmono, `b_voicingvoiced:num_sylmono`, b_voweler, b_vowelee, b_placelabial)

rr_3_draws %>%
  ungroup() %>%
  mutate(.variable = factor(
    .variable,
    levels = c("b_placelabial", "b_vowelee", "b_voweler", "b_voicingvoiced:num_sylmono", "b_num_sylmono", "b_voicingvoiced")
  )) %>%
  ggplot(aes(.value, .variable)) +
  annotate("rect", xmin = -10, xmax = 10, ymin = -Inf, ymax = Inf, alpha = 0.5) +
  geom_vline(xintercept = 0) +
  geom_halfeyeh(fill = "#9ecae1", .width = c(0.66, 0.98), fatten_point = 1) +
  stat_intervalh(position = position_nudge(y = -0.2), size = 3) +
  scale_x_continuous(breaks = seq(-50, 25, 5)) +
  scale_y_discrete(labels = c("Place = labial", "Vowel = /iː/", "Vowel = /ɜː/", "voiced × monosyl.", "Num.syl. = monosyl.", "C2 voicing = voiced")) +
  scale_color_brewer() +
  labs(
    x = "Difference in release-to-release duration (ms)",
    y = element_blank()
  ) +
  theme(panel.grid.minor = element_blank())


## ----vow-4---------------------------------------------------------------
priors <- c(
  set_prior("normal(145, 30)", class = "Intercept"),
  set_prior("normal(50, 20)", class = "b", coef = "voicingvoiced"),
  set_prior("normal(0, 30)", class = "b", coef = "voweler"),
  set_prior("normal(0, 30)", class = "b", coef = "vowelee"),
  set_prior("normal(50, 25)", class = "b", coef = "num_sylmono"),
  set_prior("normal(0, 20)", class = "b", coef = "voicingvoiced:voweler"),
  set_prior("normal(0, 20)", class = "b", coef = "voicingvoiced:vowelee"),
  set_prior("normal(50, 25)", class = "b", coef = "voicingvoiced:num_sylmono"),
  set_prior("normal(0, 30)", class = "b", coef = "voweler:num_sylmono"),
  set_prior("normal(0, 30)", class = "b", coef = "vowelee:num_sylmono"),
  set_prior("normal(0, 30)", class = "b", coef = "voicingvoiced:voweler:num_sylmono"),
  set_prior("normal(0, 30)", class = "b", coef = "voicingvoiced:vowelee:num_sylmono"),
  set_prior("normal(-25, 10)", class = "b", coef = "speech_rate_c"),
  set_prior("cauchy(0, 25)", class = "sd"),
  set_prior("lkj(2)", class = "cor"),
  set_prior("cauchy(0, 25)", class = "sigma")
)

vow_4 <- brm(
  v1_duration ~
    voicing +
    vowel +
    num_syl +
    voicing:vowel +
    voicing:num_syl +
    vowel:num_syl +
    voicing:vowel:num_syl +
    speech_rate_c +
    (1 + voicing | speaker) +
    (1 | word),
  family = gaussian(),
  data = eng_durations,
  prior = priors,
  file = "./data/cache/model_4_vow",
  cores = 4
)


## ----vow-4-table---------------------------------------------------------
vow_4_tidy <- tidy(vow_4, effect = "fixed", conf.int = TRUE) %>% select(-effect, -component) %>% mutate(term = c("Intercept", "Voicing = voiced", "Vowel = /ɜː/", "Vowel = /iː/", "Num. syll. = monosyllabic", "Speech rate (cntr.)", "voiced × /ɜː/", "voiced × /iː/", "voiced × monosyll.", "/ɜː/ × monosyll.", "/iː/ × monosyll.", "voiced × /ɜː/ × monosyll.", "voiced × /iː/ × monosyll.")) %>% rename(Predictor = term, Mean = estimate, SD = std.error, Q2.5 = conf.low, Q97.5 = conf.high) %>% mutate(`CI width` = abs(Q2.5 - `Q97.5`))

kable(vow_4_tidy, format = "latex", booktabs = TRUE, linesep = "", digits = 2, caption = "Summary of the Bayesian regression fitted to vowel duration (model 4, see \\Cref{s:vow})") %>%
kable_styling(font_size = 8)


## ----vow-4-intervals, include=TRUE, fig.cap="Posterior distributions and Bayesian credible intervals of the effects on vowel duration (model 4). For each effect, the thick blue-coloured bars indicate (from darker to lighter) the 50\\%, 80\\%, and 95\\% CI. The black point with bars are the posterior median (the point), the 98\\% (thin bar) and 66\\% (thicker bar) CI. The shaded grey area around 0 is the ROPE.", fig.lp="f:", out.extra="width=\\linewidth"----
vow_4_draws <- vow_4 %>%
  gather_draws(b_voicingvoiced, b_num_sylmono, `b_voicingvoiced:num_sylmono`, b_voweler, b_vowelee, `b_voicingvoiced:voweler`, `b_voicingvoiced:vowelee`, `b_voweler:num_sylmono`, `b_vowelee:num_sylmono`, `b_voicingvoiced:voweler:num_sylmono`, `b_voicingvoiced:vowelee:num_sylmono`)

vow_4_draws %>%
  ungroup() %>%
  mutate(.variable = factor(
    .variable,
    levels = c("b_voicingvoiced:vowelee:num_sylmono", "b_voicingvoiced:voweler:num_sylmono", "b_vowelee:num_sylmono", "b_voweler:num_sylmono", "b_voicingvoiced:vowelee", "b_voicingvoiced:voweler", "b_vowelee", "b_voweler", "b_voicingvoiced:num_sylmono", "b_num_sylmono", "b_voicingvoiced")
  )) %>%
  ggplot(aes(.value, .variable)) +
  annotate("rect", xmin = -10, xmax = 10, ymin = -Inf, ymax = Inf, alpha = 0.5) +
  geom_vline(xintercept = 0) +
  geom_halfeyeh(fill = "#9ecae1", .width = c(0.66, 0.98), fatten_point = 1) +
  stat_intervalh(position = position_nudge(y = -0.2), size = 2) +
  scale_x_continuous(breaks = seq(-50, 40, 5)) +
  scale_y_discrete(labels = c("voiced × /iː/ × monosyl.", "voiced × /ɜː/ × monosyl.", "/iː/ × monosyl.", "/ɜː/ × monosyl.", "voiced × /iː/", "voiced × /ɜː/", "Vowel = /iː/", "Vowel = /ɜː/", "voiced × monosyl.", "Num.syl. = monosyl.", "C2 voicing = voiced")) +
  scale_color_brewer() +
  labs(
    x = "Difference in vowel duration (ms)",
    y = element_blank()
  ) +
  theme(panel.grid.minor = element_blank())


## ----clos-5--------------------------------------------------------------
priors <- c(
  set_prior("normal(90, 20)", class = "Intercept"),
  set_prior("normal(-20, 10)", class = "b", coef = "voicingvoiced"),
  set_prior("normal(15, 10)", class = "b", coef = "placelabial"),
  set_prior("normal(0, 25)", class = "b", coef = "num_sylmono"),
  set_prior("normal(0, 30)", class = "b", coef = "voicingvoiced:placelabial"),
  set_prior("normal(0, 30)", class = "b", coef = "voicingvoiced:num_sylmono"),
  set_prior("normal(0, 30)", class = "b", coef = "placelabial:num_sylmono"),
  set_prior("normal(0, 30)", class = "b", coef = "voicingvoiced:placelabial:num_sylmono"),
  set_prior("normal(-25, 10)", class = "b", coef = "speech_rate_c"),
  set_prior("cauchy(0, 25)", class = "sd"),
  set_prior("lkj(2)", class = "cor"),
  set_prior("cauchy(0, 25)", class = "sigma")
)

clos_5 <- brm(
  c2_clos_duration ~
    voicing +
    place +
    num_syl +
    voicing:place +
    voicing:num_syl +
    place:num_syl +
    voicing:place:num_syl +
    speech_rate_c +
    (1 + voicing | speaker) +
    (1 | word),
  family = gaussian(),
  data = eng_clos,
  prior = priors,
  cores = 4,
  file = "./data/cache/model_5_clos"
)


## ----clos-5-table--------------------------------------------------------
clos_5_tidy <- tidy(clos_5, effect = "fixed", conf.int = TRUE) %>% select(-effect, -component) %>% mutate(term = c("Intercept", "Voicing = voiced", "C2 place = labial", "Num. syll. = monosyllabic", "Speech rate (cntr.)", "voiced × labial", "voiced × monosyll.", "labial × monosyll.", "voiced × labial × monosyll.")) %>% rename(Predictor = term, Mean = estimate, SD = std.error, Q2.5 = conf.low, Q97.5 = conf.high) %>% mutate(`CI width` = abs(Q2.5 - `Q97.5`))

kable(clos_5_tidy, format = "latex", booktabs = TRUE, linesep = "", digits = 2, caption = "Summary of the Bayesian regression fitted to closure duration (model 5, see \\Cref{s:clos})") %>%
kable_styling(font_size = 8)


## ----clos-5-intervals, include=TRUE, fig.cap="Posterior distributions and Bayesian credible intervals of the effects on closure duration (model 4). For each effect, the thick blue-coloured bars indicate (from darker to lighter) the 50\\%, 80\\%, and 95\\% CI. The black point with bars are the posterior median (the point), the 98\\% (thin bar) and 66\\% (thicker bar) CI. The shaded grey area around 0 is the ROPE.", fig.lp="f:", out.extra="width=\\linewidth"----
clos_5_draws <- clos_5 %>%
  gather_draws(b_voicingvoiced, b_num_sylmono, `b_voicingvoiced:num_sylmono`, b_placelabial, `b_voicingvoiced:placelabial`, `b_placelabial:num_sylmono`, `b_voicingvoiced:placelabial:num_sylmono`)

clos_5_draws %>%
  ungroup() %>%
  mutate(.variable = factor(
    .variable,
    levels = c("b_voicingvoiced:placelabial:num_sylmono", "b_placelabial:num_sylmono", "b_voicingvoiced:placelabial", "b_placelabial", "b_voicingvoiced:num_sylmono", "b_num_sylmono", "b_voicingvoiced")
  )) %>%
  ggplot(aes(.value, .variable)) +
  annotate("rect", xmin = -10, xmax = 10, ymin = -Inf, ymax = Inf, alpha = 0.5) +
  geom_vline(xintercept = 0) +
  geom_halfeyeh(fill = "#9ecae1", .width = c(0.66, 0.98), fatten_point = 1) +
  stat_intervalh(position = position_nudge(y = -0.2), size = 2) +
  scale_x_continuous(breaks = seq(-50, 40, 5)) +
  scale_y_discrete(labels = c("voiced × labial × monosyl.", "labial × monosyl.", "voiced × labial", "C2 place = labial", "voiced × monosyl.", "Num.syl. = monosyl.", "C2 voicing = voiced")) +
  scale_color_brewer() +
  labs(
    x = "Difference in C2 closure duration (ms)",
    y = element_blank()
  ) +
  theme(panel.grid.minor = element_blank())

