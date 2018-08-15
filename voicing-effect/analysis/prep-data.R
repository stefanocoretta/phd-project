library(tidyverse)
library(rticulate)

speakers <- read_csv("./voicing-effect/data/datasets/speakers.csv")
stimuli <- read_csv("./voicing-effect/data/datasets/stimuli.csv")

columns <- c(
  "speaker",
  "seconds",
  "rec_date",
  "prompt",
  "label",
  "TT_displacement_sm",
  "TT_velocity",
  "TT_velocity_abs",
  "TD_displacement_sm",
  "TD_velocity",
  "TD_velocity_abs",
  "TR_displacement_sm",
  "TR_velocity",
  "TR_velocity_abs"
)

#### Static ####

durations <- list.files(
  path = "./voicing-effect/data/datasets/acoustics",
  pattern = "*-durations.csv",
  full.names = TRUE
) %>%
  map_df(~read_csv(., na = "--undefined--"))

voicing <- list.files(
  path = "voicing-effect/data/datasets/egg",
  pattern = "*-voicing.csv",
  full.names = TRUE
) %>%
  map_df(~read_csv(., na = "--undefined--"))

gestures <- list.files(
  path = "./voicing-effect/data/datasets/ultrasound",
  pattern = "*-tongue-cart.tsv",
  full.names = TRUE
) %>%
  read_aaa(., columns, format = "wide") %>%
  separate(label, c("gesture", "part")) %>%
  select(-(part:Y_42)) %>%
  spread(gesture, seconds)

token_measures <- full_join(durations, voicing) %>%
  full_join(y = gestures) %>%
  mutate(
    c1_vot = (voicing_start - c1_rel) * 1000,
    vor = (c2_rel - v_onset) * 1000,
    gons_clos = (closure - GONS) * 1000,
    gons_max = (max - GONS) * 1000,
    nucleus_duration = (NOFF - NONS) * 1000,
    rel_gons = (GONS - c1_rel) * 1000
  )

# data for 7 time points per token: GONS, peak 1, peak 2, NONS, NOFF, MAX, closure
kinematics <- list.files(
  path = "./voicing-effect/data/datasets/ultrasound",
  pattern = "*-tongue-cart.tsv",
  full.names = TRUE
) %>%
  read_aaa(., columns, format = "wide") %>%
  select(-(X_1:Y_42))

#### Dynamic ####

formants_series <- list.files(
  path = "voicing-effect/data/datasets/acoustics",
  pattern = "*-formants.csv",
  full.names = TRUE
) %>%
  map_df(~read_csv(., na = "--undefined--"))

tracegram <- list.files(
  path = "./voicing-effect/data/datasets/egg",
  pattern = "*-degg-tracing.csv",
  full.names = TRUE
) %>%
  map_df(~read_csv(.))

wavegram <- list.files(
  path = "./voicing-effect/data/datasets/egg",
  pattern = "*-wavegram.csv",
  full.names = TRUE
) %>%
  map_df(~read_csv(.))

# tongue contours at 7 time points per token: GONS, peak 1, peak 2, NONS, NOFF, MAX, closure
tongue_contours <- list.files(
  path = "./voicing-effect/data/datasets/ultrasound",
  pattern = "*-tongue-cart.tsv",
  full.names = TRUE
) %>%
  read_aaa(., columns)

kinematics_series <- list.files(
  path = "./voicing-effect/data/datasets/ultrasound",
  pattern = "*-vowel-series.tsv",
  full.names = TRUE
) %>%
  read_aaa(., columns, format = "wide")

