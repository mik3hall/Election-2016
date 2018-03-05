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
str(w0210)
```

```
## 'data.frame':	6634 obs. of  262 variables:
##  $ OBJECTID_1   : int  3001 3002 3003 3004 3005 3006 3007 3008 3009 3010 ...
##  $ OBJECTID     : int  3001 3002 3003 3004 3005 3006 3007 3008 3009 3010 ...
##  $ GEOID10      : Factor w/ 6634 levels "55001002750001",..: 3001 3002 3003 3004 3005 3006 3007 3008 3009 3010 ...
##  $ NAME         : Factor w/ 6274 levels "Abbotsford - C 1",..: 4032 4033 4034 4331 4332 4343 4344 4345 4346 4347 ...
##  $ ASM          : int  36 36 36 36 36 89 89 89 89 89 ...
##  $ SEN          : int  12 12 12 12 12 30 30 30 30 30 ...
##  $ CON          : int  8 8 8 8 8 8 8 8 8 8 ...
##  $ WARD_FIPS    : Factor w/ 6634 levels "55001002750001",..: 3001 3002 3003 3004 3005 3006 3007 3008 3009 3010 ...
##  $ COUSUBFP     : int  57325 57325 57350 61775 61775 62175 62175 62175 62175 62175 ...
##  $ MCD_NAME     : Factor w/ 1609 levels "Abbotsford","ABRAMS",..: 1024 1024 1025 1103 1103 1111 1111 1111 1111 1111 ...
##  $ MCD_FIPS     : num  5.51e+09 5.51e+09 5.51e+09 5.51e+09 5.51e+09 ...
##  $ CNTY_NAME    : Factor w/ 72 levels "Adams","Ashland",..: 38 38 38 38 38 38 38 38 38 38 ...
##  $ CNTY_FIPS    : int  55075 55075 55075 55075 55075 55075 55075 55075 55075 55075 ...
##  $ PERSONS      : int  712 226 853 625 264 715 499 230 605 295 ...
##  $ WHITE        : int  684 221 840 600 261 697 486 192 589 286 ...
##  $ BLACK        : int  4 0 0 6 0 1 1 0 0 0 ...
##  $ HISPANIC     : int  10 2 4 8 1 12 2 1 4 4 ...
##  $ ASIAN        : int  8 0 5 8 1 0 3 24 6 5 ...
##  $ AMINDIAN     : int  5 2 2 2 1 4 7 12 6 0 ...
##  $ PISLAND      : int  1 0 2 1 0 0 0 0 0 0 ...
##  $ OTHER        : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ OTHERMLT     : int  0 1 0 0 0 1 0 1 0 0 ...
##  $ PERSONS18    : int  516 168 695 503 217 516 360 181 510 218 ...
##  $ WHITE18      : int  501 163 685 485 215 509 351 154 497 212 ...
##  $ BLACK18      : int  1 0 0 1 0 0 0 0 0 0 ...
##  $ HISPANIC18   : int  4 2 2 8 1 6 1 1 3 3 ...
##  $ ASIAN18      : int  4 0 4 6 0 0 1 17 4 3 ...
##  $ AMINDIAN18   : int  5 2 2 2 1 1 7 9 6 0 ...
##  $ PISLAND18    : int  1 0 2 1 0 0 0 0 0 0 ...
##  $ OTHER18      : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ OTHERMLT18   : int  0 1 0 0 0 0 0 0 0 0 ...
##  $ GOVTOT10     : int  185 62 298 260 98 208 137 53 192 76 ...
##  $ GOVDEM10     : int  94 31 126 87 36 83 55 21 74 33 ...
##  $ GOVREP10     : int  91 31 167 170 62 125 82 32 106 43 ...
##  $ GOVLIB10     : int  0 0 0 0 0 0 0 0 5 0 ...
##  $ GOVIND10     : int  0 0 5 1 0 0 0 0 4 0 ...
##  $ GOVIND210    : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ GOVIND310    : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ GOVIND410    : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ GOVSCT10     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ GOVNA_10     : int  0 0 0 2 0 0 0 0 3 0 ...
##  $ SOSTOT10     : int  185 62 327 249 95 203 133 53 162 73 ...
##  $ SOSDEM10     : int  101 33 145 91 36 94 62 24 70 34 ...
##  $ SOSREP10     : int  84 29 182 158 59 109 71 29 92 39 ...
##  $ SOSSCT10     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ TRSTOT10     : int  182 62 324 247 96 198 126 51 171 72 ...
##  $ TRSDEM10     : int  91 31 135 91 36 80 53 21 66 29 ...
##  $ TRSREP10     : int  91 31 189 156 60 118 73 30 105 43 ...
##  $ TRSSCT10     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ USHTOT10     : int  182 62 337 262 96 213 136 54 179 76 ...
##  $ USHDEM10     : int  97 32 154 99 36 96 63 25 79 34 ...
##  $ USHREP10     : int  85 30 183 162 60 117 73 29 100 42 ...
##  $ USHLIB10     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ USHIND10     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ USHSCT10     : int  0 0 0 1 0 0 0 0 0 0 ...
##  $ USSTOT10     : int  183 63 342 260 98 212 137 55 187 75 ...
##  $ USSDEM10     : int  91 31 132 88 36 88 58 23 80 32 ...
##  $ USSREP10     : int  92 32 202 167 62 124 79 32 101 43 ...
##  $ USSREP210    : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ USSIND10     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ USSSCT10     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ USSNA_10     : int  0 0 8 5 0 0 0 0 6 0 ...
##  $ WAGTOT10     : int  185 61 328 248 95 210 133 55 171 74 ...
##  $ WAGDEM10     : int  84 28 120 79 33 72 45 19 57 24 ...
##  $ WAGREP10     : int  101 33 208 169 62 138 88 36 114 50 ...
##  $ WAGSCT10     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ WSATOT10     : int  186 63 334 257 98 212 134 54 182 77 ...
##  $ WSADEM10     : int  91 31 117 81 33 74 46 18 60 27 ...
##  $ WSAREP10     : int  95 32 217 176 65 138 88 36 122 50 ...
##  $ WSAGRN10     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ WSALIB10     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ WSAIND10     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ WSASCT10     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ WSSTOT10     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ WSSDEM10     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ WSSREP10     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ WSSIND10     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ WSSSCT10     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ CDATOT08     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ CDADEM08     : int  177 63 263 181 63 204 139 52 146 74 ...
##  $ CDAREP08     : int  113 40 203 174 62 123 84 32 91 43 ...
##  $ CDAIND08     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ CDASCT08     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ CDAOTH08     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ PRETOT08     : int  297 103 480 372 131 342 227 87 238 121 ...
##  $ PREDEM08     : int  164 59 246 180 65 185 125 47 126 66 ...
##  $ PREREP08     : int  132 46 226 185 66 156 102 40 100 54 ...
##  $ PREGRN08     : int  0 0 0 3 0 0 0 0 3 0 ...
##  $ PRELIB08     : int  0 0 3 0 0 0 0 0 0 0 ...
##  $ PREIND08     : int  0 0 0 1 0 0 0 0 0 0 ...
##  $ PREIND208    : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ PREIND308    : int  0 0 2 2 0 0 0 0 3 0 ...
##  $ PREIND408    : int  0 0 1 1 0 0 0 0 1 0 ...
##  $ PREIND508    : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ PRESCT08     : int  0 0 2 0 0 0 0 0 5 0 ...
##  $ USHTOT08     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ USHDEM08     : int  181 64 274 180 63 181 119 45 129 66 ...
##  $ USHREP08     : int  113 40 204 184 66 156 102 40 101 54 ...
##  $ USHLIB08     : int  0 0 0 0 0 0 0 0 0 0 ...
##   [list output truncated]
```

```r
# For imputation
a0210 <- w0210 %>% group_by(ASM) %>% summarize(dem02 <- sum(WSADEM02), dem04 <- sum(WSADEM04), dem06 <- sum(WSADEM06), dem08 <- sum(WSADEM08), dem10 <- sum(WSADEM10), rep02 <- sum(WSAREP02), rep04 <- sum(WSAREP04), rep06 <- sum(WSAREP06), rep08 <- sum(WSAREP08), rep10 <- sum(WSAREP10), voting.age <- sum(PERSONS18),n())
names(a0210) <- c("ASM","dem02","dem04","dem06","dem08","dem10","rep02","rep04","rep06","rep08","rep10","voting.age","n")
str(a0210)
```

```
## Classes 'tbl_df', 'tbl' and 'data.frame':	99 obs. of  13 variables:
##  $ ASM       : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ dem02     : int  7444 5892 356 7363 6606 1235 11648 3329 7225 13699 ...
##  $ dem04     : int  11892 3545 9898 12454 12613 3777 19168 8854 13490 22356 ...
##  $ dem06     : int  11897 3333 8946 10529 12337 8702 14349 4508 8696 16751 ...
##  $ dem08     : int  15972 15690 12960 13523 17123 11962 17730 8778 12851 25946 ...
##  $ dem10     : int  10657 7952 489 8633 7158 2558 10746 4153 6734 18512 ...
##  $ rep02     : int  14017 10249 11224 12446 8213 11662 2932 0 0 0 ...
##  $ rep04     : int  20339 19407 15250 18745 13726 18962 3027 0 471 1248 ...
##  $ rep06     : int  14670 13274 12487 13901 8398 11864 1185 0 0 0 ...
##  $ rep08     : int  16710 13883 16721 16606 10996 14239 6215 0 0 1957 ...
##  $ rep10     : int  14966 13327 15621 13812 12350 14365 6196 88 395 1740 ...
##  $ voting.age: int  45131 44099 41404 44474 42235 43682 44756 36986 39653 41493 ...
##  $ n         : int  114 66 64 36 80 89 36 27 32 38 ...
```

```r
rows <- nrow(a0210)
a.rep <- data.frame(cbind(rep(NA,rows),rep(NA,rows),rep(NA,rows),rep(NA,rows),rep(NA,rows)))
names(a.rep) <- c("r02","r04","r06","r08","r10")
a.rep[which(a0210$rep02>a0210$dem02 & a0210$dem02 != 0),"r02"] <- a0210[a0210$rep02>a0210$dem02 & a0210$dem02 != 0,"rep02"]
a.rep[which(a0210$rep04>a0210$dem04 & a0210$dem04 != 0),"r04"] <- a0210[a0210$rep04>a0210$dem04 & a0210$dem04 != 0,"rep04"]
a.rep[which(a0210$rep06>a0210$dem06 & a0210$dem06 != 0),"r06"] <- a0210[a0210$rep06>a0210$dem06 & a0210$dem06 != 0,"rep06"]
a.rep[which(a0210$rep08>a0210$dem08 & a0210$dem08 != 0),"r08"] <- a0210[a0210$rep08>a0210$dem08 & a0210$dem08 != 0,"rep08"]
a.rep[which(a0210$rep10>a0210$dem10 & a0210$dem10 != 0),"r10"] <- a0210[a0210$rep10>a0210$dem10 & a0210$dem10 != 0,"rep10"]
avg.rep <- rowMeans(a.rep,na.rm=TRUE)
avg.rep[is.na(avg.rep)] <- 0
table(is.na(avg.rep))
```

```
## 
## FALSE 
##    99
```

```r
a.dem <- data.frame(cbind(rep(NA,rows),rep(NA,rows),rep(NA,rows),rep(NA,rows),rep(NA,rows)))
names(a.dem) <- c("d02","d04","d06","d08","d10")
a.dem[which(a0210$dem02>a0210$rep02 & a0210$rep02 != 0),"d02"] <- a0210[a0210$dem02>a0210$rep02 & a0210$rep02 != 0,"dem02"]
a.dem[which(a0210$dem04>a0210$rep04 & a0210$rep04 != 0),"d04"] <- a0210[a0210$dem04>a0210$rep04 & a0210$rep04 != 0,"dem04"]
a.dem[which(a0210$dem06>a0210$rep06 & a0210$rep06 != 0),"d06"] <- a0210[a0210$dem06>a0210$rep06 & a0210$rep06 != 0,"dem06"]
a.dem[which(a0210$dem08>a0210$rep08 & a0210$rep08 != 0),"d08"] <- a0210[a0210$dem08>a0210$rep08 & a0210$rep08 != 0,"dem08"]
a.dem[which(a0210$dem10>a0210$rep10 & a0210$rep10 != 0),"d10"] <- a0210[a0210$dem10>a0210$rep10 & a0210$rep10 != 0,"dem10"]
avg.dem <- rowMeans(a.dem,na.rm=TRUE)
avg.dem[is.na(avg.dem)] <- 0
table(is.na(avg.dem))
```

```
## 
## FALSE 
##    99
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
  a12 <- w11 %>% group_by(ASM) %>% summarize(dem <- sum(WSADEM12), dem2 <- sum(WSADEM212), rep <- sum(WSAREP12), rep2 <- sum(WSAREP212), voting.age <- sum(PERSONS18),n())
  names(a12) <- c("asm","dem","dem2","rep","rep2","voting.age","n")
  head(a12)
