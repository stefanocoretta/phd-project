#######################################################################################
# tongue_ssanova.r                                revised April 11, 2017
# Jeff Mielke
# functions for SSANOVA comparisons of tongue traces in polar coordinates using gss
#######################################################################################
#
# BASIC COMMAND TO GENERATE AN SSANOVA PLOT (IF 'phone' IS THE NAME OF YOUR FACTOR)
#  ss <- polar.ssanova(data, 'phone')
#
# BASIC COMMAND TO PLOT THE RAW DATA
#  show.traces(data)
#
# TO PLOT TO FILE, SEPARATING BY TWO DIFFERENT FACTORS (COLUMNS IN YOUR DATA FRAME):
#  cairo_pdf('my_ssanova_pdf.pdf', h=4.5, w=5, onefile=T)
#    ss.by.C <- polar.ssanova(data, 'consonant')
#    ss.by.V <- polar.ssanova(data, 'vowel')
#  dev.off()
#
# TO HIGHLIGHT RAW DATA FOR THE LEVEL ('I'):
#  show.traces(data, c('I'))
#
# DATA FILE SHOULD BE ORGANIZED LIKE THIS (MULTIPLE COLUMNS CAN BE USED INSTEAD OF word):
#
# word,token,X,Y
# dog,1,307,262
# dog,1,311,249
# dog,1,315,240
# dog,2,308,261
# dog,2,311,250
# dog,2,314,249
# cat,1,307,240
# dog,2,311,250
# dog,2,314,259
# ...
#
#######################################################################################
#
# polar.ssanova() ARGUMENTS (ALL OPTIONAL EXCEPT data):
#
#           data: your tongue tracings (minimally including columns X and Y and a
#                 column with a factor)
#       data.cat: the factor to use to categorize the data (defaults to 'word')
#          scale: how much to scale the axis values (e.g. to convert from pixels to
#                 centimeters)
#  origin.method: how to choose the origin for calculating polar coordinates
#          debug: whether to generate the cartesian and non-transformed polar plots too
#       plotting: whether to plot anything (or just return the result of the test)
#           main: the main title for the plot
#        CI.fill: whether to indicate confidence intervals with shading (like ggplot)
#                 or with dotted lines (like the earlier SSANOVA code).
#                 Defaults to FALSE (dotted lines)
#       printing: if TRUE, different splines use different line types, so that the
#                 figure can be printed in black and white.
#           flip: whether to flip the Y values (useful for plotting data from images
#                 in cartesian coordinates, but ignored if using polar coordinates)
# cartesian.only: used by cart.ssanova()
#       is.polar: if TRUE, the data is already in polar coordinates
#
#######################################################################################
#
#  cart.ssanova() SAME AS polar.ssanova() BUT DOESN'T USE POLAR COORDINATES
#
#######################################################################################
#
#   show.traces() ARGUMENTS (ALL OPTIONAL EXCEPT data):
#
#           data: your tongue tracings (minimally including columns X and Y and a
#                 column with a factor)
#       data.cat: the factor to use to categorize the tongues (defaults to 'word')
#   to.highlight: a list of factor levels to plot while muting the other levels
#        to.plot: a list of factor levels to plot, excluding the rest (defaults to all)
#    token.label: the factor to use to identify individual tokens (defaults to 'token')
#           flip: whether to flip the Y values (useful for plotting data from images)
#           main: the main title for the plot
#       overplot: whether to add the traces to an existing plot
#       is.polar: if TRUE, the data is already in polar coordinates
#         origin: used if the data is in polar coordinates already
#
#######################################################################################

library(gss)
library(plyr)

#CONVERT POLAR COORDINATES TO CARTESIAN COORDINATES
make.cartesian <- function(tr, origin = c(0, 0)) {
    X <- apply(tr, 1, function(x, y)
        origin[1] - x[2] * cos(x[1]))
    Y <- apply(tr, 1, function(x, y)
        x[2] * sin(x[1]) - origin[2])
    xy <- cbind(X, Y)
    return(xy)
}

