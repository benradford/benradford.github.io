---
layout: post
categories: [Data analysis, Political science, R, Statistics]
title: Downloading Politifact Data
subtitle: 
author: Benjamin J. Radford
featured-image: /images/2015-11-08/politifact.jpeg
tags: [data analysis, r, political science]
date: 2015-11-08
---

[Politifact](http://www.politifact.com) is a website the rates the truthfulness of public statements. Generally they focus on statements by political leaders but they'll also tackle celebrities, chain emails, and bloggers from time to time. Statements are rated on a five point scale: "Pants on Fire!," "False," "Mostly False," "Half-True," "Mostly True," and "True." The script below will scrape Politifact and save every statement in a gzipped CSV file. The data is structured as `who`, `when`, `validity`, `subjects`, `statement`.

The code is available below and also on [Github](https://github.com/benradford/Politifact-Scraper/blob/master/politifact.R).

```r
library(XML)
library(stringr)
library(plyr)

page_one_of <- str_extract_all(as(htmlParse("http://www.politifact.com/truth-o-meter/statements/"),"character"),"Page\\s+1\\s+of\\s+[[:digit:]]+")
total_pages <- as.numeric(str_extract(page_one_of,"[[:digit:]]+$"))

statements <- list()
for(ii in 1:total_pages)
{
  cat("\r",ii)
  base.url <- paste0("http://www.politifact.com/truth-o-meter/statements/?page=",ii)
  page <- htmlParse(base.url)
  links <- str_extract_all(toString.XMLNode(page),'truth-o-meter/statements/[[:digit:]]+/[^\\"]+')
  links <- links[[1]]
  links <- links[!duplicated(links)]
  links <- paste0("http://www.politifact.com/",links)
  statements <- c(statements, list(links))
  Sys.sleep(0.5)
}
statement.urls <- do.call(c,statements)

getFib <- function(url)
{
  single.url <- url
  page <- htmlParse(single.url)
  statement <- xpathSApply(page, "//*/div[@class='statement__text']", xmlValue)
  statement <- gsub('\\\"|\\\r|\\\n|\\\t', "", statement)
  
  subjects <- str_extract_all(toString.XMLNode(page),'\\<a href="/subjects/[^/]*')[[1]]
  subjects <- subjects[!grepl("By subject", subjects)]
  subjects <- unlist(str_extract_all(subjects, "[^/]+$"))
  subjects <- paste(subjects,collapse=", ")
  
  validity <- str_extract_all(toString.XMLNode(page), 'alt="Mostly False"|alt="Mostly True"|alt="True"|alt="Half-True"|alt="False"|alt="Pants on Fire!"')[[1]]
  validity <- gsub('^[^\\\"]+|\\\"',"",validity)
  
  who.when <- xpathSApply(page, "//*/p[@class='statement__meta']", xmlValue)[[1]]
  when <- str_extract(who.when,"(Sunday|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday), [[:alpha:]]+ [[:alnum:]]+, [[:digit:]]+")
  who.when <- gsub(" on ", "~", who.when)
  who <- str_extract(who.when,"^[^\\~]+")
  who <- str_extract(who,"\\s.+$")
  who <- gsub("^\\s+","",who)
  
  temp.fib <- data.frame("who"=who,"when"=when,"validity"=validity,"subjects"=subjects,"statement"=statement)
  Sys.sleep(runif(1,0.25,0.75))
  return(temp.fib)
}

all.statements <- lapply(statement.urls, FUN=function(x)try(getFib(x)))
all.statements.df <- do.call(rbind, all.statements)

gz <- gzfile("politifact-statements.csv.gz", "w")
write.csv(all.statements.df,gz, row.names=F)
close(gz)
```

*Image courtesy of www.politifact.com.*