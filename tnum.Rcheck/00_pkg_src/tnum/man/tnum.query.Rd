% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tnum.R
\name{tnum.query}
\alias{tnum.query}
\title{Query the truenumber DB}
\usage{
tnum.query(query = "* has *", max = 10, start = 0)
}
\arguments{
\item{query}{string in tnum query language}

\item{max}{maximum nuber of truenumbers to return}

\item{start}{begin return with this sequence number}
}
\value{
a data.frame where each row is a returned truenumber
}
\description{
Query the truenumber DB
}
