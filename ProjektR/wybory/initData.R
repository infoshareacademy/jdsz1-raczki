library(XML)
library(RCurl)
library(tidyverse)
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(tidyverse)
library(scales)
library(syuzhet)
library(rtweet)
library(httpuv)

init_mining <- function()
{
  filepath<-"parties_en.txt"
  text<-readLines(filepath)
  
  docs<-Corpus(VectorSource(text))
  
  inspect(docs)
  
  docs[[1]]$content
  docs[[3]]$content
  
  docs<-tm_map(docs,tolower)
  docs<-tm_map(docs,removeNumbers)
  docs<-tm_map(docs,removeWords, stopwords("english"))
  docs<-tm_map(docs,removePunctuation)
  docs<-tm_map(docs,stripWhitespace)
  docs<-tm_map(docs,removeWords,c("th"))
  
  
  dtm<-TermDocumentMatrix(docs)
  m<-as.matrix(dtm)
  v<-sort(rowSums(m),decreasing=TRUE)
  return(data.frame(word=names(v),freq=v))
}

init_dtm <- function()
{
  filepath<-"parties_en.txt"
  text<-readLines(filepath)
  
  docs<-Corpus(VectorSource(text))
  
  inspect(docs)
  
  docs[[1]]$content
  docs[[3]]$content
  
  docs<-tm_map(docs,tolower)
  docs<-tm_map(docs,removeNumbers)
  docs<-tm_map(docs,removeWords, stopwords("english"))
  docs<-tm_map(docs,removePunctuation)
  docs<-tm_map(docs,stripWhitespace)
  docs<-tm_map(docs,removeWords,c("th"))
  dtm <- TermDocumentMatrix(docs)
  
  return(dtm)
}

prepare_data_emotions <- function(d)
{
  df_sentiment<-get_nrc_sentiment(as.String(d$word)) 
  
  df_sentiment_transposed <- t(df_sentiment) # transpose data frame from columns to rows
  df_sentiment_final <- data.frame(emotions=row.names(df_sentiment_transposed), 
                                   sent_value=df_sentiment_transposed, row.names=NULL) # prepare final data frame with emotions in 1st column, values in 2nd
  df_sentiments <- df_sentiment_final[1:8,]
  return(df_sentiments)
}

prepare_data_sentiment <- function(d)
{
  df_sentiment<-get_nrc_sentiment(as.String(d$word)) 
  
  df_sentiment_transposed <- t(df_sentiment) # transpose data frame from columns to rows
  df_sentiment_final <- data.frame(emotions=row.names(df_sentiment_transposed), 
                                   sent_value=df_sentiment_transposed, row.names=NULL) # prepare final data frame with emotions in 1st column, values in 2nd
  df_emotions <- df_sentiment_final[9:10,]
  return(df_emotions)
}

getSentiment <-function(d, df_sentiment)
{
  negative_perc <- df_sentiment[1,2]/sum(df_sentiment[,2])
  positive_perc <- df_sentiment[2,2]/sum(df_sentiment[,2])
  not_classified_perc <- (dim(d)[1] - sum(df_sentiment[,2]))/dim(d)[1]
  
  return(c(Negative=negative_perc,Positive=positive_perc,Not_classified=not_classified_perc))
}

