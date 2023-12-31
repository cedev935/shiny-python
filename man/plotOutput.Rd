% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bootstrap.R
\name{plotOutput}
\alias{plotOutput}
\alias{imageOutput}
\title{Create an plot or image output element}
\usage{
imageOutput(
  outputId,
  width = "100\%",
  height = "400px",
  click = NULL,
  dblclick = NULL,
  hover = NULL,
  brush = NULL,
  inline = FALSE,
  fill = FALSE
)

plotOutput(
  outputId,
  width = "100\%",
  height = "400px",
  click = NULL,
  dblclick = NULL,
  hover = NULL,
  brush = NULL,
  inline = FALSE,
  fill = !inline
)
}
\arguments{
\item{outputId}{output variable to read the plot/image from.}

\item{width, height}{Image width/height. Must be a valid CSS unit (like
\code{"100\%"}, \code{"400px"}, \code{"auto"}) or a number, which will be
coerced to a string and have \code{"px"} appended. These two arguments are
ignored when \code{inline = TRUE}, in which case the width/height of a plot
must be specified in \code{renderPlot()}. Note that, for height, using
\code{"auto"} or \code{"100\%"} generally will not work as expected,
because of how height is computed with HTML/CSS.}

\item{click}{This can be \code{NULL} (the default), a string, or an object
created by the \code{\link[=clickOpts]{clickOpts()}} function. If you use a value like
\code{"plot_click"} (or equivalently, \code{clickOpts(id="plot_click")}),
the plot will send coordinates to the server whenever it is clicked, and
the value will be accessible via \code{input$plot_click}. The value will be
a named list  with \code{x} and \code{y} elements indicating the mouse
position.}

\item{dblclick}{This is just like the \code{click} argument, but for
double-click events.}

\item{hover}{Similar to the \code{click} argument, this can be \code{NULL}
(the default), a string, or an object created by the
\code{\link[=hoverOpts]{hoverOpts()}} function. If you use a value like
\code{"plot_hover"} (or equivalently, \code{hoverOpts(id="plot_hover")}),
the plot will send coordinates to the server pauses on the plot, and the
value will be accessible via \code{input$plot_hover}. The value will be a
named list with \code{x} and \code{y} elements indicating the mouse
position. To control the hover time or hover delay type, you must use
\code{\link[=hoverOpts]{hoverOpts()}}.}

\item{brush}{Similar to the \code{click} argument, this can be \code{NULL}
(the default), a string, or an object created by the
\code{\link[=brushOpts]{brushOpts()}} function. If you use a value like
\code{"plot_brush"} (or equivalently, \code{brushOpts(id="plot_brush")}),
the plot will allow the user to "brush" in the plotting area, and will send
information about the brushed area to the server, and the value will be
accessible via \code{input$plot_brush}. Brushing means that the user will
be able to draw a rectangle in the plotting area and drag it around. The
value will be a named list with \code{xmin}, \code{xmax}, \code{ymin}, and
\code{ymax} elements indicating the brush area. To control the brush
behavior, use \code{\link[=brushOpts]{brushOpts()}}. Multiple
\code{imageOutput}/\code{plotOutput} calls may share the same \code{id}
value; brushing one image or plot will cause any other brushes with the
same \code{id} to disappear.}

\item{inline}{use an inline (\code{span()}) or block container (\code{div()})
for the output}

\item{fill}{Whether or not the returned tag should be treated as a fill item,
meaning that its \code{height} is allowed to grow/shrink to fit a fill container
with an opinionated height (see \code{\link[htmltools:bindFillRole]{htmltools::bindFillRole()}}) with an
opinionated height. Examples of fill containers include \code{bslib::card()} and
\code{bslib::card_body_fill()}.}
}
\value{
A plot or image output element that can be included in a panel.
}
\description{
Render a \code{\link[=renderPlot]{renderPlot()}} or \code{\link[=renderImage]{renderImage()}} within an
application page.
}
\note{
The arguments \code{clickId} and \code{hoverId} only work for R base graphics
(see the \pkg{\link[graphics:graphics-package]{graphics}} package). They do
not work for \pkg{\link[grid:grid-package]{grid}}-based graphics, such as
\pkg{ggplot2}, \pkg{lattice}, and so on.
}
\section{Interactive plots}{


Plots and images in Shiny support mouse-based interaction, via clicking,
double-clicking, hovering, and brushing. When these interaction events
occur, the mouse coordinates will be sent to the server as \verb{input$}
variables, as specified by \code{click}, \code{dblclick}, \code{hover}, or
\code{brush}.

For \code{plotOutput}, the coordinates will be sent scaled to the data
space, if possible. (At the moment, plots generated by base graphics and
ggplot2 support this scaling, although plots generated by lattice and
others do not.) If scaling is not possible, the raw pixel coordinates will
be sent. For \code{imageOutput}, the coordinates will be sent in raw pixel
coordinates.

With ggplot2 graphics, the code in \code{renderPlot} should return a ggplot
object; if instead the code prints the ggplot2 object with something like
\code{print(p)}, then the coordinates for interactive graphics will not be
properly scaled to the data space.
}

