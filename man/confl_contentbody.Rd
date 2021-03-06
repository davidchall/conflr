% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/contentbody.R
\name{confl_contentbody}
\alias{confl_contentbody}
\alias{confl_contentbody_convert}
\title{Converts between content body representations}
\usage{
confl_contentbody_convert(
  x,
  from = c("wiki", "storage", "editor", "view", "export_view", "styled_view"),
  to = c("storage", "editor", "view", "export_view", "styled_view")
)
}
\arguments{
\item{x}{The content body to convert.}

\item{from}{The format to convert from.}

\item{to}{The format to convert to.}
}
\description{
Converts between content body representations
}
\seealso{
\url{https://docs.atlassian.com/ConfluenceServer/rest/latest/}
}