init_data <- function()
{
  # zrodlo danych
  link <- "https://docs.google.com/spreadsheets/d/1P9PG5mcbaIeuO9v_VE5pv6U4T2zyiRiFK_r8jVksTyk/htmlembed?single=true&gid=0&range=a10:o400&widget=false&chrome=false"
  xData <- getURL(link)
  dane_z_html <- readHTMLTable(xData, stringsAsFactors = FALSE, skip.rows = c(1, 3), encoding = "UTF-8")
  dane_z_html <- as.data.frame(dane_z_html)
  
  # zapisanie nazw kolumn z pierwzego wiersza
  nms <- dane_z_html[1,]
  
  # nadanie nazw kolumnom
  colnames(dane_z_html) <- nms
  
  # usunięcie pierwszego wiersza
  dane_z_html <- dane_z_html[-1, -1]
  
  # zastąpienie pzecinkow kropkami w wybranych kolumnach
  dane_z_html[, 7:15] <- apply(apply(dane_z_html[,7:15], 2, gsub, patt=",", replace="."), 2, as.numeric)
  
  # zamiana formatu daty z character na date
  dane_z_html[, 3]
  daty_ch <-dane_z_html[,3]
  daty_dat <- as.Date(daty_ch, format = "%d.%m.%Y")
  dane_z_html[, 3] <- daty_dat
  
  # wyczyszczenie naw kolumn
  colnames(dane_z_html)[1] <- "Osrodek"
  colnames(dane_z_html)[4] <- "Metoda"
  colnames(dane_z_html)[9] <- "K15"
  
  dane_z_html <- gather(dane_z_html, "PiS":"N/Z", key = "partia", value = "poparcie", na.rm = FALSE)
  
  #dane_z_html <- dane_z_html %>%
  #  group_by(Osrodek, Metoda) %>%
  #  mutate(liczba = n_distinct(Publikacja))
  
  return(dane_z_html)
}

twitter_username <- function(hashtag)
{
  # whatever name you assigned to your created app
  appname <- "sentiment_analysis_pszarmach"
  
  ## api key (example below is not a real key)
  key <- "4nyEL0XIk5WWGPvAVSpeQGnxL"
  
  ## api secret (example below is not a real key)
  secret <- "Wg4qQuyxziKzK5JCczyk9bbsKocKfoqvvRam68xTgbz3LvyoHG"
  
  twitter_token <- create_token(
    app = appname,
    consumer_key = key,
    consumer_secret = secret)
  
  some_tweets <- search_tweets(q = hashtag,
                               n = 500)
  
  df1 <- data.frame(sort(table(some_tweets$screen_name), decreasing = TRUE))[1:25,]
  colnames(df1)<-c('Username','Wystapienia')
  
  return(df1)
}

twitter_sources <- function(hashtag)
{
  # whatever name you assigned to your created app
  appname <- "sentiment_analysis_pszarmach"
  
  ## api key (example below is not a real key)
  key <- "4nyEL0XIk5WWGPvAVSpeQGnxL"
  
  ## api secret (example below is not a real key)
  secret <- "Wg4qQuyxziKzK5JCczyk9bbsKocKfoqvvRam68xTgbz3LvyoHG"
  
  
  twitter_token <- create_token(
    app = appname,
    consumer_key = key,
    consumer_secret = secret)
  
  some_tweets <- search_tweets(q = hashtag,
                               n = 500)
  
  df2 <- data.frame(sort(table(some_tweets$source), decreasing = TRUE))[1:10,]
  colnames(df2)<-c('Source','Wystapienia')
  
  return(df2)
}

twitter_top_tweets <- function(hashtag)
{
  # whatever name you assigned to your created app
  appname <- "sentiment_analysis_pszarmach"
  
  ## api key (example below is not a real key)
  key <- "4nyEL0XIk5WWGPvAVSpeQGnxL"
  
  ## api secret (example below is not a real key)
  secret <- "Wg4qQuyxziKzK5JCczyk9bbsKocKfoqvvRam68xTgbz3LvyoHG"
  
  
  twitter_token <- create_token(
    app = appname,
    consumer_key = key,
    consumer_secret = secret)
  
  some_tweets <- search_tweets(q = hashtag,
                               n = 500)
  
  df3 <- data.frame(some_tweets$text, some_tweets$favorite_count)
  df3 <- df3[order(-df3$some_tweets.favorite_count),]
  colnames(df3) <- c("Tweet", "Polubienia")
  df3_final <- df3[1:20,]
  
  return(df3_final)
}