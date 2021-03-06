% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/addin.R, R/document.R
\name{confl_create_post_from_Rmd}
\alias{confl_create_post_from_Rmd}
\alias{confluence_document}
\title{Publish R Markdown Document to 'Confluence'}
\usage{
confl_create_post_from_Rmd(Rmd_file, interactive = NULL, params = NULL, ...)

confluence_document(
  title = NULL,
  space_key = NULL,
  parent_id = NULL,
  type = c("page", "blogpost"),
  toc = FALSE,
  toc_depth = 7,
  code_folding = c("none", "hide"),
  supported_syntax_highlighting = getOption("conflr_supported_syntax_highlighting"),
  update = NULL,
  use_original_size = FALSE,
  interactive = NULL
)
}
\arguments{
\item{Rmd_file}{Path to an .Rmd file.}

\item{interactive}{If \code{FALSE}, shiny interface is not launched.}

\item{params}{If provided, a list of named parameters that override custom
params in the YAML front-matter.}

\item{...}{Arguments passed to \code{confluence_documents()}.}

\item{title}{Title of the post.}

\item{space_key}{The space key to find content under.}

\item{parent_id}{The page ID of the parent pages.}

\item{type}{The content type to return. Default value: \code{page}. Valid values: \code{page}, \code{blogpost}.}

\item{toc}{If \code{TRUE}, include a table of contents in the output.}

\item{toc_depth}{The max level of headers to include in the table of contents.}

\item{code_folding}{If \code{"hide"}, fold code blocks by default.}

\item{supported_syntax_highlighting}{A named character vector of supported syntax highlighting other than default (e.g. \code{c(r = "r")}).}

\item{update}{If \code{TRUE}, overwrite the existing page (if it exists).}

\item{use_original_size}{If \code{TRUE}, use the original image sizes.}
}
\description{
Knit and post a given R Markdown file to 'Confluence'.
}
\details{
All options of \code{confluence_document()} can also be specified via the argument
of \code{confl_create_post_from_Rmd}. If an option is specified on both, the one given
as an argument will be used.\preformatted{---
title: "title1"
output:
  confluence_document:
    space_key: "space1"
    parent_id: 1234
    toc: TRUE
    toc_depth: 4
    code_folding: hide
    supported_syntax_highlighting:
      r: r
      foo: bar
    update: true
    use_original_size: true
---

...
}
}
