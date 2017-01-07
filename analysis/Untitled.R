
library(dplyr)
library(gss)
library(ggplot2)

degg <- left_join(degg, nonce)
degg <- mutate(degg, word = as.factor(word))

maximum.model <- ssanova(maximum ~ c2phonation + word + c2phonation:time,
data = degg)
grid <- select(degg, time, c2phonation, word)


grid$maximum.fit <- predict(maximum.model, grid, se = T)$fit
grid$maximum.SE <- predict(maximum.model, grid, se = T)$se.fit
ggplot(grid, aes(x = time, colour = c2phonation, group = c2phonation)) +
geom_line(aes(y = maximum.fit), alpha = 1, colour = "grey20") +
geom_ribbon(aes(ymin = maximum.fit-(1.96*maximum.SE), ymax = maximum.fit+(1.96*maximum.SE),fill = c2phonation ),alpha = 0.5,colour = "NA")

### This is the one which works!
degg <- filter(degg, position == "before")
maximum.model <- ssanova(maximum ~ c2phonation + time + c2phonation:time,
data = degg)
minimum.model <- ssanova(minimum ~ c2phonation + time + c2phonation:time,
data = degg)
grid <- expand.grid(time = seq(min(degg$time), max(degg$time), length = 100),
                    c2phonation = c("voiced","voiceless"))

grid <- select(degg, time, c2phonation, word)
grid$maximum.fit <- predict(maximum.model, grid, se = T)$fit
grid$maximum.SE <- predict(maximum.model, grid, se = T)$se.fit
grid$minimum.fit <- predict(minimum.model, grid, se = T)$fit
grid$minimum.SE <- predict(minimum.model, grid, se = T)$se.fit

ggplot(grid, aes(x = time, colour = c2phonation, group = c2phonation)) +
geom_line(aes(y = maximum.fit), alpha = 1, colour = "grey20") +
geom_ribbon(aes(ymin = maximum.fit-(1.96*maximum.SE),
                ymax = maximum.fit+(1.96*maximum.SE),
                fill = c2phonation ),alpha = 0.5,colour = "NA") +
geom_line(aes(y = minimum.fit), alpha = 1, colour = "grey20") +
    geom_ribbon(aes(ymin = minimum.fit-(1.96*minimum.SE),
                    ymax = minimum.fit+(1.96*minimum.SE),
                    fill = c2phonation ),alpha = 0.5,colour = "NA") +
    xlim(-0.1,-0.02) + ylim(0,1)

degg.vls <- filter(degg, c2phonation == "vls")
degg.voi <- filter(degg, c2phonation == "voi")
ggplot(degg.vls, aes(time, maximum)) +
    geom_point()

max(degg.vls$time[degg.vls$position == "before"])
max(degg.voi$time[degg.voi$position == "before"])













```{r}
degg <- read.csv("pilot/results/SC01_degg_tracing.csv", na.strings="--undefined--")

degg <- left_join(degg, nonce)

ggplot(degg, aes(x = time, group = c2phonation, colour = c2phonation)) + 
    geom_smooth(aes(y = maximum), method = "loess") +
    geom_smooth(aes(y = minimum), method = "loess") +
    ylab("period") + xlim(-0.1,0.1) + ylim(0, 1)
```

```{r}
filter(degg, word == "pudu") %>%
    ggplot(aes(x = time, group = file, colour = file)) + 
    geom_point(aes(y = maximum), alpha = 0.5) +
    geom_point(aes(y = minimum), alpha = 0.5) +
    ylab("period") + xlim(-0.1,0.1) + ylim(0, 1)
```

```{r}
# degg.a <- filter(degg, vowel == "a")

maximum.model <- ssanova(maximum ~ c2phonation + word + c2phonation:time,
                         data = degg)
minimum.model <- ssanova(minimum ~ c2phonation + time + c2phonation:time, 
                         data = degg)

grid <- select(degg, time, c2phonation, word)

grid$maximum.fit <- predict(maximum.model, grid, se = T)$fit
grid$maximum.SE <- predict(maximum.model, grid, se = T)$se.fit
grid$minimum.fit <- predict(minimum.model, grid, se = T)$fit
grid$minimum.SE <- predict(minimum.model, grid, se = T)$se.fit


ggplot(grid, aes(x = time, colour = c2phonation, group = c2phonation)) +
    geom_line(aes(y = maximum.fit), alpha = 1, colour = "grey20") +
    geom_line(aes(y = minimum.fit), alpha = 1, colour = "grey20") +
    geom_ribbon(aes(ymin = maximum.fit-(1.96*maximum.SE), ymax = maximum.fit+(1.96*maximum.SE),fill = c2phonation ),alpha = 0.5,colour = "NA") +
    geom_ribbon(aes(ymin = minimum.fit-(1.96*minimum.SE), ymax = minimum.fit+(1.96*minimum.SE),fill = c2phonation ),alpha = 0.5,colour = "NA") +
    xlim(-0.1,0)

# eff <- ggplot(grid, aes(x = time))
# eff <- eff + geom_line(aes(y = maximum.fit))
# eff <- eff + geom_ribbon(aes(ymax = maximum.fit+(1.96*maximum.SE),ymin = maximum.fit-(1.96*maximum.SE)),alpha = 0.5)
# eff <- eff + facet_wrap(~ c2phonation)
# eff <- eff + geom_hline(yintercept = 0, lty = 2)
# eff <- eff + ylab("Difference in Hz")
# print(eff)
```

```{r}
splines.model <- ssanova(Y ~ c2phonation  + X + c2phonation:X, 
                         data = splines)

grid <- select(splines, -X)

grid$splines.fit <- predict(splines.model, grid, se = T)$fit
grid$splines.SE <- predict(splines.model, grid, se = T)$se.fit


ggplot(grid, aes(x = time, colour = c2phonation, group = c2phonation)) +
    geom_line(aes(y = maximum.fit), alpha = 1, colour = "grey20") +
    geom_line(aes(y = minimum.fit), alpha = 1, colour = "grey20") +
    geom_ribbon(aes(ymin = maximum.fit-(1.96*maximum.SE), ymax = maximum.fit+(1.96*maximum.SE),fill = c2phonation ),alpha = 0.5,colour = "NA") +
    geom_ribbon(aes(ymin = minimum.fit-(1.96*minimum.SE), ymax = minimum.fit+(1.96*minimum.SE),fill = c2phonation ),alpha = 0.5,colour = "NA") +
    xlim(-0.1,0)
```


