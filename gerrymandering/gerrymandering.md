---
title: "Gerrymandering"
author: "Mike Hall"
date: "3/3/2018"
output:
  html_document:
    keep_md: true
---





## Gerrymandering

States have requirements for their political districts that they must maintain. These include having equal populations and the districts should address VRA, the Voting Rights Act, issues to ensure fairness to minorities. To accomplish this the states must <mark>redistrict</mark> shortly after a census takes place. It has become more and more of a concern that states are trying to rig this process to gain more elected representatives than they should fairly have. Arranging districts for this purpose is called <mark>Gerrymandering</mark>, it is illegal. 

However, courts have maintained that they have no clear criteria to determine if Gerrymandering has actually been done. One such criteria that has been proposed is the <mark>Efficiency Gap</mark>, which will be considered here. One court case in particular was of interest to me. Gill v. Whitford, out of my home state of Wisconsin, prominently using the Efficiency Gap metric, and it was the case that has the Supreme Court itself reconsidering Gerrymandering.    





Considering the original Efficiency Gap paper "Partisan Gerrymandering and the Efficiency Gap", referenced below. 

Two methods are indicated for computing the Efficiency Gap. One is based on totaling up all wasted votes, the other is based on seat and vote share margins. The second is algebraically derived from the first under certain assumptions.  

> <chunk style="font-size:15px">Instead, if we assume that all districts are <mark>equal in population</mark> (which is constitutionally required), and that there are <mark>only two parties</mark> (which is typical in SMD systems)</chunk>

Where <mark>SMD is single member district</mark>, meaning that each district has a single representative. The later is indicated as a possibly easier way to compute the EG (efficiency gap) without having to total up all the wasted votes. With R and the Wisconsin data provided (see Data in references - very complete), neither way really seems that much easier. 

I will follow the convention from "THE MEASURE OF A METRIC: THE DEBATE OVER QUANTIFYING PARTISAN GERRYMANDERING" of referring to them as the <mark>full</mark> efficiency gap or <mark>simple</mark> efficiency gap calculations.

Here are my Efficiency Gap calculations for the Wisconsin State Assembly elections for 2012 and 2014.

### 2012


```
## Wisconsin 2012 State Assembly 'simple' Efficiency Gap calculation
```

```
##     Seats Vote Share Efficiency Gap
## Dem    39  0.5170623      -14.01853
## Rep    60  0.4829377       14.01853
```

```
## Wisconsin 2012 State Assembly 'full' Efficiency Gap calculation
```

```
## [1] -19.37371
```

### 2014


```
## Wisconsin 2014 State Assembly 'simple' Efficiency Gap calculation
```

```
##     Seats Vote Share Efficiency Gap
## Dem    36  0.4791253      -9.461425
## Rep    63  0.5208747       9.461425
```

```
## Wisconsin 2014 State Assembly 'full' Efficiency Gap calculation
```

```
## [1] -12.01769
```

I believe the Washington Post article "Here’s how the Supreme Court could
decide whether your vote will count" (see below) mixes up the Efficiency Gap calculations for 2012 and 2014. That indicated that the numbers for these years were provided by Simon Jackman. He appears to have done these calculations for the Wisconsin gerrymandering court case. 

From "Assessing the Current Wisconsin State Legislative Districting Plan" - link below.

> <chunk style="font-size:15px">8. The current Wisconsin state legislative districting plan (the “Current Wisconsin Plan”). In Wisconsin in 2012, the average Democratic share of district level, two-party vote (V) is estimated to be 51.4% (±0.6, the uncertainty stemming from imputations for uncontested seats); recall that Obama won 53.5% of the two-party presidential vote in Wisconsin in 2012. Yet Democrats won only 39 seats in the 99 seat legislature (S = 39.4%), making Wisconsin one of 7 states in 2012 where we estimate V > 50% but S < 50%. In Wisconsin in 2014, V is estimated to be 48.0% (±0.8) and Democrats won 36 of 99 seats (S = 36.4%).</chunk>

> <chunk style="font-size:15px">9. Accordingly, <mark>Wisconsin’s EG measures in 2012 and 2014 are large and negative: -.13 and -.10</mark> (to two digits of precision). The 2012 estimate is the largest EG estimate in Wisconsin over the 42 year period spanned by this analysis (1972-2014).</chunk>

Obama's results are mentioned because this assessment uses the "uniform swing", based on the presidential election, imputation method for missing (uncontested) districts. I attempted imputation based on past results from 2002-2010. Having the data and R to do the calculations, basing the imputation on actual past elections for the same sort of election seemed better. Although, I have seen other mention of presidential election "uniform swing" based imputation. 