```

```
## # A tibble: 6 x 7
##     asm   dem  dem2   rep  rep2 voting.age     n
##   <int> <int> <int> <int> <int>      <int> <int>
## 1     1 16124     0 16993     0      45131   114
## 2     2 12036     0 17086     0      44099    66
## 3     3 11397     0 17387     0      41404    64
## 4     4 12767     0 16025     0      44474    36
## 5     5 12709     0 16117     0      42235    80
## 6     6 10508     0 15423     0      43682    89
```

```r
  table(a12$dem == 0)
```

```
## 
## FALSE  TRUE 
##    95     4
```

```r
  uncontested <- a12[a12$dem == 0 | a12$rep == 0,]
  uncontested
```

```
## # A tibble: 22 x 7
##      asm   dem  dem2   rep  rep2 voting.age     n
##    <int> <int> <int> <int> <int>      <int> <int>
##  1     7 16664  2499     0     0      44756    36
##  2     8  7869     0     0     0      36986    27
##  3     9 14635     0     0     0      39653    32
##  4    10 20038     0     0     0      41493    38
##  5    12 16193     0     0     0      40095    26
##  6    16 16881     0     0     0      41985    31
##  7    18 16276     0     0     0      40368    33
##  8    19 24856     0     0     0      53394    29
##  9    22     0     0 24006     0      43741    42
## 10    40     0     0 21127     0      45049   104
## # ... with 12 more rows
```

```r
  mean(uncontested$voting.age)
