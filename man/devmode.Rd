% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/devmode.R
\name{devmode}
\alias{devmode}
\alias{in_devmode}
\alias{with_devmode}
\alias{devmode_inform}
\alias{register_devmode_option}
\alias{get_devmode_option}
\title{Shiny Developer Mode}
\usage{
devmode(
  devmode = getOption("shiny.devmode", TRUE),
  verbose = getOption("shiny.devmode.verbose", TRUE)
)

in_devmode()

with_devmode(devmode, code, verbose = getOption("shiny.devmode.verbose", TRUE))

devmode_inform(
  message,
  .frequency = "regularly",
  .frequency_id = message,
  .file = stderr(),
  ...
)

register_devmode_option(name, devmode_message = NULL, devmode_default = NULL)

get_devmode_option(
  name,
  default = NULL,
  devmode_default = missing_arg(),
  devmode_message = missing_arg()
)
}
\arguments{
\item{devmode}{Logical value which should be set to \code{TRUE} to enable Shiny
Developer Mode}

\item{verbose}{Logical value which should be set to \code{TRUE} display Shiny
Developer messages}

\item{code}{Code to execute with the temporary Dev Mode options set}

\item{message}{Developer Mode message to be sent to \code{\link[rlang:abort]{rlang::inform()}}}

\item{.frequency}{Frequency of the Developer Mode message used with
\code{\link[rlang:abort]{rlang::inform()}}. Defaults to once every 8 hours.}

\item{.frequency_id}{\code{\link[rlang:abort]{rlang::inform()}} message identifier. Defaults to
\code{message}.}

\item{.file}{Output connection for \code{\link[rlang:abort]{rlang::inform()}}. Defaults to \code{\link[=stderr]{stderr()}}}

\item{...}{Parameters passed to \code{\link[rlang:abort]{rlang::inform()}}}

\item{name}{Name of option to look for in \code{options()}}

\item{devmode_message}{Message to display once every 8 hours when utilizing
the \code{devmode_default} value.  If \code{devmode_message} is missing, the
registered \code{devmode_message} value be used.}

\item{devmode_default}{Default value to return if \code{in_devmode()} returns
\code{TRUE} and the specified option is not set in \code{\link[=options]{options()}}. For
\code{get_devmode_option()}, if \code{devmode_default} is missing, the
registered \code{devmode_default} value will be used.}

\item{default}{Default value to return if \code{in_devmode()} returns
\code{TRUE} and the specified option is not set in \code{\link[=options]{options()}}.}
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#experimental}{\figure{lifecycle-experimental.svg}{options: alt='[Experimental]'}}}{\strong{[Experimental]}}

Developer Mode enables a number of \code{\link[=options]{options()}} to make a developer's life
easier, like enabling non-minified JS and printing messages about
deprecated functions and options.

Shiny Developer Mode can be enabled by calling \code{devmode(TRUE)} and disabled
by calling \code{devmode(FALSE)}.

Please see the function descriptions for more details.
}
\section{Functions}{
\itemize{
\item \code{devmode()}: Function to set two options to enable/disable Shiny
Developer Mode and Developer messages

\item \code{in_devmode()}: Determines if Shiny is in Developer Mode. If the
\code{getOption("shiny.devmode")} is set to \code{TRUE} and not in testing inside
\code{testthat}, then Shiny Developer Mode is enabled.

\item \code{with_devmode()}: Temporarily set Shiny Developer Mode and Developer
message verbosity

\item \code{devmode_inform()}: If Shiny Developer Mode and verbosity are enabled,
displays a message once every 8 hrs (by default)

\item \code{register_devmode_option()}: Registers a Shiny Developer Mode option with an updated
value and Developer message. This registration method allows package
authors to write one message in a single location.

For example, the following Shiny Developer Mode options are registered:

\if{html}{\out{<div class="sourceCode r">}}\preformatted{# Reload the Shiny app when a sourced R file changes
register_devmode_option(
  "shiny.autoreload",
  "Turning on shiny autoreload. To disable, call `options(shiny.autoreload = FALSE)`",
  devmode_default = TRUE
)

# Use the unminified Shiny JavaScript file, `shiny.js`
register_devmode_option(
  "shiny.minified",
  "Using full shiny javascript file. To use the minified version, call `options(shiny.minified = TRUE)`",
  devmode_default = FALSE
)

# Display the full stack trace when errors occur during Shiny app execution
register_devmode_option(
  "shiny.fullstacktrace",
  "Turning on full stack trace. To disable, call `options(shiny.fullstacktrace = FALSE)`",
  devmode_default = TRUE
)
}\if{html}{\out{</div>}}

Other known, non-Shiny Developer Mode options:
\itemize{
\item Sass:
}

\if{html}{\out{<div class="sourceCode r">}}\preformatted{# Display the full stack trace when errors occur during Shiny app execution
register_devmode_option(
  "sass.cache",
  "Turning off sass cache. To use default caching, call `options(sass.cache = TRUE)`",
  devmode_default = FALSE
)
}\if{html}{\out{</div>}}

\item \code{get_devmode_option()}: Provides a consistent way to change the expected
\code{\link[=getOption]{getOption()}} behavior when Developer Mode is enabled. This method is very
similar to \code{\link[=getOption]{getOption()}} where the globally set option takes precedence.
See section "Avoiding direct dependency on shiny" for
\code{get_devmode_option()} implementation details.

\strong{Package developers:} Register your Dev Mode option using
\code{register_devmode_option()} to avoid supplying the same \code{devmode_default}
and \code{devmode_message} values throughout your package. (This requires a
\pkg{shiny} dependency.)

}}
\section{Avoiding direct dependency on shiny}{


The methods explained in this help file act independently from the rest of
Shiny but are included to provide blue prints for your own packages. If
your package already has (or is willing to take) a dependency on Shiny, we
recommend using the exported Shiny methods for consistent behavior. Note
that if you use exported Shiny methods, it will cause the Shiny package to
load. This may be undesirable if your code will be used in (for example) R
Markdown documents that do not have a Shiny runtime (\code{runtime: shiny}).

If your package can \strong{not} take a dependency on Shiny, we recommending
re-implementing these two functions:

\enumerate{
\item \code{in_devmode()}:

This function should return \code{TRUE} if \code{getOption("shiny.devmode")} is set.
In addition, we strongly recommend that it also checks to make sure
\code{testthat} is not testing.

\if{html}{\out{<div class="sourceCode r">}}\preformatted{in_devmode <- function() \{
  isTRUE(getOption("shiny.devmode", FALSE)) &&
    !identical(Sys.getenv("TESTTHAT"), "true")
\}
}\if{html}{\out{</div>}}

\item \code{get_devmode_option(name, default, devmode_default, devmode_message)}:

This function is similar to \code{getOption(name, default)}, but when the option
is not set, the default value changes depending on the Dev Mode.
\code{get_devmode_option()} should be implemented as follows:
\itemize{
\item If not in Dev Mode:
\itemize{
\item Return \code{getOption(name, default)}.
}
\item If in Dev Mode:
\itemize{
\item Get the global option \code{getOption(name)} value.
\item If the global option value is set:
\itemize{
\item Return the value.
}
\item If the global option value is not set:
\itemize{
\item Notify the developer that the Dev Mode default value will be used.
\item Return the Dev Mode default value.
}
}
}

When notifying the developer that the default value has changed, we strongly
recommend displaying a message (\code{devmode_message}) to \code{stderr()} once every 8
hours using \code{\link[rlang:abort]{rlang::inform()}}. This will keep the author up to date as to
which Dev Mode options are being altered. To allow developers a chance to
disable Dev Mode messages, the message should be skipped if
\code{getOption("shiny.devmode.verbose", TRUE)} is not \code{TRUE}.

\if{html}{\out{<div class="sourceCode r">}}\preformatted{get_devmode_option <- function(name, default = NULL, devmode_default, devmode_message) \{
  if (!in_devmode()) \{
    # Dev Mode disabled, act like `getOption()`
    return(getOption(name, default = default))
  \}

  # Dev Mode enabled, update the default value for `getOption()`
  getOption(name, default = \{
    # Notify developer
    if (
      !missing(devmode_message) &&
      !is.null(devmode_message) &&
      getOption("shiny.devmode.verbose", TRUE)
    ) \{
      rlang::inform(
        message = devmode_message,
        .frequency = "regularly",
        .frequency_id = devmode_message,
        .file = stderr()
      )
    \}

    # Return Dev Mode default value `devmode_default`
    devmode_default
  \})
\}
}\if{html}{\out{</div>}}

}

The remaining functions in this file are used for author convenience and are
not recommended for all reimplementation situations.
}

\examples{
# Enable Shiny Developer mode
devmode()

in_devmode() # TRUE/FALSE?

# Execute code in a temporary shiny dev mode
with_devmode(TRUE, in_devmode()) # TRUE

# Ex: Within shiny, we register the option "shiny.minified"
#   to default to `FALSE` when in Dev Mode
\dontrun{register_devmode_option(
  "shiny.minified",
  devmode_message = paste0(
    "Using full shiny javascript file. ",
    "To use the minified version, call `options(shiny.minified = TRUE)`"
  ),
  devmode_default = FALSE
)}

# Used within `shiny::runApp(launch.browser)`
get_devmode_option("shiny.minified", TRUE) # TRUE if Dev mode is off
is_minified <- with_devmode(TRUE, {
  get_devmode_option("shiny.minified", TRUE)
})
is_minified # FALSE

}
