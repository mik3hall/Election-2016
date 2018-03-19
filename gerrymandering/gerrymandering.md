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
## full   data 1 -20.2 
## simple data 1 -20 
## full   data 2 39.8 
## simple data 2 39.2
```

With equal populations the 'simple' and 'full' EG calcuations give essentially the same results. So my 'full' calculations should be more or less correct.

Now it can be tested to see the results stay the same if the voter turnout is varied...


```
## -- Vary voter turnout --
## full   data 3 -15.95 
## simple data 3 -23.2
```
Turnouts for both parties are proportionately varied to be respectively 100%, 90%, 80%, 70% or 60% of their initial values. You can see that this results in the final numbers being significantly different.

Some of the issues that have been raised against the Efficiency Gap are addressed in "THE MEASURE OF A METRIC: THE DEBATE OVER QUANTIFYING PARTISAN GERRYMANDERING". In that we find...

> <chunk style="font-size:15px"> If turnout is assumed to be equal, the “simplified form” of the efficiency gap can be used: (S – 0.5) – 2 × (V – 0.5), where S is a party’s statewide seat share and V is the party’s vote share averaged across all districts. <mark>To take into account district-level variations in </mark><mark style="background-color:red;">turnout</mark>, <mark>the “full form” of the efficiency gap <mark style="background-color:red;">must</mark> be used instead</mark>.</chunk>

So, there is agreement from the gap creators. The full calculation <mark style="background-color:red;">must</mark> be used with voter turnout. The assessment that Simon Jackman did for the Wisconsin court case had great scope across many states and years. Using the 'simple' calculation must of seemed to be a considerable convenience. But I think it was a mistake. For any serious consideration of Efficiency Gap in real elections where there is considerable variance in voter turnout the 'simple' calculation should never be used. The equal population assumption does not hold.

## Simulation

### Redestricting simulation software.

In looking into simulation software that I could use concerning gerrymandering and the use of the 'efficiency gap' metric I considered a number of possibilities. None of them seemed usable for the 2012 State Assembly elections that I have been considering. Or in some cases useable at all. Although seemed interesting efforts where it would be nice if they were made workable, reusable, extensible and more user friendly. 

[BARD](https://sourceforge.net/projects/bard/)

This R software no longer seems to be available on CRAN. I only found the sourceforge link above. I was unable to figure out how to run it from that.

________

[redist](https://cran.r-project.org/web/packages/redist/redist.pdf)

This R software is available on CRAN. It does seem functioning for the examples but I couldn't get it to work with my data. What this includes for data is what I have based my own beginning efforts on.

________

[Jowei Chen U of Mich](http://www-personal.umich.edu/~jowei/)
[Code and replication](http://www-personal.umich.edu/~jowei/gerrymandering/)

[The Impact of Political Geography on Wisconsin Redistricting:
An Analysis of Wisconsin’s Act 43 Assembly Districting Plan](http://www-personal.umich.edu/~jowei/Political_Geography_Wisconsin_Redistricting.pdf)

Contributed simulation analysis to the Wisconsin court case. Appears to use java for simulations. A single jar file, no source, no usage. Disassembling it didn't do me any good. I have no problem with the use of java but this is pretty much unusable as-is.

____________

[Gerrymandering and
Computational Redistricting](http://redistrict.science/)

Python on this one. I couldn't figure out how to build or use it.

______________

These were the most interesting of the ones that seemed usable by API from a laptop. There were others.

_______________

Others included...

[Dave's Redistricting](http://gardow.com/davebradlee/redistricting/launchapp.html)

Web interface. Requires installation of Microsoft Silverlight plugin. Although it said it didn't work with current OS X Safari, it seems to be all right for me with Sierra. It seemed a fairly complex interface though. I didn't try using it.

________________

[UIUC Profs Use Illinois Supercomputer to Take on Partisan Gerrymandering
](https://www.americaninno.com/chicago/uiuc-profs-use-illinois-supercomputer-to-take-on-partisan-gerrymandering/)

[Toward a Talismanic Redistricting Tool: A Computational Method for Identifying Extreme Redistricting Plans](http://cho.pol.illinois.edu/wendy/papers/talismanic.pdf)

One that apparently targets super computers. I believe Wendy Cho is also among those I've seen who have expressed concerns with the "Efficiency Gap".

__________

[Public Mapping Project](http://www.publicmapping.org/)
Offers the DistrictBuilder, 'open to all members of the public'. It is based on Amazon Web Services and appears to require an AWS account to use it.

_____________

So there are ongoing efforts but since nothing seemed really suited to what I was thinking I ended up putting together something myself. This based somewhat on what I saw redist was using. 

### Simple redistricting

The data apparently used by the 'redist' R package is based on border adjacencies generated from shapefiles. Traversing graphs like this isn't coding that I'm used to. My efforts in this area are included in the sim.r file, here I will just show things based on results from running code in there. 

My own code still uses data from the 2012 Wisconsin State Assembly elections.

I thought I would start with something simple. Based on population constraints if it seemed to reduce 'waste' I switch a municipal ward to a bordering assembly district. 

This approach was successful in driving down the 'waste' based Efficiency Gap calculations but it didn't seem to do much in transferring seats back to the Democrats. 

Running the code from the Gerrymandering directory...

`
source("sim.r")
`

Then

`
redist(wards11@data,adjlist)
`

getting...

`
Current EG   -0.1804091 dem seats 39 rep seats 60
`

`
Current EG   -0.1793595 dem seats 39 rep seats 60 
`

`
Current EG   -0.1783574 dem seats 39 rep seats 60 
`

The EG is decreasing with no change in seats yet.

`
Current EG   -0.1531797 dem seats 40 rep seats 59 
`

At this point, with EG about -15% the Democrats re-gain one seat.
But then it runs all the way down to less than 10% with no more seat changes.

`
Current EG   -0.09302179 dem seats 40 rep seats 59 
`

The code needs to be manually halted, I haven't given it a condition to stop. Less than 10% EG might be good, I think I've seen that 10% could be seen as a rough estimate of where intentional Gerrymandering might be occurring. 

I have tried adding different 'waste' based conditions to get the Democrats more seats. Like only switch if Democrat waste improves more than Republican. If I make it too Democrat biased I have gotten to where it runs out of valid changes to make. "Paints itself into a corner". But no change yet has resulted in more Democrat seats. 

This was a little unexpected. It almost seems to make this a tool Gerrymanderers could use to improve their Efficiency Gap metric without actually losing seats? Possibly I have some bug in here I haven't caught yet. But a strange result.

Simulations gave a more expected result. This is again not code I'm used to writing. The idea from descriptions I've seen used the border data to try and randomly select a municipal ward and then start attaching more wards to build out the require 99 Assmebly Districts. No waste concerns, just the 'equal population' constraint. Whatever might be true of the original districting plan as far as Gerrymandering goes it did an excellent job of meeting the 'equal population' requirement. 

For Assembly District populations we see...

`
max 57658 min 57196 mean 57444.3 
`

Very equal. In order to avoid the "Painting itself into a corner" problem I had to relax the equal population requirment to be a little more lax than this. Again, I thought I've seen that 10% is close enough for districts to meet this, the Wisconsin plan was much better than this. It has still occurred once that the current version of my code gets to a situation where it can't complete the districts. If that happens locally the code backs out the changes for the current district and starts over with a randomly selected 'open' ward. With these the code generally manages to run through full districting simulations without getting stuck. 
One apparent bug remains as shown by this table of final districts and the count of wards they contain...

`
districts
`

`
   0    1    2    3    4   