```

```
## [1] 44017.95
```

```r
  sd(uncontested$voting.age)
```

```
## [1] 3989.02
```

```r
  avg.turnout <- (a12$dem+a12$dem2+a12$rep+a12$rep2)/a12$voting.age
  # Imputing Uncontested
  # should be party average from 02-10 * avg.turnout (if party avg)
  #           loser getting avg.turnout - that
  # if no party avg loser gets 25% avg.turnout, winner the rest
  #
  # First assume prior years cover all - then recheck
  table(a12$dem==0)
```

```
## 
## FALSE  TRUE 
##    95     4
```

```r
  table(is.na(a12$dem))
```

```
## 
## FALSE 
##    99
```

```r
  for (i in 1:nrow(a12)) {
    if (a12$dem[i] == 0) {
      cat(i,"dem",avg.dem[i],avg.turnout[i],"\n")
      str(avg.dem)
      str(avg.turnout)
      a12$dem[i] <- avg.dem[i] * avg.turnout[i]
      a12$rep[i] <- avg.turnout[i] - a12$dem[i]
    }
    else if (a12$rep[i] == 0) {
      cat(i,"rep","\n")
      a12$rep[i] <- avg.rep[i] * avg.turnout[i] 
      a12$dem[i] <- avg.turnout[i] - a12$rep[i]
     }
  }