#CONVERT CARTESIAN COORDINATES TO POLAR COORDINATES
make.polar <- function(data.xy, origin = c(0, 0)) {
    xy <- cbind(data.xy$X, data.xy$Y)
    all_r <-
        apply(xy, 1, function(x) sqrt((x[1] - origin[1]) ^ 2 + (x[2] - origin[2]) ^ 2))
    all_theta <-
        pi + apply(xy, 1, function(x, y) atan2(x[2] - origin[2], x[1] - origin[1]))
    data.tr <- data.xy
    data.tr$X <- all_theta
    data.tr$Y <- all_r
    return(data.tr)
}

#RESCALE DATA FROM PIXELS TO CENTIMETERS
us.rescale <- function(data, usscale, X = 'X', Y = 'Y') {
    data[, c(X)] <- data[, c(X)] * usscale
    data[, c(Y)] <- data[, c(Y)] * usscale
    data
}

#SELECT AN APPROPRIATE ORIGIN FOR THE DATA
select.origin <- function(Xs, Ys, tokens, method = 'xmean_ymin') {
    if (method == 'xmean_ymin') {
        if (mean(Ys) > 0) {
            return(c(mean(Xs), max(Ys) * 1.01))
        } else{
            return(c(mean(Xs), min(Ys) * 1.01))
        }
    } else if (method == 'yextremes') {
        if (mean(Ys) > 0) {
            return(c(mean(Xs[which(Ys == min(Ys))]), max(Ys) * 1.01))
        } else{
            return(c(mean(Xs[which(Ys == max(Ys))]), min(Ys) * 1.01))
        }
    } else if (method == 'xmean_ymean') {
        return(c(mean(Xs), mean(Ys)))
    } else if (method == 'mid_arc') {
        ss_data <- data.frame(token = tokens,
                              X = Xs,
                              Y = Ys)
        ss_ends <-
            ddply(
                ss_data,
                .(token),
                summarize,
                firstX = X[which(Y == max(Y[X < mean(X)]))],
                firstY = max(Y[X < mean(X)]),
                lastX = max(X),
                lastY = Y[which(X == max(X))]
            )
        ss_first <-
            c(median(ss_ends$firstX), median(ss_ends$firstY))
        ss_last <- c(median(ss_ends$lastX), median(ss_ends$lastY))
        ss_mid <- ss_first / 2 + ss_last / 2
        return(ss_mid)
    } else if (method == 'mid_arc_mod') {
        ss_data <- data.frame(token = tokens,
                              X = Xs,
                              Y = Ys)
        ss_ends <-
            ddply(
                ss_data,
                .(token),
                summarize,
                firstX = X[which(Y == max(Y[X < mean(X)]))],
                firstY = max(Y[X < mean(X)]),
                lastX = max(X),
                lastY = Y[which(X == max(X))]
            )
        ss_first <-
            c(median(ss_ends$firstX), median(ss_ends$firstY))
        ss_last <- c(median(ss_ends$lastX), median(ss_ends$lastY))
        #ss_mid <- ss_first/3 + 2*ss_last/3
        ss_mid <- ss_first / 2 + ss_last / 2
        return(c(ss_mid[1], max(Ys) * 1.01))
    }

    return(c(mean(Xs), max(Ys) * 1.01))
}

crop.result <- function(data, ss.result, data.cat) {
    new.result <- c()
    for (data.level in unique(ss.result[, data.cat])) {
        sub.data <- data[data[, data.cat] == data.level, ]
        sub.result <- ss.result[ss.result[, data.cat] == data.level, ]
        new.result <-
            rbind(new.result,
                  subset(
                      sub.result,
                      sub.result$X >= min(sub.data$X) & sub.result$X <= max(sub.data$X)
                  ))
    }
    new.result
}