`

`
2253   36   61   40   48 
`

showing a lot of unassigned wards still set to 0 when there should be none at the end. However, if you look at the populations they all seem more or less correct. This was another reason to adjust the population constraint, so you didn't end up with too much or too little for the last district at the end.

For now I am assuming the results of the simulations are close enough to correct.

Remember the EG and seat initial values.

`
EG initial -18.14665 R Seats 60 
`

Groups of simulations can be run and the results written to disk with something like...

`
sim.runs(wards11@data,adjlist,runs=31)
`

The file for these runs will be "simruns.csv".

I have combined the results for a number of such runs which can be read...


```r
runs <- read.csv("runs.csv")
```

We can do a linear model on this...

```r
reg <- lm(Seats~EG,data=runs)

with(runs,plot(EG, Seats))
	abline(reg)
```

![](gerrymandering_files/figure-html/regression-1.png)<!-- -->

You can see that the worse the EG is the more seats there are for the Republicans, as expected. 

There definitely seems to be a correlation here doesn't there?


```
## [1] -0.8941648
```

So there is. Remember that this is all using actual votes for these municipal wards - they don't change. They are simply redistricted more or less randomly. For whatever 'districting plan' you end up with the resulting Efficiency Gap certainly seems to correspond to the number of seats that would be held adding up the vote counts.

We can also histogram the EG values...


```r
hist(runs$EG,breaks=30)
```

![](gerrymandering_files/figure-html/hist-1.png)<!-- -->

One thing to notice here is that a lot of the random results still result in an Efficiency Gap of more than 10%. That might not be that strong an indicator that Gerrymandering is going on. 

Notice also that no random results completely eliminated a Republican favoring Efficiency Gap. I have seen suggested that with some existing state plans there is no immediate fix available to correct existing EG biases.

Remember our initial values though. The actual EG was -18.14665. How many simulations, out of the 150 total, resulted in an EG this bad?


```r
sum(runs$EG <= -18.14665)
```

```
## [1] 0
```

Huh, none. How about seats? How many times did the Republicans have as many seats?


```r
sum(runs$Seats >= 60)
```

```
## [1] 0
```

Again, none. The greater than 10% might not suggest Gerrymandering but this certainly seems to indicate it as a possibility. Not one of the 150 results as bad as the actual for either of these.

To summarize the linear model.


```r
summary(reg)
```

```
## 
## Call:
## lm(formula = Seats ~ EG, data = runs)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -3.3268 -0.7857 -0.0806  0.7815  3.1689 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  35.9007     0.4437   80.92   <2e-16 ***
## EG           -0.9354     0.0385  -24.30   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1.202 on 148 degrees of freedom
## Multiple R-squared:  0.7995,	Adjusted R-squared:  0.7982 
## F-statistic: 590.3 on 1 and 148 DF,  p-value: < 2.2e-16
```

We see that the R-squared shows about 80% explained. The p-value is definitely significant, and there almost a correspondence of one seat lost implying a 10% change in EG.

[TO BE PROOF READ LATER]

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

### Simulation

