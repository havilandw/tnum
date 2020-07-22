% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tnum.R
\name{tnum.makeTnumPhraseGraph}
\alias{tnum.makeTnumPhraseGraph}
\title{Make full tnum graph from tnum.query return data frame}
\usage{
tnum.makeTnumPhraseGraph(tdf, commonRoots = list())
}
\arguments{
\item{tdf}{truenum data frame as returned from tnum.query}

\item{commonRoots}{list of gsub patterns for replacement with --- to aggregate subjects}
}
\value{

}
\description{
Make full tnum graph from tnum.query return data frame
}