#PERFORM THE SSANOVA AND RETURN THE RESULTING SPLINES AND CONFIDENCE INTERVALS
#expand.grid + predict scheme based on http://www.ling.upenn.edu/~joseff/papers/fruehwald_ssanova.pdf
tongue.ss <-
    function(data,
             data.cat = 'word',
             flip = FALSE,
             length.out = 1000,
             alpha = 1.4,
             crop = FALSE) {
        if (flip == TRUE) {
            data$Y <- -data$Y
        }
        data$tempword <- data[, data.cat]
        #print(summary(lm(Y ~ tempword * X, data=data)))
        ss.model <-
            ssanova(Y ~ tempword + X + tempword:X,
                    data = data,
                    alpha = alpha)
        ss.result <-
            expand.grid(
                X = seq(min(data$X), max(data$X), length.out = length.out),
                tempword = levels(data$tempword)
            )
        ss.result$ss.Fit <-
            predict(ss.model, newdata = ss.result, se = T)$fit
        ss.result$ss.cart.SE  <-
            predict(ss.model, newdata = ss.result, se = T)$se.fit
        #print(names(ss.result))
        #print(aggregate(ss.Fit ~ tempword, FUN=mean, data=ss.result))
        #print(aggregate(ss.cart.SE ~ tempword, FUN=mean, data=ss.result))
        ss.result$ss.upper.CI.X <- ss.result$X
        ss.result$ss.upper.CI.Y <-
            ss.result$ss.Fit + 1.96 * ss.result$ss.cart.SE
        ss.result$ss.lower.CI.X <- ss.result$X
        ss.result$ss.lower.CI.Y <-
            ss.result$ss.Fit - 1.96 * ss.result$ss.cart.SE
        names(ss.result)[which(names(ss.result) == 'tempword')] <-
            data.cat

        print(summary(ss.result))

        if (crop) {
            ss.result <- crop.result(data, ss.result, data.cat)
        }

        #ss.result
        list(model = ss.model, result = ss.result)
    }