So, we see that Jackman's numbers for these years are the reverse of what the Washington Post article indicates. Maybe not a big difference unless you want to compare your own calculations to what is shown. For 2012 Jackman actually got the -.13, where I get -14.01853. The difference is probably due to vote shares. For 2012 Jackman gives "51.4% (±0.6, the uncertainty stemming from imputations for uncontested seats);" whereas, as shown above, I get 0.5170623 for 2012 using a different imputation determination. The same for 2014 where our results are similar but not exact matches.

This also means that Jackman used the 'simple' caluclation method. I also did the 'full' vote calculation getting -19.37371. A very different, and worse, result. 

I thought that the assumptions made by the 'simple' method not actually applying here might be the reason it gives less accurate results. One thing that I thought might be a problem is the "equal population" assumption when given varying voter turnout. 

First I came up with some simple tests to verify the correctness of my 'full' calculation of EG.


```
## -- Equal Populations --
## full   data 1 -0.202 
## simple data 1 -20 
## full   data 2 0.398 
## simple data 2 39.2
```

With equal populations the 'simple' and 'full' EG calcuations give essentially the same results. So my 'full' calculations should be more or less correct.

Now it can be tested to see the results stay the same if the voter turnout is varied...


```
## -- Vary voter turnout --
## full   data 3 -0.1595 
## simple data 3 -23.2
```
Turnouts for both parties are proportionately varied to be respectively 100%, 90%, 80%, 70% or 60% of their initial values. You can see that this results in the final numbers being significantly different.

Some of the issues that have been raised against the Efficiency Gap are addressed in "THE MEASURE OF A METRIC: THE DEBATE OVER QUANTIFYING PARTISAN GERRYMANDERING". In that we find...

> <chunk style="font-size:15px"> If turnout is assumed to be equal, the “simplified form” of the efficiency gap can be used: (S – 0.5) – 2 × (V – 0.5), where S is a party’s statewide seat share and V is the party’s vote share averaged across all districts. <mark>To take into account district-level variations in </mark><mark style="background-color:red;">turnout</mark>, <mark>the “full form” of the efficiency gap <mark style="background-color:red;">must</mark> be used instead</mark>.</chunk>

So, there is agreement from the gap creators. The full calculation <mark style="background-color:red;">must</mark> be used with voter turnout. The assessment that Simon Jackman did for the Wisconsin court case had great scope across many states and years. Using the 'simple' calculation must of seemed to be a considerable convenience. But I think it was a mistake. For any serious consideration of Efficiency Gap in real elections where there is considerable variance in voter turnout the 'simple' calculation should never be used.

## Reference

### Data

[Wisconsin Data Libarary](http://legis.wisconsin.gov/ltsb/gis/data/)

### Gerrymandering Introduction

[EVERYTHING YOU ALWAYS WANTED TO KNOW ABOUT REDISTRICTING](https://www.aclu.org/files/assets/2010_REDISTRICTING_GUIDE_web_0.pdf)

[Gerrymandering](https://quizlet.com/245844307/gerrymandering-flash-cards/)
Take a quiz.

### Efficiency Gap

[Partisan Gerrymandering and the Efficiency Gap](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=2457468)
The original paper

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

### Gerrymandering Court Cases and Efficiency Gap

[Current Partisan Gerrymandering Cases](https://www.brennancenter.org/analysis/ongoing-partisan-gerrymandering-cases)

[Pennsylvania's Supreme Court just gave Democrats a big win on redistricting](https://www.washingtonpost.com/news/the-fix/wp/2018/01/22/pennsylvanias-supreme-court-just-gave-democrats-a-big-win-on-redistricting/?utm_term=.48744907c4e7)

[The research that convinced SCOTUS to take the Wisconsin gerrymandering case, explained](https://www.vox.com/the-big-idea/2017/7/11/15949750/research-gerrymandering-wisconsin-supreme-court-partisanship)

[Assessing the Current Wisconsin State Legislative Districting Plan](http://www.campaignlegalcenter.org/sites/default/files/WI%20whitford%2020150708%20complaint%20exh3.pdf)

### Efficiency Gap Cautions

[The Flaw in America's 'Holy Grail' Against Gerrymandering](https://www.theatlantic.com/science/archive/2018/01/efficiency-gap-gerrymandering/551492/)

[THE MEASURE OF A METRIC:
THE DEBATE OVER QUANTIFYING PARTISAN GERRYMANDERING](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3077766)
