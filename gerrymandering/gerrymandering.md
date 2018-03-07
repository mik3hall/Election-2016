---
title: "Gerrymandering"
author: "Mike Hall"
date: "3/3/2018"
output:
  html_document:
    keep_md: true
---





## Gerrymandering




```
## Efficiency Gap calculation based on seat margin and vote margin shares
```

```
##     Seats Vote Share Efficincy Gap
## Dem    39  0.5170623     -14.01853
## Rep    60  0.4829377      14.01853
```

```
## Efficiency Gap calculation based on wasted votes
```

```
## [1] -19.37371
```

```
## [1] 0.398
```

Two methods are indicated for computing the Efficiency Gap. One based on wasted votes, the other based on seat and vote share. The second is algebraically derived from the first under certain assumptions. "Instead, if we assume that all districts are equal in population (which is constitutionally required), and that there are only two parties (which is typical in SMD systems)". Where SMD is single member district, each district has a single representative. The later is indicated as a possibly easier way to compute the EG without having to total up all the wasted votes. Although, with R this way might be easier.
I believe the Washington Post article "Here’s how the Supreme Court could
decide whether your vote will count" below mixes up the Efficiency Gap calculations for 2012 and 2014. That indicated that the numbers for these years were provided by Simon Jackman. He appears to have done these calculations for the Wisconsin court case. 

From "Assessing the Current Wisconsin State Legislative Districting Plan" - link below.

> 8. The current Wisconsin state legislative districting plan (the “Current Wisconsin
Plan”). In Wisconsin in 2012, the average Democratic share of districtlevel,
two-party vote (V) is estimated to be 51.4% (±0.6, the uncertainty
stemming from imputations for uncontested seats); recall that Obama won
53.5% of the two-party presidential vote in Wisconsin in 2012. Yet Democrats
won only 39 seats in the 99 seat legislature (S = 39.4%), making Wisconsin
one of 7 states in 2012 where we estimate V > 50% but S < 50%. In Wisconsin
in 2014, V is estimated to be 48.0% (±0.8) and Democrats won 36
of 99 seats (S = 36.4%).

>9. Accordingly, Wisconsin’s EG measures in 2012 and 2014 are large and negative:
-.13 and -.10 (to two digits of precision). The 2012 estimate is the
largest EG estimate in Wisconsin over the 42 year period spanned by this
analysis (1972-2014).

Obama's results are mentioned because this assessment uses the "uniform swing", based on the presidential election, imputation method for missing (uncontested) districts. I attempted imputation based on past results from 2002-2010.

So, we see that Jackman's numbers are the reverse of what the Washington Post article indicates. Maybe not a big difference unless you want to compare your own calculations to what is shown. For 2012 Jackman actually got the -.13, where I get -14.01853. The difference is probably due to vote shares. For 2012 Jackman gives "51.4% (±0.6, the uncertainty
stemming from imputations for uncontested seats);" whereas, as shown above, I get 0.5170623 for 2012 using a different imputation determination. 

This also means that Jackman used the seat and vote share method. I also did the wasted vote calculation getting -21.07994. A very different, and worse, result. It seems like you should be able to think about it this way. If you assumed the vote shares were actually equal then the Republicans got, 60-39/(60+39) = .2121, a 21% vote advantage that they shouldn't of. So the 20% number seems more reasonable? 

The assumptions made by the share method not applying here might be the reason it gives less accurate results. One thing that I thought might be a problem is the "equal population" assumption when given varying voter turnout. Some of the issues that have been raised against the Efficiency Gap are addressed in the link below at "THE MEASURE OF A METRIC: THE DEBATE OVER QUANTIFYING PARTISAN GERRYMANDERING". At least at a rather cursory browse of that it seems to mainly defend Efficiency Gap assuming the wasted vote calculation, including issues for voter turnout. Again, in a rather quick look I saw nothing specifically addressing separate issues with the shares method. So for now my concern that different voter turnouts might affect the equal population assumption remains. 

At this point, unless I am completely off in calculating wasted vote based Efficiency Gaps, I would say there would be concerns in using the share based method for deciding the extent of gerrymandering in court cases. I could still be completely off in my calculations, I have nothing there yet to check my results against.

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

### Efficiency Gap caluculations in the Wisconsin court cases

[The research that convinced SCOTUS to take the Wisconsin gerrymandering case, explained](https://www.vox.com/the-big-idea/2017/7/11/15949750/research-gerrymandering-wisconsin-supreme-court-partisanship)

[Assessing the Current Wisconsin State Legislative Districting Plan](http://www.campaignlegalcenter.org/sites/default/files/WI%20whitford%2020150708%20complaint%20exh3.pdf)

### Efficiency Gap Cautions

[The Flaw in America's 'Holy Grail' Against Gerrymandering](https://www.theatlantic.com/science/archive/2018/01/efficiency-gap-gerrymandering/551492/)

[THE MEASURE OF A METRIC:
THE DEBATE OVER QUANTIFYING PARTISAN GERRYMANDERING](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3077766)