#PLOT THE SSANOVA RESULTS
plot.tongue.ss <-
    function(ss.result,
             data.cat = 'word',
             lwd = 3,
             main = '',
             CI.fill = FALSE,
             printing = FALSE,
             show.legend = T,
             plot.labels = c(main, 'X', 'Y'),
             overplot = FALSE,
             xlim = NULL,
             ylim = NULL,
             Fit.palette = NULL,
             CI.palette = NULL,
             color.alpha = 0.25,
             Fit.v = 0.75,
             CI.v = 0.75,
             ltys = 1:100,
             axes = T,
             origin = NULL,
             palate = NULL) {
        ltys = 1:100
        n_categories <- length(levels(ss.result[, data.cat]))
        if (is.null(Fit.palette)) {
            Fit.palette <- rainbow(n_categories, v = Fit.v)
        }
        if (is.null(CI.palette)) {
            CI.palette <- rainbow(n_categories, alpha = color.alpha, v = CI.v)
        }

        xrange = range(
            c(
                ss.result$X,
                ss.result$ss.lower.CI.X,
                ss.result$ss.upper.CI.X,
                origin[1],
                palate$X
            )
        )
        yrange = range(
            c(
                ss.result$ss.Fit,
                ss.result$ss.lower.CI.Y,
                ss.result$ss.upper.CI.Y,
                origin[2],
                palate$Y
            )
        )

        # xrange = range(c(ss.result$X, ss.result$ss.lower.CI.X, ss.result$ss.upper.CI.X))
        # yrange = range(c(ss.result$ss.Fit, ss.result$ss.lower.CI.Y, ss.result$ss.upper.CI.Y))

        # if (!is.null(origin)){
        #     xrange <- range(c(xrange, origin[1]))
        #     yrange <- range(c(yrange, origin[2]))
        # }

        if (is.null(xlim)) {
            xlim <- xrange
        }
        if (is.null(ylim)) {
            ylim <- yrange
        }
        if (!overplot) {
            if (axes) {
                main <- plot.labels[1]
            } else{
                main <- ''
            }
            plot(
                0,
                0,
                xlim = xlim,
                ylim = ylim,
                xlab = plot.labels[2],
                ylab = plot.labels[3],
                main = main,
                type = 'n',
                axes = axes
            )
        }

        if (!is.null(palate)) {
            points(palate$X, palate$Y, type = 'l')
        }

        if (printing) {
            for (i in 1:n_categories) {
                w = levels(ss.result[, data.cat])[i]
                subdata <- ss.result[ss.result[, data.cat] == w, ]
                if (CI.fill == TRUE) {
                    polygon(
                        c(
                            subdata$ss.upper.CI.X,
                            rev(subdata$ss.lower.CI.X)
                        ),
                        c(
                            subdata$ss.upper.CI.Y,
                            rev(subdata$ss.lower.CI.Y)
                        ),
                        col = CI.palette[i],
                        border = F
                    )
                } else{
                    lines(
                        subdata$ss.upper.CI.X,
                        subdata$ss.upper.CI.Y,
                        type = 'l',
                        col = Fit.palette[i],
                        lty = 3
                    )
                    lines(
                        subdata$ss.lower.CI.X,
                        subdata$ss.lower.CI.Y,
                        type = 'l',
                        col = Fit.palette[i],
                        lty = 3
                    )
                }
                lines(
                    subdata$X,
                    subdata$ss.Fit,
                    type = 'l',
                    col = Fit.palette[i],
                    lwd = lwd,
                    lty = ltys[i]
                )
            }
            if (show.legend) {
                #legend(xrange[1]+0.8*diff(xrange), yrange[1]+0.3*diff(yrange), c(levels(ss.result[,data.cat])), lwd=lwd, col=Fit.palette, lty=1:n_categories)
                if (CI.fill) {
                    lege <-
                        legend(
                            xlim[1] + 0.8 * diff(ylim),
                            ylim[1] + 0.3 * diff(ylim),
                            c(levels(ss.result[, data.cat])),
                            lwd = lwd,
                            col = 'white',
                            lty = ltys[1:n_categories]
                        )
                    #print(lege)
                    for (i in 1:length(Fit.palette)) {
                        lines(
                            lege$rect$left + lege$rect$w * c(0.17, 0.6),
                            rep(lege$text$y[i], 2),
                            col = CI.palette[i],
                            lend = 'butt',
                            lwd = 12
                        )
                    }
                    for (i in 1:length(Fit.palette)) {
                        lines(
                            lege$rect$left + lege$rect$w * c(0.17, 0.6),
                            rep(lege$text$y[i], 2),
                            col = Fit.palette[i],
                            lwd = lwd,
                            lty = ltys[i]
                        )
                    }
                    #legend(xlim[1]+0.8*diff(ylim), ylim[1]+0.3*diff(ylim), c(levels(ss.result[,data.cat])), lwd=8, col=CI.palette, box.col='white', text.col='white')
                } else{
                    legend(
                        xlim[1] + 0.8 * diff(ylim),
                        ylim[1] + 0.3 * diff(ylim),
                        c(levels(ss.result[, data.cat])),
                        lwd = lwd,
                        col = Fit.palette,
                        lty = ltys[1:n_categories]
                    )
                }
                #print(lege)




            }
        } else{
            for (i in 1:n_categories) {
                w = levels(ss.result[, data.cat])[i]
                subdata <- ss.result[ss.result[, data.cat] == w, ]
                if (CI.fill == TRUE) {
                    polygon(
                        c(
                            subdata$ss.upper.CI.X,
                            rev(subdata$ss.lower.CI.X)
                        ),
                        c(
                            subdata$ss.upper.CI.Y,
                            rev(subdata$ss.lower.CI.Y)
                        ),
                        col = CI.palette[i],
                        border = F
                    )
                } else{
                    lines(
                        subdata$ss.upper.CI.X,
                        subdata$ss.upper.CI.Y,
                        type = 'l',
                        col = Fit.palette[i],
                        lty = 3
                    )
                    lines(
                        subdata$ss.lower.CI.X,
                        subdata$ss.lower.CI.Y,
                        type = 'l',
                        col = Fit.palette[i],
                        lty = 3
                    )
                }
                lines(
                    subdata$X,
                    subdata$ss.Fit,
                    type = 'l',
                    col = Fit.palette[i],
                    lwd = lwd,
                    lty = i
                )
            }
            if (show.legend) {
                legend(
                    'bottomright',
                    c(levels(ss.result[, data.cat])),
                    lwd = lwd,
                    lty = ltys,
                    col = Fit.palette
                )
            }
        }
    }

guess.data.cat <- function(data, data.cat) {

}

