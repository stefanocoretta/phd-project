library(tidyverse)
a <- rnorm(100, 100)
b <- rnorm(100, 50)
m <- rnorm(100)

ggplot() +
  aes(x = a - m, y = b + m) +
  geom_point() +
  geom_smooth(method = "lm")
ggplot() +
  aes(x = a, y = b) +
  geom_point() +
  geom_smooth(method = "lm")

ggplot() +
  aes(x = a - m + rnorm(1, 10), y = b + m + rnorm(1, 10)) +
  geom_point() +
  geom_smooth(method = "lm")

m <- rnorm(100)
m2 <- rnorm(100, 0)
a <- rnorm(100, 100)
b <- a * -1.3 + m2

ggplot() +
  aes(a, b) +
  geom_point() +
  geom_smooth(method = "lm")
