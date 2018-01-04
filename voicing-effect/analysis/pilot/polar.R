splines <- filter(
    splines.it,
    speaker == "it01",
    c2place == "coronal",
    vowel == "a",
    !is.na(Y)
) %>%
    mutate(Y = -Y) %>%
    as.data.frame(.)

ss <- polar.ssanova(
    splines,
    "c2phonation",
    CI.fill = TRUE,
    is.polar = FALSE,
    flip = T
)

splines_pol <- make.polar(splines, c(0.521551150793651, 51.108727))

ggplot(splines_pol, aes(X, Y, colour = c2phonation)) +
    geom_point()

splines_cart <- make.cartesian(select(splines_pol, X:Y))

ggplot(splines_cart, aes(X, Y, colour = c2phonation)) +
    geom_smooth()

polar_data %>%
    group_by(c(speaker, rec.date))


df <- tibble(
    g1 = c(1, 1, 2, 2, 2),
    g2 = c(1, 2, 1, 2, 1),
    a = sample(5),
    b = sample(5)
)

my_summarise <- function(df, group_by = list()) {
    args <- sapply(enquo, rlang::syms(group_by))
    df %>%
       group_by_at(vars(one_of(!!!args)))
}

my_summarise(df, list(g1, g2))

args <- list(quo(g1), quo(g2))

group_by(df, !!!args)
group_by_at(df, vars(one_of(c("g1", "g2"))))

my_enquo <- function(my_list) {
    sapply(my_list, enquo)
}