#PLOT THE ORIGINAL DATA
show.traces <-
    function(data,
             data.cat = 'word',
             to.highlight = c(''),
             to.plot = c(''),
             token.label = 'token',
             flip = TRUE,
             main = '',
             overplot = FALSE,
             is.polar = FALSE,
             origin = c(0, 0),
             show.legend = TRUE,
             xlim = NULL,
             ylim = NULL,
             trace.palette = NULL,
             ghost.palette = NULL,
             color.alpha = 0.1,
             color.v = 0.75,
             palate = NULL) {
        if (sum(!names(data) %in% c('token', 'X', 'Y')) == 1 &
            !data.cat %in% names(data)) {
            data.cat <- names(data)[!names(data) %in% c('token', 'X', 'Y')]
            warning(
                paste(
                    'Using column \"',
                    data.cat,
                    '" to group the data.\nTo avoid this warning, use "show.traces(data, \'',
                    data.cat,
                    '\')"',
                    sep = ''
                )
            )
        }
        #print(data.cat)
        show.cat <- function(data, data.cat, w, col) {
            subdata <- data[data[, data.cat] == w, ]
            subdata[, token.label] <- factor(subdata[, token.label])
            tokens <- levels(subdata[, token.label])
            for (t in tokens) {
                token <- subdata[subdata[, token.label] == t, ]
                lines(token$X, token$Y, col = col)
            }
        }
        if (flip) {
            data$Y <- -data$Y
            if (!is.null(palate)) {
                palate$Y <- -palate$Y
            }
        }
        if (is.polar) {
            data[, c('X', 'Y')] <-
                make.cartesian(data[, c('X', 'Y')], origin = origin)
        }
        categories <- levels(data[, data.cat])
        n_categories <- length(categories)
        if (is.null(trace.palette)) {
            trace.palette <- rainbow(n_categories, v = color.v)
        }
        if (is.null(ghost.palette)) {
            ghost.palette <- rainbow(n_categories, alpha = color.alpha, v = color.v)
        }

        if (overplot == FALSE) {
            if (is.null(xlim)) {
                xlim <- range(rbind(data$X, palate))
            }
            if (is.null(ylim)) {
                ylim <- range(rbind(data$Y, palate))
            }
            plot(
                0,
                0,
                xlim = xlim,
                ylim = ylim,
                xlab = 'X',
                ylab = 'Y',
                main = main
            )
        }

        if (!is.null(palate)) {
            points(palate$X, palate$Y, type = 'l')
        }

        for (i in 1:n_categories) {
            w = levels(data[, data.cat])[i]
            if (w %in% to.plot >= mean(categories %in% to.plot)) {
                if (w %in% to.highlight >= mean(categories %in% to.highlight)) {
                    show.cat(data, data.cat, w, col = trace.palette[i])
                } else{
                    show.cat(data, data.cat, w, col = ghost.palette[i])
                }
            }
        }
        if (show.legend) {
            legend('bottomright',
                   categories,
                   lwd = 1,
                   col = trace.palette)
        }
    }

