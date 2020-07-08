#' Truenumber utility functions for working with Twitter/Tweets
#' @author True Engineering Technology, LLC Boston, MA USA
#' @references \url{http://www.truenum.com}
#'
library(twitteR)

#' Authenticate twitteR package with Twitter account
#'

tnum.twitteR.authorize <- function() {
  twitter_token <- setup_twitter_oauth(
    consumer_key = "EJJSOPMbniEdgyxhD9Q6rZDp1",
    consumer_secret = "tcMRH9XTmXd6nq9hAFsYtsHW5cwsymN32duLCNmQIoqb3amwja",
    access_token = "1274782526926700546-PJpruW5N5CTkzycTj9gsZSePBdHv97",
    access_secret = "pfUowEnIFZRWOzJ8DDETiCNtIkT0PheEBuJnOE4O6bZvl"
  )
}

#' @title Post new tnums from twitteR query result
#'
#' tnums for each tweet:
#'  1. tnum for full text
#'  2. tnum for create date
#'  3. tnum for favorite count (not present if 0)
#'  4. tnum for retweet count (not present if 0)
#'  5  tnum for replied-to tweet subject (not present if not a reply)
#'  6. tnum for user location
#'
#' tags for each tweet:
#'  1. tagged if retweet
#'  2. tagged if truncated
#'  3. tagged with user device
#'
#' @param tweetList List of tweets as returned from twitteR::Search()
#'
#' @return return code of tnum.maketruenumbers call
#' @export N/A
#'

tnum.twitteR.post_tweets_as_tnums <- function(tweetList) {
  # Functions needed for apply() processing of tweet vectors ##########

  # Pull out a platform name from the HTML source field of the tweet
  getTweetPlatform <- function(atag) {
    platName <- "unknown"
    if (grepl("ipad", atag, ignore.case = TRUE)) {
      platName <- "iPad"
    } else if (grepl("android", atag, ignore.case = TRUE)) {
      platName <- "Android"
    } else if (grepl("web", atag, ignore.case = TRUE)) {
      platName <- "Web"
    } else if (grepl("iphone", atag, ignore.case = TRUE)) {
      platName <- "iPhone"
    } else if (grepl("linkedin", atag, ignore.case = TRUE)) {
      platName <- "LinkedIn"
    } else if (grepl("tweetdeck", atag, ignore.case = TRUE)) {
      platName <- "TweetDeck"
    }
    returnValue(paste0("tweet/platform:", platName))
  }

  #  clean up tweet text so it works as a JSON string
  escapequotes <- function(strng) {
    returnValue(gsub("\n", "", gsub('"', '\\\\"', strng)))
  }

  # for boolean fields, if true, a tag is generated; no tag if false.
  tagboolean <- function(boolVal, theTag) {
    if (boolVal) {
      returnValue(theTag)
    } else {
      returnValue(NA)
    }
  }

  ## end of apply() functions ######################################


  tf <- twitteR::twListToDF(tweetList)  #create data.frame from list
  numTweets <- nrow(tf)  # number of tweets

  # get user profiles for enriching tweet data
  users <- unique(tf$screenName)
  profiles <- twitteR::lookupUsers(users, TRUE)

  # make subject vector for all rows (tweets)
  tweet.subj.vector <-
    paste0("twitter/user:", tf$screenName, "/tweet:", tf$id)

  # make property, value and tag vectors for each truenum, and post for all rows

  # tags, common to all tnums of a tweet
  tweet.tags.platforms <-
    lapply(tf$statusSource, getTweetPlatform)

  tweet.tags.truncated <-
    lapply(tf$truncated, tagboolean, theTag = "tweet:truncated")

  tagList <- list()
  for (i in 1:numTweets) {
    tagList[[i]] <-
      list(tweet.tags.platforms[[i]], tweet.tags.truncated[[i]])
  }

  # ... property and value for tweet's text:
  tweet.prop.vector <- rep("text", length(tweet.subj.vector))
  tweet.cvalue.vector <- lapply(tf$text, escapequotes)

  retVal <-   # write the text tnums to the server
    tnum.maketruenumbers(tweet.subj.vector,
                         tweet.prop.vector,
                         tweet.cvalue.vector,
                         NA,
                         NA,
                         NA,
                         tagList)
}