library(httr)
library(stringi)
library(purrr)
library(dplyr)

# 2012 results from here
# https://www.theguardian.com/news/datablog/2012/nov/07/us-2012-election-county-results-download#data

# The following is from...
# https://stackoverflow.com/questions/40638511/using-rvest-to-grab-data-returns-no-matches
state.results <- function(url) {
	res <- GET(url)
	dat <- readLines(textConnection(content(res, as="text")))

	stri_split_fixed(dat[2], "|")[[1]] %>%
	  stri_replace_last_fixed(";", "") %>% 
	  stri_split_fixed(";", 3) %>% 
	  map_df(~setNames(as.list(.), c("rep_id", "first", "last"))) -> candidates

	dat[stri_detect_regex(dat, "^WV;P;G")] %>% 
	  stri_replace_first_regex("^WV;P;G;", "") %>% 
	  map_df(function(x) {

		county_results <- stri_split_fixed(x, "||", 2)[[1]]

		stri_replace_last_fixed(county_results[1], ";;", "") %>% 
		  stri_split_fixed(";") %>% 
		  map_df(~setNames(as.list(.), c("fips", "name", "x1", "reporting", "x2", "x3", "x4"))) -> county_prefix

		stri_split_fixed(county_results[2], "|")[[1]] %>% 
		  stri_split_fixed(";") %>% 
		  map_df(~setNames(as.list(.), c("rep_id", "party", "count", "pct", "x5", "x6", "x7", "x8", "candidate_idx"))) %>% 
		  left_join(candidates, by="rep_id") -> df

		df$fips <- county_prefix$fips
		df$name <- county_prefix$name
		df$reporting <- county_prefix$reporting

		select(df, -starts_with("x"))

	  }) -> results
}

do.state <- function(res,state) {
	state <- as.character(state)
	scol <- rep(state,nrow(res))
	df <- data.frame(cbind(scol,res[res$party=="Dem",c("name","count")]),stringsAsFactors=F)
	names(df) <- c("State","County","dem.Count")
	df[,"gop.Count"] <- res[res$party=="GOP","count"]
	unique(df)
}

#res <- state.results("http://s3.amazonaws.com/origin-east-elections.politico.com/mapdata/2016/WV_20161108.xml")

flips <- function(s1,s2) {
	flips <- c()
	for (i in 1:length(s1)) {
		if (s1[i] >= 0 && s2[i] >= 0) { flips <- c(flips,0) }
		else if (s1[i] < 0 && s2[i] < 0) { flips <- c(flips,0) }
		else if (s1[i] > 0 && s2[i] < 0) { flips <- c(flips,-1) }
		else if (s1[i] < 0 && s2[i] > 0) { flips <- c(flips,1) }
		else { flips <- c(flips,0) }
	}
	return(flips)
}

state.summary <- function(flips.df) {
	states <- unique(flips.df$State)
	cat(length(states))
	sdata <- c()
	for (state in states) {
		cat(state)
		state.data <- flips.df[flips.df$State == state,]
		p <- (sum(state.data$f0408 != 0) + sum(state.data$f0812 != 0) + sum(state.data$f1216 != 0)) / (nrow(state.data)*3)
		sdata <- c(sdata,p)
	}
	return(data.frame(states,sdata))
}

# > source("election.r")
# No encoding supplied: defaulting to UTF-8.
# > res.NE <- do.state(res,"NE")
# > res16 <- rbind(res16,res.NE)
# > tail(res16)
#     State     County dem.Count gop.Count
# 2076    NE     Valley       337      1770
# 2077    NE Washington      2606      7374
# 2078    NE      Wayne       828      2675
# 2079    NE    Webster       306      1320
# 2080    NE    Wheeler        62       377
# 2081    NE       York      1181      4686
# > results04[results04$County=="York",]
#     State Year   Dem    Rep County
# 1208    ME 2004 58702  49526   York
# 1877    NE 2004  1304   5393   York
# 2288    PA 2004 63701 114270   York
# 2339    SC 2004 24201  45180   York
# 2878    VA 2004 10276  19396   York

#data.AL <- do.state(res.AL)

#res.df <- res.AK[res.AK$party=="Dem",c("name","count")]
#names(res.AK) <- c("County","Dem.Count")

#res.WI <- state.results("http://s3.amazonaws.com/origin-east-elections.politico.com/mapdata/2016/WI_20161108.xml")

#counties <- unique(res.WI$name)
#twoparty <- results[res.WI$party=="Dem" | res.WI$party=="GOP",]