#CALCULATE AN SSANOVA IN POLAR COORDINATES AND THEN PLOT IT BACK IN CARTESIAN COORDINATES
polar.ssanova <-
    function(data,
             data.cat = 'word',
             scale = 1,
             origin.method = 'xmean_ymin',
             debug = FALSE,
             plotting = TRUE,
             main = '',
             CI.fill = FALSE,
             printing = FALSE,
             flip = TRUE,
             cartesian.only = FALSE,
             is.polar = FALSE,
             show.legend = TRUE,
             plot.labels = c(main, 'X', 'Y'),
             overplot = FALSE,
             xlim = NULL,
             ylim = NULL,
             lwd = 3,
             alpha = 1.4,
             crop = FALSE,
             Fit.palette = NULL,
             CI.palette = NULL,
             color.alpha = 0.25,
             Fit.v = 0.75,
             CI.v = 0.75,
             ltys = 1:100,
             axes = T,
             origin = NULL,
             palate = NULL) {
        #origin <- c(NULL, NULL)
        if (sum(!names(data) %in% c('token', 'X', 'Y')) == 1 &
            !data.cat %in% names(data)) {
            data.cat <- names(data)[!names(data) %in% c('token', 'X', 'Y')]
            warning(
                paste(
                    'Using column \"',
                    data.cat,
                    '" to group the data.\nTo avoid this warning, use "polar.ssanova(data, \'',
                    data.cat,
                    '\')"',
                    sep = ''
                )
            )
        }
        if (flip == TRUE) {
            #    data$Y <- -data$Y
            if (!is.null(palate)) {
                palate$Y <- -palate$Y
            }
        }
        data.scaled <- us.rescale(data, scale)
        if (cartesian.only) {
            tongue.ss.return <-
                tongue.ss(
                    data.scaled,
                    data.cat = data.cat,
                    flip = flip,
                    alpha = alpha,
                    crop = crop
                )
            ss.pol.cart <- tongue.ss.return$result
            ss.cart <- ss.pol.cart
            ss.polar <- ss.pol.cart
        } else{
            if (is.polar) {
                #origin <- select.origin(data.scaled$X, data.scaled$Y, method=origin.method)
                origin <- c(0, 0)
                print (origin)
                data.polar <- data.scaled
            } else{
                if (is.null(origin)) {
                    origin <-
                        select.origin(data.scaled$X,
                                      data.scaled$Y,
                                      data.scaled$token,
                                      method = origin.method)
                }
                print(paste('origin is', paste(origin, collapse = ', ')))
                print(summary(data.scaled$Y))
                data.polar <- make.polar(data.scaled, origin)
            }
            tongue.ss.return <-
                tongue.ss(
                    data.polar,
                    data.cat = data.cat,
                    alpha = alpha,
                    crop = crop
                )

            ss.polar <- tongue.ss.return$result
            ss.cart <- c()

            ss.pol.cart <- ss.polar
            ss.pol.cart[, c('X', 'ss.Fit')] <-
                make.cartesian(ss.polar[, c('X', 'ss.Fit')], origin = origin)
            ss.pol.cart[, c('ss.cart.SE')] <- NA
            ss.pol.cart[, c('ss.upper.CI.X', 'ss.upper.CI.Y')] <-
                make.cartesian(ss.polar[, c('ss.upper.CI.X', 'ss.upper.CI.Y')], origin =
                                   origin)
            ss.pol.cart[, c('ss.lower.CI.X', 'ss.lower.CI.Y')] <-
                make.cartesian(ss.polar[, c('ss.lower.CI.X', 'ss.lower.CI.Y')], origin =
                                   origin)
        }

        if (plotting) {
            if (!is.null(origin)) {
                origin <- c(origin[1], ifelse(flip, -origin[2], origin[2]))
            }
            if (debug) {
                tongue.ss.return <-
                    tongue.ss(
                        data.scaled,
                        data.cat = data.cat,
                        flip = T,
                        crop = crop
                    )
                ss.cart <- tongue.ss.return$result
                plot.tongue.ss(
                    ss.cart,
                    data.cat,
                    main = main,
                    CI.fill = CI.fill,
                    printing = printing,
                    show.legend = show.legend,
                    plot.labels = plot.labels,
                    overplot = overplot,
                    xlim = xlim,
                    ylim = ylim,
                    lwd = lwd,
                    Fit.palette = Fit.palette,
                    CI.palette = CI.palette,
                    color.alpha = color.alpha,
                    Fit.v = Fit.v,
                    CI.v = CI.v,
                    ltys = ltys,
                    axes = axes,
                    origin = origin,
                    palate = palate
                )
                plot.tongue.ss(
                    ss.polar,
                    data.cat,
                    main = main,
                    CI.fill = CI.fill,
                    printing = printing,
                    show.legend = show.legend,
                    plot.labels = plot.labels,
                    overplot = overplot,
                    xlim = xlim,
                    ylim = ylim,
                    lwd = lwd,
                    Fit.palette = Fit.palette,
                    CI.palette = CI.palette,
                    color.alpha = color.alpha,
                    Fit.v = Fit.v,
                    CI.v = CI.v,
                    ltys = ltys,
                    axes = axes,
                    origin = origin,
                    palate = palate
                )
            }
            plot.tongue.ss(
                ss.pol.cart,
                data.cat,
                main = main,
                CI.fill = CI.fill,
                printing = printing,
                show.legend = show.legend,
                plot.labels = plot.labels,
                overplot = overplot,
                xlim = xlim,
                ylim = ylim,
                lwd = lwd,
                Fit.palette = Fit.palette,
                CI.palette = CI.palette,
                color.alpha = color.alpha,
                Fit.v = Fit.v,
                CI.v = CI.v,
                ltys = ltys,
                axes = axes,
                origin = origin,
                palate = palate
            )
        }
        #return ss.pol.cart
        list(
            polar = ss.polar,
            ss.cart = ss.cart,
            pol.cart = ss.pol.cart,
            model = tongue.ss.return$model,
            origin = origin
        )
    }

