v <- rnorm(500, 100, 30)
c <- rnorm(500, 70, 20)
noise <- rnorm(500, 10, 2)

sim_dur <- tibble(
  noise,
  v = sample(v) - noise,
  c = sample(c) + noise
)

v_c <- lm(
  v ~
    c,
  data = sim_dur
)

summary(v_c)

v <- rnorm(500, 100, 30)
c <- v * rnorm(500, 0.7, 0.1)
noise <- rnorm(500, 10, 2)

sim_dur <- tibble(
  noise,
  v = v - noise,
  c = c + noise
)

v_c <- lm(
  v ~
    c,
  data = sim_dur
)

summary(v_c)



boundary <- rnorm(500, 100, 30)
noisy_boundary <- boundary + rnorm(500, 0, 2)
t.test(boundary, noisy_boundary)
