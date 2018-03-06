---
title: "Gerrymandering"
author: "Mike Hall"
date: "3/3/2018"
output:
  html_document:
    keep_md: true
---





## Gerrymandering


```r
# 2002-2010 WI Election Data with 2011 Wards
w0210 <- read.csv("20022010_WI_Election_Data_with_2011_Wards.csv")
# 2012-2020 WI Election Data with 2011 Wards 
w11 <- read.csv("20122020_WI_Election_Data_with_2011_Wards.csv")
w11 <- w11[,c("OBJECTID_1","OBJECTID","GEOID10","NAME","ASM","CNTY_NAME","PERSONS18","WSADEM12","WSADEM14","WSADEM16","WSADEM212","WSAREP12","WSAREP14","WSAREP16","WSAREP212","WSAREP214")]
# 2012-2020 WI Election Data with 2017 Wards
w17 <- read.csv("Wards2017_ED12toED16.csv")
# For imputation
a0210 <- w0210 %>% group_by(ASM) %>% summarize(dem02 <- sum(WSADEM02), dem04 <- sum(WSADEM04), dem06 <- sum(WSADEM06), dem08 <- sum(WSADEM08), dem10 <- sum(WSADEM10), rep02 <- sum(WSAREP02), rep04 <- sum(WSAREP04), rep06 <- sum(WSAREP06), rep08 <- sum(WSAREP08), rep10 <- sum(WSAREP10), voting.age <- sum(PERSONS18), n())
nz <- rowSums(a0210[,2:6] != 0)
avg.dem <- rowSums(a0210[,2:6])/nz
nz <- rowSums(a0210[,7:11] != 0)
avg.rep <- rowSums(a0210[,7:11])/nz
names(a0210) <- c("ASM","dem02","dem04","dem06","dem08","dem10","rep02","rep04","rep06","rep08","rep10","voting.age","n")
```


```r
quickEfficiencyGap <- function(dem,rep) {
  # The efficiency gap, then, is simply the difference between the parties
  # respective wasted votes, divided by the total number of votes cast in    # the election.
  #
  # quick assumes only two parties
  # Efficiency Gap = Seat Margin – (2 x Vote Margin)
  #
  dem.seats <- sum(dem > rep)
  dem.share <- sum(dem)/sum(dem+rep)
  eg.dem <- ((dem.seats/length(dem))*100-50) - (dem.share*100-50)*2
  rep.seats <- sum(rep > dem)
  rep.share <- sum(rep)/sum(dem+rep)
  eg.rep <- ((rep.seats/length(rep))*100-50) - (rep.share*100-50)*2
  eg <- data.frame(cbind(c(dem.seats,rep.seats),c(dem.share,rep.share),c(eg.dem,eg.rep)))
  eg
}
  
# Imputing Uncontested
# should be party average from 02-10 * avg.turnout (if party avg)
#           loser getting avg.turnout - that
# if no party avg loser gets 25% avg.turnout, winner the rest
#
a12 <- w11 %>% group_by(ASM) %>% summarize(dem <- sum(WSADEM12), dem2 <- sum(WSADEM212), rep <- sum(WSAREP12), rep2 <- sum(WSAREP212), voting.age <- sum(PERSONS18),n())
names(a12) <- c("asm","dem","dem2","rep","rep2","voting.age","n")
avg.turnout <- (a12$dem+a12$dem2+a12$rep+a12$rep2)/a12$voting.age
xavg.dem <- is.na(avg.dem) 
xavg.rep <- is.na(avg.rep)
for (i in 1:nrow(a12)) {
  if (a12$dem[i] == 0) {      # Uncontested w/ no dem
    if (xavg.dem[i]) {        # If no average from prior elections
      a12$rep[i] <- as.integer(avg.turnout[i]*a12$voting.age[i]*.75)  # use avg turnout %
      a12$dem[i] <- as.integer(avg.turnout[i]*a12$voting.age[i]*.25)
    }
    else {
      if (avg.rep[i] > avg.dem[i]) {  # Make sure it's a rep win
        a12$rep[i] <- avg.rep[i]      # and use actual prior avg's
        a12$dem[i] <- avg.dem[i]      # 02-10
      }
      else {           # Don't think shoud happen but use % again
        a12$rep[i] <- as.integer(avg.turnout[i]*a12$voting.age[i]*.75)
        a12$dem[i] <- as.integer(avg.turnout[i]*a12$voting.age[i]*.25)
      }
    }
  }
  else if (a12$rep[i] == 0) {  # Uncontested w/ no rep
    if (xavg.rep[i]) {         # If no rep avg from 02-10    
      a12$dem[i] <- as.integer(avg.turnout[i]*a12$voting.age[i]*.75)   # use avg turnout %
      a12$rep[i] <- as.integer(avg.turnout[i]*a12$voting.age[i]*.25)
    }
    else {
      if (avg.dem[i] > avg.rep[i]) {  # Make sure it's a dem win
        a12$dem[i] <- avg.dem[i]      # and use actual prior avg's
        a12$rep[i] <- avg.rep[i]      # 02-10
      }
      else {            # Don't think should happen but use % again
        a12$dem[i] <- as.integer(avg.turnout[i]*a12$voting.age[i]*.75) # use avg turnout %
        a12$rep[i] <- as.integer(avg.turnout[i]*a12$voting.age[i]*.25)    
      }
    }
  }
}
eg <- quickEfficiencyGap(a12$dem,a12$rep)
eg
```

```
##   X1        X2        X3
## 1 39 0.5170623 -14.01853
## 2 60 0.4829377  14.01853
```

## Reference

### Data

[Wisconsin Data Libarary](http://legis.wisconsin.gov/ltsb/gis/data/)

### Efficiency Gap
[The Most Gerrymandered States Ranked by Efficiency Gap and Seat Advantage](https://www.azavea.com/blog/2017/07/19/gerrymandered-states-ranked-efficiency-gap-seat-advantage/)

### Equal Population Requirement

[Where are the lines drawn?](http://redistricting.lls.edu/where.php)

### Uncontested Counties Imputation

[Partisan Gerrymandering and the Efficiency Gap](https://chicagounbound.uchicago.edu/cgi/viewcontent.cgi?referer=https://www.google.com/&httpsredir=1&article=1946&context=public_law_and_legal_theory)  
Discussion of uncontested and imputation beginning on P. 27.


[2016 Election Results Prove
Gerrymandering](https://urbanmilwaukee.com/2016/12/28/data-wonk-2016-election-results-prove-gerrymandering/)  
Discussion of imputation in the comments.

[Here’s how the Supreme Court could
decide whether your vote will count](https://www.washingtonpost.com/graphics/2017/politics/courts-law/gerrymander/?utm_term=.b3c0a0b9d31d)  
The state map graphics show how frequent uncontested State Assembly elections are in Wisconsin. It seems a major concern when values for almost half of the elections need to be imputed. 

### Efficiency Gap Cautions

[The Flaw in America's 'Holy Grail' Against Gerrymandering](https://www.theatlantic.com/science/archive/2018/01/efficiency-gap-gerrymandering/551492/)