#CALCULATE AN SSANOVA IN CARTESIAN COORDINATES (NOT ADVISED FOR ULTRASOUND DATA)
cart.ssanova <-
    function(data,
             data.cat = 'word',
             scale = 1,
             origin.method = 'xmean_ymin',
             debug = FALSE,
             plotting = TRUE,
             main = '',
             CI.fill = FALSE,
             printing = FALSE,
             flip = TRUE,
             show.legend = TRUE,
             plot.labels = c(main, 'X', 'Y'),
             overplot = FALSE,
             xlim = NULL,
             ylim = NULL,
             lwd = 3,
             alpha = 1.4,
             crop = FALSE,
             Fit.palette = NULL,
             CI.palette = NULL,
             color.alpha = 0.25,
             Fit.v = 0.75,
             CI.v = 0.75,
             ltys = 1:100,
             axes = T) {
        polar.ssanova(
            data = data,
            data.cat = data.cat,
            scale = scale,
            origin.method = origin.method,
            debug = debug,
            plotting = plotting,
            main = main,
            CI.fill = CI.fill,
            printing = printing,
            flip = flip,
            cartesian.only = TRUE,
            show.legend = show.legend,
            plot.labels = plot.labels,
            overplot = overplot,
            xlim = xlim,
            ylim = ylim,
            lwd = lwd,
            alpha = alpha,
            crop = crop,
            Fit.palette = Fit.palette,
            CI.palette = CI.palette,
            color.alpha = color.alpha,
            Fit.v = Fit.v,
            CI.v = CI.v,
            ltys = ltys,
            axes = axes
        )
    }


rotateXY <- function(data, angle) {
    #rotate the data so that the occlusal plane is horizontal
    M <- cbind(data$X, data$Y)
    alpha <- -angle * pi / 180
    rotm <-
        matrix(c(cos(alpha), sin(alpha), -sin(alpha), cos(alpha)), ncol = 2)
    M2 <- t(rotm %*% (t(M) - c(M[1, 1], M[1, 2])) + c(M[1, 1], M[1, 2]))
    data[, c('X', 'Y')] <- M2
    data
}

separate_token <-
    function(data,
             split_into = c('repetition', 'phone_number', 'token_number', 'phone', 'time'),
             sep = '_',
             remove = FALSE) {
        require(tidyr)
        data <-
            separate(data,
                     'token',
                     split_into,
                     sep = sep,
                     remove = remove)
        for (column_name in split_into) {
            if (column_name == 'phone') {
                data$phone <- as.factor(data$phone)
            } else{
                data[, column_name] <- as.numeric(data[, column_name])
            }
        }
        data
    }

word_from_filename <- function(filename) {
    number_index <- regexpr('[0-9]', filename)[[1]]
    substr(filename, 1, number_index - 1)
}

token_from_filename <- function(filename) {
    number_index <- regexpr('[0-9]', filename)[[1]]
    gsub('.jpg', '', substr(filename, number_index, nchar(filename)))
}

separate_filename <- function(data) {
    words <-
        as.factor(unlist(lapply(
            paste(data$Filename), word_from_filename
        )))
    tokens <-
        as.factor(unlist(lapply(
            paste(data$Filename), token_from_filename
        )))
    separate_token(data.frame(word = words, token = tokens, data))
}