\examples{
# Only run these examples in interactive R sessions
if (interactive()) {

# A basic shiny app with a plotOutput
shinyApp(
  ui = fluidPage(
    sidebarLayout(
      sidebarPanel(
        actionButton("newplot", "New plot")
      ),
      mainPanel(
        plotOutput("plot")
      )
    )
  ),
  server = function(input, output) {
    output$plot <- renderPlot({
      input$newplot
      # Add a little noise to the cars data
      cars2 <- cars + rnorm(nrow(cars))
      plot(cars2)
    })
  }
)


# A demonstration of clicking, hovering, and brushing
shinyApp(
  ui = basicPage(
    fluidRow(
      column(width = 4,
        plotOutput("plot", height=300,
          click = "plot_click",  # Equiv, to click=clickOpts(id="plot_click")
          hover = hoverOpts(id = "plot_hover", delayType = "throttle"),
          brush = brushOpts(id = "plot_brush")
        ),
        h4("Clicked points"),
        tableOutput("plot_clickedpoints"),
        h4("Brushed points"),
        tableOutput("plot_brushedpoints")
      ),
      column(width = 4,
        verbatimTextOutput("plot_clickinfo"),
        verbatimTextOutput("plot_hoverinfo")
      ),
      column(width = 4,
        wellPanel(actionButton("newplot", "New plot")),
        verbatimTextOutput("plot_brushinfo")
      )
    )
  ),
  server = function(input, output, session) {
    data <- reactive({
      input$newplot
      # Add a little noise to the cars data so the points move
      cars + rnorm(nrow(cars))
    })
    output$plot <- renderPlot({
      d <- data()
      plot(d$speed, d$dist)
    })
    output$plot_clickinfo <- renderPrint({
      cat("Click:\n")
      str(input$plot_click)
    })
    output$plot_hoverinfo <- renderPrint({
      cat("Hover (throttled):\n")
      str(input$plot_hover)
    })
    output$plot_brushinfo <- renderPrint({
      cat("Brush (debounced):\n")
      str(input$plot_brush)
    })
    output$plot_clickedpoints <- renderTable({
      # For base graphics, we need to specify columns, though for ggplot2,
      # it's usually not necessary.
      res <- nearPoints(data(), input$plot_click, "speed", "dist")
      if (nrow(res) == 0)
        return()
      res
    })
    output$plot_brushedpoints <- renderTable({
      res <- brushedPoints(data(), input$plot_brush, "speed", "dist")
      if (nrow(res) == 0)
        return()
      res
    })
  }
)


# Demo of clicking, hovering, brushing with imageOutput
# Note that coordinates are in pixels
shinyApp(
  ui = basicPage(
    fluidRow(
      column(width = 4,
        imageOutput("image", height=300,
          click = "image_click",
          hover = hoverOpts(
            id = "image_hover",
            delay = 500,
            delayType = "throttle"
          ),
          brush = brushOpts(id = "image_brush")
        )
      ),
      column(width = 4,
        verbatimTextOutput("image_clickinfo"),
        verbatimTextOutput("image_hoverinfo")
      ),
      column(width = 4,
        wellPanel(actionButton("newimage", "New image")),
        verbatimTextOutput("image_brushinfo")
      )
    )
  ),
  server = function(input, output, session) {
    output$image <- renderImage({
      input$newimage

      # Get width and height of image output
      width  <- session$clientData$output_image_width
      height <- session$clientData$output_image_height

      # Write to a temporary PNG file
      outfile <- tempfile(fileext = ".png")

      png(outfile, width=width, height=height)
      plot(rnorm(200), rnorm(200))
      dev.off()

      # Return a list containing information about the image
      list(
        src = outfile,
        contentType = "image/png",
        width = width,
        height = height,
        alt = "This is alternate text"
      )
    })
    output$image_clickinfo <- renderPrint({
      cat("Click:\n")
      str(input$image_click)
    })
    output$image_hoverinfo <- renderPrint({
      cat("Hover (throttled):\n")
      str(input$image_hover)
    })
    output$image_brushinfo <- renderPrint({
      cat("Brush (debounced):\n")
      str(input$image_brush)
    })
  }
)

}
}
\seealso{
For the corresponding server-side functions, see \code{\link[=renderPlot]{renderPlot()}} and
\code{\link[=renderImage]{renderImage()}}.
}
