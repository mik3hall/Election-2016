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
## [1] "112911 (1.24%)"
```


```
## Florida Voter Turnout
```

```
##        2004    2008    2012    2016
## Dem 3583544 4282367 4235270 4485745
## Gop 3964522 4046219 4162081 4605515
## Tot 7548066 8328586 8397351 9091260
```

I had originally thought there might be some way to differentiate between new voters turning out and voters switching parties in their voting. Here the number of Democrat voters increases as well as the Republican ones. It is difficult to say that they had voters changing parties. But there really is no way to know. 

Turnout across the election years will still be provided as an indication of voter motivation in the election.

For seeing what happened in Florida I will first go back to the county level and see what the flipped counties look like just for this state.


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

The vote swings for the four flipped counties account for only a portion of the Republican margin of victory. The rest has to be other counties where the Republican vote outperformed or the Democrat vote underperformed. It may not be statewide but it does have to involve more than the flipped counties.

Consider the average party results for the 2012 and 2016 elections for statewide.


```
##   V1 mean.d12 mean.r12 mean.d16 mean.r16
## 1 FL    82043    73109 80656.25 83702.25
```

So statewide the Democrat vote tallies are on average down while the Republican tallies are up on average. Is this really statewide or can some smaller subset of counties be identified that swung the election?

From the averages it seems that Republican gains were more a factor than Democrat losses in voter turnout. But I will consder both, which were the biggest county gainers and which had the largest losses?

Looking at the Top 10 gains for each party...


```
## Top 10 Democrat county gains
```

```
##           names diff.d16
## 43   Miami-Dade    82230
## 48       Orange    55352
## 6       Broward    39526
## 50   Palm Beach    21993
## 28 Hillsborough    20264
## 49      Osceola    18086
## 35          Lee    14645
## 11      Collier     9263
## 57     Seminole     9176
## 58    St. Johns     7882
```

```
## Top 10 Republican county gains
```

```
##           names diff.r16
## 35          Lee    37029
## 51        Pasco    29608
## 53         Polk    25650
## 52     Pinellas    25554
## 64      Volusia    25290
## 50   Palm Beach    23505
## 5       Brevard    22350
## 40      Manatee    16065
## 28 Hillsborough    16024
## 6       Broward    14789
```

You can see that for the first three counties the Democrats did very well. This would be in their more urban, highly populated base. After that the Republican gains start being greater, this begins with Pinellas which you might remember was one of the counties that actually flipped between 2012 and 2016. 

In table form...


```
## Democrat gains greater than Republican gains
```

```
## 
## FALSE  TRUE 
##     3    64
```

Counties where the Republicans out-gained the Democrats number 64 to 3. 

If the gains are totaled up...


```
## Total Democrat gains between 2012 and 2016
```

```
## [1] 250475
```

```
## Total Republican gains between 2012 and 2016
```

```
## [1] 443434
```

Both parties gained votes in 2016. You can't really even say that the Democrats underperformed. It's just that the Replubicans very considerably outperformed across the state. There is no key subset of counties for the Democrats to address. They need statewide improvement or less Republican improvement. 

## Iowa

The Republican margin of victory in the state was...

```
## [1] "147314 (10.13%)"
```


```
## Iowa Voter Turnout
```

```
##        2004    2008    2012    2016
## Dem  741898  828940  816429  650790
## Gop  751957  682379  727928  798923
## Tot 1493855 1511319 1544357 1449713
```

Flipped counties...


```
## 
## -1  0 
## 31 68
```

Many counties actually flipped here, almost half.  


```
##     flipped.ia diff12.ia diff16.ia
## 1    Allamakee       281     -1663
## 2        Boone       917     -1941
## 3       Bremer       327     -1850
## 4     Buchanan      1460     -1538
## 5        Cedar       421     -1697
## 6  Cerro Gordo      3120     -1743
## 7    Chickasaw       716     -1475
## 8       Clarke        63     -1243
## 9      Clayton       622     -2073
## 10     Clinton      5700     -1170
## 11  Des Moines      3743     -1301
## 12     Dubuque      7335      -610
## 13     Fayette      1225     -1925
## 14       Floyd      1208     -1194
## 15      Howard       974      -937
## 16     Jackson      1706     -1984
## 17      Jasper      1372     -3448
## 18   Jefferson      1343       -36
## 19       Jones       802     -1939
## 20         Lee      2641     -2567
## 21      Louisa        33     -1417
## 22    Marshall      1674     -1502
## 23    Mitchell       188     -1301
## 24   Muscatine      3061     -1265
## 25   Poweshiek       898      -664
## 26        Tama       661     -1774
## 27       Union       229     -1601
## 28     Wapello      1839     -3119
## 29     Webster      1005     -3756
## 30  Winneshiek      1627       -94
## 31       Worth       600      -920
```

I don't know if I have the data to indicate whether this result is more unusual or that the state favored the Democrat Barack Obama as it did. But based only on the data I have, while not having the most electoral votes, it is clear that for this election the Democrat candidate underperformed badly.

## Michigan

The Republican margin of victory in the state was...

```
## [1] "10704 (0.24%)"
```

Very close.


```
## Michigan Voter Turnout
```

```
##        2004    2008    2012    2016
## Dem 2479183 2872579 2561911 2268193
## Gop 2313746 2048639 2112673 2279805
## Tot 4792929 4921218 4674584 4547998
```

Flipped counties...


```
## 
## -1  0 
## 12 71
```

And which ones...


```
##    flipped.mi diff12.mi diff16.mi
## 1         Bay      3062     -6686
## 2     Calhoun       932     -7335
## 3       Eaton      1719     -3074
## 4     Gogebic       614     -1094
## 5    Isabella      2238      -934
## 6        Lake       265     -1220
## 7      Macomb     16096    -48351
## 8    Manistee       731     -1936
## 9      Monroe       717    -16396
## 10    Saginaw     11656     -1074
## 11 Shiawassee      1235     -6685
## 12  Van Buren       148     -4632
```

Leaning Republican.

The overall averages...


```
##   V1 mean.d12 mean.r12 mean.d16 mean.r16
## 1 MI 36871.08 33586.67 30406.08 38690.83
```

More of a Democrat loss than Florida but not as much in Republican gains. But both again favor the Republicans.

The Top 10 gains for each party...


```
## Top 10 Democrat county gains
```

```
##             names diff.d16
## 81      Washtenaw     7234
## 41           Kent     4007
## 70         Ottawa     3208
## 33         Ingham      363
## 45       Leelanau      198
## 28 Grand Traverse       89
## 42       Keweenaw      -55
## 24          Emmet     -253
## 48           Luce     -270
## 66      Ontonagon     -410
```

```
## Top 10 Republican county gains
```

```
##         names diff.r16
## 50     Macomb    32693
## 82      Wayne    15322
## 25    Genesee    12367
## 77  St. Clair     9991
## 58     Monroe     7662
## 44     Lapeer     6312
## 47 Livingston     5665
## 61   Muskegon     5080
## 3     Allegan     4789
## 9         Bay     4592
```

The Democrats managed gains in only six counties. They didn't do as well as in Florida in hanging onto their base, even losing ground in Macomb county which appears to be part of metro Detroit. A more high population Democrat type county. 

The loss seems statewide again. Although more due to the Democrat's not doing as well as they might of rather than large scale Republican outperforming. This state could easily of gone Democrat. Macomb county alone would of given it to them if they had hung onto it.

## Ohio

The Republican margin of victory in the state was...

```
## [1] "446841 (8.54%)"
```

A big Republican win.


```
## Ohio Voter Turnout
```

```
##        2004    2008    2012    2016
## Dem 2739952 2940044 2697260 2317001
## Gop 2858727 2677820 2593779 2771984
## Tot 5598679 5617864 5291039 5088985
```

Flipped counties...


```
## 
## -1  0 
##  9 79
```

Which ones...


```
##   flipped.oh diff12.oh diff16.oh
## 1  Ashtabula      5074     -7564
## 2       Erie      4314     -3609
## 3     Lorain     20017      -388
## 4 Montgomery      7795     -3105
## 5     Ottawa       891     -4253
## 6    Portage      3617     -7515
## 7   Sandusky       544     -6312
## 8   Trumbull     21901     -6022
## 9       Wood      2599     -5294
```

The overall averages...


```
##   V1 mean.d12 mean.r12 mean.d16 mean.r16
## 1 MI 45044.56 37627.67 36822.67 41718.44
```

A large Democrat decline and moderate Republican gains.

The Top 10 gains for each party...


```
## Top 10 Democrat county gains
```

```
##       names diff.d16
## 25 Franklin    10307
## 21 Delaware     3453
## 83   Warren     1129
## 38   Holmes     -802
## 27   Gallia     -854
## 61    Noble     -881
## 31 Hamilton     -921
## 80    Union    -1016
## 82   Vinton    -1050
## 58   Morgan    -1061
```

```
## Top 10 Republican county gains
```

```
##         names diff.r16
## 50   Mahoning    11106
## 78   Trumbull    10607
## 76      Stark     9387
## 47     Lorain     7251
## 15 Columbiana     6308
## 48      Lucas     6002
## 45    Licking     5742
## 43       Lake     5477
## 4   Ashtabula     4865
## 60  Muskingum     4762
```

It was a little difficult for me to understand how the numbers I'm getting accounted for the large Republican margin of victory. But with almost every county statewide shifting more Republican, and each Republican gain representing a Democrat loss, it seems that it does. 

## Pennsylvania

The Republican margin of victory in the state was...

```
## [1] "44292 (0.75%)"
```


```
## Pennsylvania Voter Turnout
```

```
##        2004    2008    2012    2016
## Dem 2938095 3276363 2907448 2844705
## Gop 2793847 2655885 2619583 2912941
## Tot 5731942 5932248 5527031 5757646
```

Flipped counties...


```
## 
## -1  0  1 
##  3 62  2
```

A couple actually flipped to Democrat.

Which ones flipped...


```
##    flipped.pa diff12.pa diff16.pa
## 1      Centre       -20      1456
## 2     Chester     -1048     24606
## 3        Erie     19034     -2348
## 4     Luzerne      6005    -26054
## 5 Northampton      5772     -5448
```

The overall averages...


```
##   V1 mean.d12 mean.r12 mean.d16 mean.r16
## 1 PA 70006.60 64058.00 69790.60 71348.20
```

The Democrats lost hardly anything at all but the Republicans posted decent gains.

The Top 10 gains for each party...


```
## Top 10 Democrat county gains
```

```
##           names diff.d16
## 46   Montgomery    23502
## 15      Chester    17956
## 2     Allegheny    14866
## 9         Bucks     6263
## 23     Delaware     4364
## 51 Philadelphia     3518
## 36    Lancaster     2958
## 14       Centre     2878
## 48  Northampton      922
## 21   Cumberland      299
```

```
## Top 10 Republican county gains
```

```
##           names diff.r16
## 40      Luzerne    19539
## 67         York    15357
## 51 Philadelphia    13578
## 35   Lackawanna    13372
## 65 Westmoreland    12998
## 6         Berks    12237
## 48  Northampton    12142
## 54   Schuylkill    11781
## 25         Erie    11066
## 26      Fayette     8543
```

The Democrats did well in the top spots. These appear from Wikipedia to be somewhat typical base counties for them, highly populated and in the case of Chester high income. But getting past the first three places the Republican gains again take over in being better than the Democrat ones. Actually, even Philidelphia county itself shows superior Republican gains so Democrats were not entirely successful in preserving their base.

## Wisconsin

The Republican margin of victory in the state was...

```
## [1] "22748 (0.82%)"
```

Again, pretty close.


```
## Wisconsin Voter Turnout
```

```
##        2004    2008    2012    2016
## Dem 1489504 1677211 1613950 1382210
## Gop 1478120 1262393 1408746 1409467
## Tot 2967624 2939604 3022696 2791677
```

Flipped counties...


```
## 
## -1  0 
## 22 50
```

Which ones flipped...


```
##     flipped.wi diff12.wi diff16.wi
## 1        Adams       894     -2203
## 2      Buffalo       217     -1518
## 3     Columbia      4144      -635
## 4     Crawford      1558      -418
## 5         Door      1229      -558
## 6         Dunn      1093     -2462
## 7       Forest       249     -1204
## 8        Grant      3319     -2300
## 9      Jackson      1397     -1086
## 10      Juneau       837     -3088
## 11     Kenosha      9896      -255
## 12   Lafayette      1221      -689
## 13     Lincoln        99     -3030
## 14   Marquette       354     -1904
## 15       Pepin        82      -883
## 16       Price         3     -1891
## 17      Racine      3714     -4114
## 18    Richland      1389      -444
## 19      Sawyer        46     -1779
## 20 Trempealeau      1898     -1725
## 21      Vernon      2096      -643
## 22   Winnebago      3337     -6393
```

The overall averages...


```
##   V1 mean.d12 mean.r12 mean.d16 mean.r16
## 1 WI 12237.05 10461.05  9504.32 11287.14
```

Fairly small both ways, but Democrat losses and Republican gains.

The Top 10 gains for each party...


```
## Top 10 Democrat county gains
```

```
##        names diff.d16
## 13      Dane     2117
## 68  Waukesha     1582
## 46   Ozaukee     1092
## 40 Menominee     -188
## 19  Florence     -286
## 26      Iron     -510
## 47     Pepin     -530
## 21    Forest     -838
## 7    Burnett    -1033
## 6    Buffalo    -1038
```

```
## Top 10 Republican county gains
```

```
##        names diff.r16
## 45 Outagamie     4285
## 56      Sauk     3042
## 43    Oconto     2564
## 9   Chippewa     2541
## 5      Brown     2454
## 37  Marathon     2442
## 38 Marinette     2386
## 3     Barron     2182
## 22     Grant     2092
## 69   Waupaca     2024
```

The familiar pattern of very few Democrat gains but consistent Republican ones. It wasn't a big margin of victory but no county stands out here as one that might of swung the state.

******

## Voter Turnout

Overall voter turnout.


```
## Overall Voter Turnout
```

```
##          2004      2008      2012      2016
## Dem  58789456  69373764  62228082  62411041
## Gop  61711414  59756255  58772655  61062348
## Tot 120500870 129130019 121000737 123473389
```

2016 was the second best of the four elections for both parties. Democrats better than Republican, again they had the popular vote edge.

## Swing States

Swing states are still of interest to me. Again, Florida and Ohio are frequently discussed as swing states and both are included above. The six critical states for 2016, in hindsight, compared to the 2012 election. But how well can you tell for 2020 who the critical battleground states will be? 

It seemed to me that are some similarites here to finance. In finance risk is measured as volatility. How extremely do prices, or whatever, swing up and down? I did some checking for anything related to elections and volatility. I came across the [Pedersen Index](https://en.wikipedia.org/wiki/Pedersen_index). But this mainly seems concerned with volatility between multiple parties in European elections. Not regional volatility in a two party system. Not useful for my purposes.

Somewhat interesting again is efficiency gap for gerrymandering almost seems to relate. Looking at this [Washington Post article](https://www.washingtonpost.com/graphics/2017/politics/courts-law/gerrymander/), specifically towards the bottom, the graphic where it says "Some swing states have low scores". You will notice that four of our six states of interest are in the bottom 10 and Pennsylvania and Iowa aren't that much higher.

After some thought it seemed to me that what I am interested in is the probability that a state will swing. With 'P' indicating probability that seemed like it should be...

P(swing) = P(moves right way)*P(moves enough to swing)

With...

P(moves the right way) = # of times voted for that party/times voted

P(moves enough) = # of times moved enough/times moved

There again seems to be a question of how is sample size worked to give meaningful statistics. At the state or individual county level there might not be enough data. Possibly it can be summed across counties somehow for the state? But then don't number of votes have to also be accounted for, something like [Effect size](https://en.wikipedia.org/wiki/Effect_size). How much does each county contribute to the possibility that the state flips?

## Competitiveness

To begin with I will consider something a little simpler, party margin of victory as a percentage as shown above for the six states. This could relate to the probabilities above as one measure of the distance that needs to be moved for a state to flip. It can be seen standalone as a measure of how competitive the state is. The smaller the percentage, the more it is competitive. Possibly, a rough metric of how likely it is a swing state itself.


```
##    State Percentage
## 22    MI      -0.24
## 38    PA      -0.75
## 49    WI      -0.82
## 9     FL      -1.24
## 33    NC      -3.81
## 10    GA      -5.32
## 35    OH      -8.54
## 43    TX      -9.43
## 15    IA     -10.13
## 40    SC     -14.92
```

Four of our six critical states head the list. The other two make the Top 10 list. Not too bad a metric itself, and very simple. All negative meaning Republican.