```

```
## 7 rep 
## 8 rep 
## 9 rep 
## 10 rep 
## 12 rep 
## 16 rep 
## 18 rep 
## 19 rep 
## 22 dem 0 0.5488215 
##  num [1:99] 0 15690 0 0 14730 ...
##  num [1:99] 0.734 0.66 0.695 0.647 0.683 ...
## 40 dem 0 0.4689782 
##  num [1:99] 0 15690 0 0 14730 ...
##  num [1:99] 0.734 0.66 0.695 0.647 0.683 ...
## 58 dem 20020 0.6188362 
##  num [1:99] 0 15690 0 0 14730 ...
##  num [1:99] 0.734 0.66 0.695 0.647 0.683 ...
## 59 dem 0 0.5697472 
##  num [1:99] 0 15690 0 0 14730 ...
##  num [1:99] 0.734 0.66 0.695 0.647 0.683 ...
## 64 rep 
## 65 rep 
## 66 rep 
## 73 rep 
## 76 rep 
## 77 rep 
## 78 rep 
## 79 rep 
## 91 rep 
## 95 rep
```

```r
  table(a12$dem==0)
```

```
## 
## FALSE  TRUE 
##    96     3
```

```r
  table(is.na(a12$dem))
```

```
## 
## FALSE 
##    99
```

```r
#  a.rep <- w0210 %>% group_by(ASM) %>% summarize(dem <- #sum(WSADEM02+WSADEM04+WSADEM06+WSADEM08+WSADEM10), rep <- #sum(WSAREP02+WSAREP04+WSAREP06+WSAREP08+WSAREP10))
#  contested <- a12[a12$dem != 0 & a12$rep != 0,]
#  contested.d <- a12[a12$dem>a12$rep & a12$]
#  max((contested$dem-contested$rep)/(contested$dem+contested$rep))
  table(a12$rep == 0)
```

```
## 
## FALSE  TRUE 
##    82    17
```

```r
  table(is.na(a12$rep))
```

```
## 
## FALSE 
##    99
```

```r
#  max((contested$rep-contested$dem)/(contested$dem+contested$rep))
#  a12 <- a12[a12$dem != 0 & a12$rep != 0,]
  eg <- quickEfficiencyGap(a12$dem,a12$rep)
  eg
```

```
##   X1        X2        X3
## 1 39 0.4808542 -6.776904
## 2 60 0.5191458  6.776904
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
