---
layout: post
title: Downloading Chinese Officials' Biographies
subtitle: 
author: Benjamin J. Radford
featured-image: /images/2015-11-08/ccp.png
tags: []
date: 2015-11-08
---
China's ruling elite are vast and notoriously difficult to obtain accurate biographies of, especially in a structured form. [China Vitae](http://www.chinavitae.com) provides a large database of information about Chinese political leaders but offers no clear way of downloading those biographies for use in quantitative studies. Here, I offer a simple script in R for scraping this data from China Vitae that produces a CSV that chronicles the careers of thousands of Chinese leaders. 

<strong>EDIT:</strong> Thanks to Jason Qiang Guo for pointing out an error in the regular expressions that caused this to fail on Windows devices. The error is fixed now.

The code is available below or on [Github](https://github.com/benradford/ChinaVitae-Scraper/blob/master/chinese_officials.R).

```r
library(XML)
library(stringr)

getBio <- function(url)
{
  # This function takes the URL for an official's page and returns the appropriate table.
  # Args:
  #   url: The URL for an official. Example: "http://www.chinavitae.com/biography/Shen_Weichen/career"
  #
  # Returns:
  #   A dataframe of the official's professional history.
  
  page <- htmlParse(url)
  
  name <- xpathSApply(page, "//*/div[@class='bioName']", xmlValue)
  
  # Get official's name
  chinese.name <- str_extract(name, "\\s+[^ ]+$")
  chinese.name <- gsub("^ ", "", chinese.name)
  english.name <- gsub("\\s+[^ ]+$", "", name)
  english.name <- gsub("\\s+$", "", english.name)
  
  # Get official's biography
  bio <- xpathSApply(page, "//*/div[@class='bioDetails']", xmlValue)
  birth.date <- gsub("^[^ ]+\\s", "", bio[1])
  birth.place <- gsub("^[^ ]+\\s", "", bio[2])
  
  # Get history
  tabs <- readHTMLTable(page, header=F)
  history <- tabs[[1]]
  history <- cleanHistory(history)
  if(nrow(history)<1)
    history <- cbind(start.date=NA,end.date=NA,position=NA,institution=NA,location=NA)

  return.df <- data.frame(chinese.name, english.name, birth.date, birth.place, history)
  return(return.df)
}

cleanHistory <- function(history.df)
{
  # Cleans an official's history data frame.
  # Args:
  #   history.df: A dataframe of official's history.
  # Returns:
  #   A cleaned dataframe of official's history.
  
  start.date <- str_extract(history.df[,1], "^[[:digit:]]+")
  end.date <- str_extract(history.df[,1], "[[:digit:]]+$")
  history.df[,2] <- gsub("\\(|\\)", "", history.df[,2])
  position <- str_extract(history.df[,2], "^[^,]+")
  location <- str_extract(history.df[,2], "\\s{3}.+$")
  temp <- gsub("  ","~~",history.df[,2])
  institution <- str_extract(temp, ", [^[~~]]+")
  institution <- gsub("^, ", "", institution)
  
  return.df <- data.frame(start.date, end.date, position, institution, location)
  return(return.df)
}

getOfficialsList <- function(url)
{
  # Get's a list of officials' names (and links) from the library page.
  # Args:
  #   url: The URL of a "Browse by Name" page from chinavitae.com.
  #
  # Returns:
  #   A vectory of career URL's to scrape for officials' bios.
  
  page <- htmlParse(url)
  links <- str_extract_all(toString.XMLNode(page), "biography/[^ ]+")[[1]]
  links <- gsub("[[:punct:]]*$","",links)
  links <- paste("http://www.chinavitae.com/",links,"/career",sep="")
  
  return(links)
}
```

The code above loads the required libraries (`XML` and `stringr`) and defines three functions we'll need for the next step. The first function, `getBio`, takes as an argument the URL for a given official. It returns a data frame with the raw data collected on that official from their biography page. This data will then be passed to the second function, `cleanHistory`. This function will parse the raw data collected by `getBio` to return a cleaned up and well-structured version. The third function, `getOfficialsList`, will take as an argument a URL from the "Browse by Name" page of China Vitae and return all of the URLs of every officials' bio on that page.

```r
# Create a base URL, then all 26 letters, then paste them together to get all 26 library pages.
base.url <- "http://www.chinavitae.com/biography_browse.php?l="
page.letters <- letters[1:26]
library.urls <- paste(base.url, page.letters, sep="")

# This will be the final data frame we produce.
official.df <- list()
failure.list <- NULL

# Loop through all URLs and get officials' information.
for(uu in library.urls)
{
  official.list <- getOfficialsList(uu)
  for(oo in official.list)
  {
    cat("\r",oo,"                                     ")
    flush.console()
    
    official.bio <- NULL
    try(official.bio <- getBio(oo))
    if(is.null(official.bio))
      failure.list <- c(failure.list, oo)
    
    official.df <- c(official.df, list(official.bio))
    Sys.sleep(runif(1,0.5,2))
  }
}
official.df <- do.call(rbind,official.df)

write.csv(official.df,"chinese_officials.csv",row.names=F)
write.csv(failure.list,"failures.csv",row.names=F)
```

Once all of the functions are loaded, the above code will call these functions to download data on all officials from China Vitae. First, we define the base url and then iteratively pass the letters of the alphabet as the argument appended to the end of the URL (i.e. "http://www.chinavitae.com/biography_browse.php?l=[a-z]"). For each of these base pages, the list of all officials' URLs are extracted. The inner loop iterates through every official's page and then downloads and parses those pages. Every result is added to a list object, `official.df`. Once the loop has completed, the list is row-bound together into a data frame and saved as `chinese_officials.csv`. A list of all officials for whom no data could be downloaded is saved as `failures.csv`. This guarantees complete coverage of China Vitae where every official must either have their data recorded in `chinese_officials.csv` or must be found in `failures.csv`. These individuals can then be inspected manually, if necessary.

Note that line 25, `Sys.sleep(runif(1,0.5,2))`, controls how the program avoids being detected and blocked by China Vitae. This tells the code to pause between downloading pages. The pause length is drawn randomly from a uniform distribution between 0.5 and 2 seconds. If you find that this program produces repeated failures, you are likely being rate-limited and need to increase these values.

This code will throw errors under certain conditions. In particular, China Vitae handles duplicated officials' names in an interesting way that will occasionally cause errors on the scraper's part. However, in these cases, the data for that official is unavailable from China Vitae, so there is not much that can be done about it. These names will be added to `failures.csv`. Additionally, many of these officials are given alternative names in the China Vitae database (such as Chen_Hao\|5129) which will work. Therefore, it's not as bad as it appears at first.