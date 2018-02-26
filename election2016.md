---
title: "Election 2016"
author: "Mike Hall"
date: "2/24/2018"
output:
  html_document:
    keep_md: true
---





## Introduction

A recent news program discussion of gerrymandering got me interested in number
crunching election data. There was a recent metric developed for legally establishing gerrymandering - [Partisan Gerrymandering and the Efficiency Gap](https://chicagounbound.uchicago.edu/cgi/viewcontent.cgi?referer=https://duckduckgo.com/&httpsredir=1&article=1946&context=public_law_and_legal_theory). 

I may consider if that has any bearing here but it doesn't seem immediately likely. My main interest will be the 2016 presidential election. Obviously in a presidential election gerrymandering isn't a concern. Getting data on these things can be difficult. But through a variety of sources I was able to get presidential election results by county for '04 to '16. Having it at the county level might give large enough sample sizes so some statistics methods could make sense.


```r
data04 <- read.csv("county04.csv")
data08 <- read.csv("county08.csv")
data12 <- read.csv("county12.csv")
data16 <- read.csv("county16.csv")
```

Different sources seemed to slightly differ from other sources. But I believe the
results are correct enough for my purposes. For example...


```r
diff16 <- data16$dem.Count16 - data16$gop.Count16
sum(diff16)
```

```
## [1] 1348693
```

Shows a democratic popular vote win of a million plus. [This page](https://en.wikipedia.org/wiki/United_States_presidential_elections_in_which_the_winner_lost_the_popular_vote#2016:_Donald_Trump) indicates that this should actually be 2,868,691. Out of 62,984,825 total votes I consider getting the correct result and this close as accurate enough.

There has been considerable discussion of how Trump found his way through to a 
Electoral college win despite this. Talk of Russian hacker interference and Wikileaks, also the Comey letter. Mainly, the conventional wisdom seems to be that the Democrats simply didn't reach the voters that they had to have. What I am mainly would like to consider is what the numbers might tell us about how this result was reached.

## Simple probability and counting - Party flipping by county

To begin with I am going to ignore actual vote total and just count up counties flipping and compare 2016 to earlier years concerning the probabilities of counties flipping. I represent a county flipping parties as (1 = Rep->Dem,0 = no change, or -1 = Dem->Rep). See the flips.csv dataset.  



From election to election...

```
## 2008
```

```
## 
##   -1    0    1 
##   47 2734  339
```

```
## 2012
```

```
## 
##   -1    0    1 
##  199 2911   10
```

```
## 2016
```

```
## 
##   -1    0    1 
##  218 2882   20
```
It can be seen that there was a big shift in counties from Republican to Democrat in the 2008 election. This might of been 'making a statement' votes against a unpopular Bush presidency or it could of been the historic Obama candidacy. For whatever reason it was a major shift. 

This trend did not continue. Already in the 2012 election many more counties were reverting to Republican. Was this what is known in statistics as [Reversion to the mean?](https://en.wikipedia.org/wiki/Regression_toward_the_mean). Normally Republican tending counties voting more as usual? Or something else? Maybe a reversal that the Democrats should of already been aware of for the 2016 election? 

In the 2016 election counties continued flipping to Republican, only even more so. The last two elections more than reversed the Democrat county gains from 2008.

The overall probability that a random county might flip...

```
## [1] 0.08899573
```

So there has been about a 9% chance over the last 3 presidential elections that a random county will flip from it's party vote for the prior election. This is actually higher than I thought it would be.

That is the percentage across the country with all things being equal. But they are not equal, some states are party base states while others are considered swing states. The probability a county might flip from state to state can be considerably different.

The probabilites of a county flipping by state... 

```
## Top 10 highest probability party flipping states
```

```
##    states     sdata
## 48     WI 0.3611111
## 30     NH 0.3333333
## 22     MI 0.2771084
## 12     IA 0.2289562
## 8      DE 0.2222222
## 14     IL 0.2156863
## 34     NY 0.2043011
## 23     MN 0.1954023
## 21     ME 0.1875000
## 47     WA 0.1538462
```

```
## Top 10 lowest probability party flipping states
```

```
##    states       sdata
## 50     WY 0.028985507
## 13     ID 0.022727273
## 18     LA 0.020833333
## 43     TX 0.019685039
## 16     KS 0.006349206
## 3      AZ 0.000000000
## 7      DC 0.000000000
## 11     HI 0.000000000
## 19     MA 0.000000000
## 36     OK 0.000000000
```
Somewhat interestingly, in checking the Top 10 states Clinton seems to have taken 7 of them for a significant 80 to 32 point lead in electoral college votes. Maybe a little interesting is that five states had no counties flip at all in the last three elections. Again, states can be considerably different.

Two states commonly talked about as important swing states are Florida and Ohio. Their probabilities for county flipping are...


```
## Florida
```

```
##   states      sdata
## 9     FL 0.04975124
```

```
## Ohio
```

```
##    states      sdata
## 35     OH 0.07954545
```

Neither is very high, Florida is actually fairly low with less than 5%. But both states flipped Republican from the 2012 election for a total of 47 electoral college votes. 

Although the election to election numbers seemed significant for showing trends for my purposes it might make more sense to consider the states that flipped in 2016 and then drill down into their counties to see why. Or, the county flipping analysis is just too simplistic and actual vote tallies and possible unusual turnout need to be taken into account. 

All things being equal doesn't apply to states and it doesn't to counties either. The Demcrat base counties tend to be urban and more highly populated than Republican. The number of Republican counties greatly exceeds the number of Democrat ones. 

Over the last four elections the percentage of counties voting Republican was...

```
## [1] 0.7867788
```

With the above mentioned trend in county flipping after the 2016 election this was...

```
## [1] 0.8410256
```

And Clinton won on popular vote. Clearly she had wasted votes, this is what the gerrymandering "efficiency gap" is based on. Maybe it is a measure that can apply without gerrymandering. One consequence of this would seem to be that when a Democrat county flips it means more votes lost, on average, than when a Republican county flips. All things and all counties not being equal.

If I continue to update this I will attempt to consider these other factors.

******

## 2016

Taking things to the state level since this is where the electoral college votes are. We might ask at this level, what states flipped between 2012 and 2016?


```
##   State EV pop2010  dem12   rep12  dem16   rep16
## 1    AL  9 4779736 795696 1255925 729547 1318255
```

```
## 
## -1  0 
##  6 44
```

You can see that six states flipped from Democrat to Republican, the rest all stayed the same, with no Republican states flipping to Democrat ones.

What were the six states that flipped Republican?


```
##    State EV diff.12 diff.16
## 9     FL 29   74309 -112911
## 15    IA  6   91927 -147314
## 22    MI 16  449313  -10704
## 35    OH 18  166272 -446841
## 38    PA 20  309840  -44292
## 49    WI 10  213019  -22748
```

These are the only six states. They decided the election. All other states had the same result as in 2012. 

How many electoral votes did these states account for?


```
## [1] 99
```

Romney had 206 in in 2012, adding in the 99 gives Trump a definite win. It probably could of taken a couple less than the six for the win, if you want to figure that out. Then you could possibly say the remaining were actually the only states that had mattered.

However, for what follows I will consider each of the six that flipped.

## Florida

The Republican margin of victory in the state was...

```
## [1] 112911
```

For seeing what happened in Florida I will go back to the county level and see what the flipped counties look like just for this state.


```
## 
## -1  0 
##  4 63
```

There are only four counties that flipped to Republican this election.


```
##   flipped.fl diff12.fl diff16.fl
## 1  Jefferson       137      -393
## 2     Monroe       158     -2936
## 3   Pinellas     25774     -5419
## 4  St. Lucie      9667     -3436
```

The vote swings for the four flipped counties account for only a portion of the Republican margin of victory. The rest has to be other counties where the Republican vote outperformed or the Democrat vote underperformed. It may not be state wide but it does have to involve more than the flipped counties.

Consider the average party results for the 2012 and 2016 elections for state wide.


```
##   V1 mean.d12 mean.r12 mean.d16 mean.r16
## 1 FL    82043    73109 80656.25 83702.25
```

So statewide the Democrat vote tallies are on average down while the Republican tallies are up on average. Is this really statewide or can some smaller subset of counties be identified that swung the election?

## Iowa

## Michigan

## Ohio

## Pennsylvania

## Wisconsin




