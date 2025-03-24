#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Key Bobster
#'
#' @param data,params,size key stuff
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
draw_key_bobster <-  function(data, params, size) {

  filename <- system.file(paste0(data$bobster, ".png"), package = "ggbobster", mustWork = TRUE)
  # print(filename)
  img <- as.raster(png::readPNG(filename))
  aspect <- dim(img)[1]/dim(img)[2]
  # rasterGrob
  grid::rasterGrob(image         = img)
}

# bobsterGrob
bobsterGrob <- function(x, y, size, bobster = "bobster", geom_key = list(bobster = "bobster.png",
                                                                       bobster_face = "bobster_face.png")
                        ) {

  filename <- system.file(geom_key[[unique(bobster)]], package = "ggbobster", mustWork = TRUE)
  img <- as.raster(png::readPNG(filename))

  # rasterGrob
  grid::rasterGrob(x             = x,
                   y             = y,
                   image         = img,
                   # only set height so that the width scales proportionally and so that the icon
                   # stays the same size regardless of the dimensions of the plot
                   height        = size * ggplot2::unit(20, "mm"))
}

# GeomBobster
GeomBobster <- ggplot2::ggproto(`_class` = "GeomBobster",
                               `_inherit` = ggplot2::Geom,
                               required_aes = c("x", "y"),
                               non_missing_aes = c("size", "bobster"),
                               default_aes = ggplot2::aes(size = 1, bobster = "bobster", shape  = 19,
                                                          colour = "black",   fill   = NA,
                                                          alpha  = NA,
                                                          stroke =  0.5,
                                                          scale = 5,
                                                          image_filename = "bobster"),

                               draw_panel = function(data, panel_scales, coord, na.rm = FALSE) {
                                 coords <- coord$transform(data, panel_scales)
                                 ggplot2:::ggname(prefix = "geom_bobster",
                                                  grob = bobsterGrob(x = coords$x,
                                                                    y = coords$y,
                                                                    size = coords$size,
                                                                    bobster = coords$bobster))
                               },

                               draw_key = draw_key_bobster)

#' @title Bobster layer
#' @description The geom is used to add Bobster to plots. See ?ggplot2::geom_points for more info.
#' @inheritParams ggplot2::geom_point
#' @examples
#'
#' # install.packages("ggplot2")
#'library(ggplot2)
#'
#' ggplot(mtcars) +
#'  geom_bobster(aes(mpg, wt), bobster = "bobster") +
#'  theme_bw()
#'
#' ggplot(mtcars) +
#'  geom_bobster(aes(mpg, wt), bobster = "bobster") +
#'  theme_bw()
#'
#' @importFrom grDevices as.raster
#' @export
geom_bobster <- function(mapping = NULL,
                        data = NULL,
                        stat = "identity",
                        position = "identity",
                        ...,
                        na.rm = FALSE,
                        show.legend = NA,
                        inherit.aes = TRUE) {

  ggplot2::layer(data = data,
                 mapping = mapping,
                 stat = stat,
                 geom = GeomBobster,
                 position = position,
                 show.legend = show.legend,
                 inherit.aes = inherit.aes,
                 params = list(na.rm = na.rm, ...))
}



