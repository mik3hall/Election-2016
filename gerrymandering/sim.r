library(redist)
library(dplyr)
library(rgdal)
library(spdep)
library(sp)

#w11 <- read.csv("20122020_WI_Election_Data_with_2011_Wards.csv")
#wards <- readOGR(dsn="WI_Municipal_Wards_Fall_2017")
#adjlist <- poly2nb(wards,queen=FALSE)
#minlist <- min(unlist(adjlist))
#maxlist <- max(unlist(adjlist))
#oneind <- (sum(minlist == 1, maxlist == length(adjlist)) == 2)
#zeroind <- (sum(minlist == 0, maxlist == (length(adjlist) - 1)) == 2)
#regions <- attr(adjlist,"region.id")

#cnt = 0
# for (adj in adjlist) {
# cnt = cnt + 1
# if (0 %in% adj) {
# print(cnt)
# }
# }
# 2064
# 3436

cat("Reading 2012 wards and shape file data...\n")
wards11 <- readOGR(dsn="20122020_WI_Election_Data_with_2011_Wards")
adjlist <- poly2nb(wards11,queen=FALSE)

#[1] 3064
#[1] 6030

adjlist[3064] <- 3055
adjlist[6030] <- 5089

#
# Simulation
#

# 2002-2010 WI Election Data with 2011 Wards
cat("Reading 2002-2010 election data for imputation...\n")
w0210 <- read.csv("../20022010_WI_Election_Data_with_2011_Wards.csv")
a0210 <- w0210 %>% group_by(ASM) %>% summarize(dem02 <- sum(WSADEM02), dem04 <- sum(WSADEM04), dem06 <- sum(WSADEM06), dem08 <- sum(WSADEM08), dem10 <- sum(WSADEM10), rep02 <- sum(WSAREP02), rep04 <- sum(WSAREP04), rep06 <- sum(WSAREP06), rep08 <- sum(WSAREP08), rep10 <- sum(WSAREP10), voting.age <- sum(PERSONS18), n())
nz <- rowSums(a0210[,2:6] != 0)
avg.dem <- rowSums(a0210[,2:6])/nz
nz <- rowSums(a0210[,7:11] != 0)
avg.rep <- rowSums(a0210[,7:11])/nz
xavg.dem <- is.na(avg.dem) 
xavg.rep <- is.na(avg.rep)

# Imputing Uncontested
impute <- function(a) {
  avg.turnout <- (a$dem+a$dem2+a$rep+a$rep2)/a$voting.age
  for (i in 1:nrow(a)) {
    if (a$dem[i] == 0) {      # Uncontested w/ no dem
      if (xavg.dem[i]) {      # If no average from prior elections
        a$rep[i] <- as.integer(avg.turnout[i]*a$voting.age[i]*.75)  # use avg turnout %
        a$dem[i] <- as.integer(avg.turnout[i]*a$voting.age[i]*.25)
      }
      else {
        if (avg.rep[i] > avg.dem[i]) {  # Make sure it's a rep win
          a$rep[i] <- avg.rep[i]      # and use actual prior avg's
          a$dem[i] <- avg.dem[i]      # 02-10
        }
        else {           # Don't think shoud happen but use % again
          a$rep[i] <- as.integer(avg.turnout[i]*a$voting.age[i]*.75)
          a$dem[i] <- as.integer(avg.turnout[i]*a$voting.age[i]*.25)
        }
      }
    }
    else if (a$rep[i] == 0) {  # Uncontested w/ no rep
      if (xavg.rep[i]) {         # If no rep avg from 02-10    
        a$dem[i] <- as.integer(avg.turnout[i]*a$voting.age[i]*.75)   # use avg turnout %
        a$rep[i] <- as.integer(avg.turnout[i]*a$voting.age[i]*.25)
      }
      else {
        if (avg.dem[i] > avg.rep[i]) {  # Make sure it's a dem win
          a$dem[i] <- avg.dem[i]      # and use actual prior avg's
          a$rep[i] <- avg.rep[i]      # 02-10
        }
        else {            # Don't think should happen but use % again
          a$dem[i] <- as.integer(avg.turnout[i]*a$voting.age[i]*.75) # use avg turnout %
          a$rep[i] <- as.integer(avg.turnout[i]*a$voting.age[i]*.25)  
        }
      }
    }
  }  
  a
}

#
# Efficiency Gap calculation
#
eg <- function(dem,rep) {
  # Determine wasted votes
  dwin <- dem > rep
  rwasted <- sum(rep[dwin])+sum(rep[!dwin]-((dem[!dwin]+rep[!dwin])/2+1))
  dwasted <- sum(dem[!dwin])+sum(dem[dwin]-((dem[dwin]+rep[dwin])/2+1))
  eg.wasted <- sum(rwasted-dwasted)/sum(rep+dem)
  eg.wasted
}

data.prep <- function(data) {
	data$ASM <- as.integer(data$ASM)
	data$WSADEM12 <- as.integer(as.character(data$WSADEM12))
	data$WSADEM212 <- as.integer(as.character(data$WSADEM212))
	data$WSAREP12 <- as.integer(as.character(data$WSAREP12))
	data$WSAREP212 <- as.integer(as.character(data$WSAREP212))
	data$PERSONS18 <- as.integer(as.character(data$PERSONS18))
	data$PERSONS <- as.integer(as.character(data$PERSONS))
	data
}

get.avail.ward <- function(borders.avail,districts) {
	curr.ward <- -1
	if (length(borders.avail) == 0) {
		cat("get.avail.ward with empty borders avail\n")
		print(table(districts == 0))
		return(-1)
	}
	already.taken <- 0
	for (avail in 1:length(borders.avail)) {
		if (is.na(borders.avail[avail])) {
			cat("NA in avail list?\n")
			print(borders.avail)
		}
#		cat("borders",length(borders.avail),borders.avail[avail],"\n")
#		cat("district",districts[borders.avail[avail]],"\n")
		if (districts[borders.avail[avail]] == 0) {    # be sure it is still available
			curr.ward <- borders.avail[avail]
		}
		else {
			cat("get on a already taken?",borders.avail[avail],"\n")
			return(-2)
			already.taken <- already.taken + 1
		}
	}
	if (curr.ward == -1) {
		cat("get.avail.ward all were taken - count ",already.taken,"\n")
	}
	return(curr.ward)
}

remove.avail.ward <- function(borders.avail,curr.ward) {
#	cat("remove ",curr.ward,"\n")
	if (length(borders.avail) == 0) {
		return(borders.avail)
	}
	avail <- which(borders.avail == curr.ward)
	if (length(avail) > 0 && is.na(avail)) {
		print(borders.avail)
		cat("remove NA on not found\n")
		return(borders.avail)
	}
	if (length(avail) == 0) {		# Not in available
		return(borders.avail)
#		print(head(borders.avail))
#		cat("curr ward",curr.ward,"not in avail above\n")
	}
#	b <- length(borders.avail)
#	cat("shrink len before",b,"\n")
	remove.type <- "X"
	if (avail == 1) {
		remove.type <- "A"
		if (length(borders.avail) == 1) {
			borders.avail <- c()
		}
		else {
			borders.avail <- borders.avail[2:length(borders.avail)]
		}
	}
	else if (avail == length(borders.avail)) {
		remove.type <- "B"
		borders.avail <- borders.avail[1:(length(borders.avail)-1)]
	}
	else {
		remove.type <- "C"
		part1 <- borders.avail[1:(avail-1)]
		part2 <- borders.avail[(avail+1):length(borders.avail)]
		borders.avail <- c(part1,part2)
	}
	if (length(borders.avail) > 0 && is.na(borders.avail)) {
		print(borders.avail)
		cat("remove type",remove.type,"introduced NA\n")
	}
	borders.avail
}

get.border.ward <- function(borders,borders.avail,districts,asm,adjobj,traversed) {
	curr.ward <- -1
	for (nbr in borders) {
		# avoid cycle backs
		if (!is.na(match(nbr,traversed))) {
			next
		}
		traversed <- c(traversed,nbr)
		if (districts[nbr] == 0) {					# open?
			if (curr.ward == -1) {
				curr.ward <- nbr
			}
			else {		# add any valid remaining to available borders
				if (is.na(match(nbr,borders.avail))) {		# ensure new
					borders.avail <- c(borders.avail,nbr)
				}
			}
		}
		else if (districts[nbr] == asm) {			# in current district?
#			print(traversed)
			nbr.borders <- unlist(adjobj[nbr])
#			cat(nbr,"in our district\n")
#			print(nbr.borders)
			# remove current from list to avoid cycle back
			ward.list <- get.border.ward(nbr.borders,borders.avail,districts,asm,adjobj,traversed)
			curr.ward <- unlist(ward.list[1])
			borders.avail <- unlist(ward.list[2])
			# Can't let this reset or we can cycle
			traversed <- unlist(ward.list[3])
			if (curr.ward != -1) break
		}
		else {
#			cat(nbr,"district not empty for border\n")
		}
	}
	return(list(curr.ward,borders.avail,traversed))
}

simulate <- function(data,adjobj) {
	data <- data.prep(data)
	districts <- rep(0,nrow(data))
	a12 <- data %>% group_by(ASM) %>% summarize(dem <- sum(WSADEM12), dem2 <- sum(WSADEM212), rep <- sum(WSAREP12), rep2 <- sum(WSAREP212), pop <- sum(PERSONS), voting.age <- sum(PERSONS18),n())
	names(a12) <- c("asm","dem","dem2","rep","rep2","pop","voting.age","n")
	a12 <- impute(a12)
	eg.init <- eg(a12$dem,a12$rep)*100
#	cat("EG initial",eg.init,"R Seats",sum(a12$rep>a12$dem),"\n")
	dem.seats <- sum(a12$dem > a12$rep)
	rep.seats <- sum(a12$rep > a12$dem)
	pop.max <- max(a12$pop)
	pop.min <- min(a12$pop)
	pop.mean <- mean(a12$pop)
	pop.10 <- pop.mean*.05
	pop.low <- pop.mean-(pop.10/5)
	pop.high <- pop.mean+(pop.10*4/5)
	cat("low",pop.low,"high",pop.high,"\n")
	# randomly select starting municipal ward
	curr.ward <- 0
	new.dem <- rep(0,nrow(a12))
	new.rep <- rep(0,nrow(a12))
	new.pop <- rep(0,nrow(a12))
	new.a12 <- data.frame(cbind(new.dem,new.rep,new.pop))
	names(new.a12) <- c("dem","rep","pop")
	# DEBUG counts of wards set and unset
	set <- 0
	unset <- 0
	for (i in 1:(nrow(a12)-1)) {         # for number of asm districts less 1
		COMPLETE <- FALSE         
#		cat("Assembly District",i,"\n")   
		borders.avail <- c()  
		while (!COMPLETE) {            # while this assembly district is incomplete
			if (curr.ward == 0) {
				curr.ward <- sample(1:nrow(data),1) # randomly select starting municipal ward
			}
			# Add this ward to current ASM?
			if (length(districts[curr.ward]) != 1) {
				print(curr.ward)
				cat("len error\n")
			}
			if (districts[curr.ward] != 0) {
#				cat("Ward already used",curr.ward,"asm",i,"\n")
				return
			}
			if (new.a12[i,"pop"] + data[curr.ward,"PERSONS"] < pop.high) {
				new.a12[i,"pop"] <- new.a12[i,"pop"] + data[curr.ward,"PERSONS"]
				from.dem.new <- a12$dem[data[i,"ASM"]] - (data[i,"WSADEM12"]+data[i,"WSADEM212"])
				new.a12[i,"dem"] <- new.a12[i,"dem"] + (data[curr.ward,"WSADEM12"]+data[curr.ward,"WSADEM212"])
				new.a12[i,"rep"] <- new.a12[i,"rep"] + (data[curr.ward,"WSAREP12"]+data[curr.ward,"WSAREP212"])
				set <- set + 1
				districts[curr.ward] <- i
#				cat(i,"using",curr.ward,"pop now",new.a12[i,"pop"],"\n") 
				borders.avail <- remove.avail.ward(borders.avail,curr.ward)
				if (length(borders.avail) > 0 && is.na(borders.avail)) {
					cat("Update remove introduced NA?\n")
					return()
				}
				if (new.a12[i,"pop"] > pop.low) {		# ASM pop exceeds minimum
					COMPLETE <- TRUE
					next					
				}
			}
			else {		# current ward unused
				cat("Didn't use current ward",new.a12[i,"pop"],data[curr.ward,"PERSONS"],"min",pop.min,"max",pop.max,"\n")
#				cat("avail before",length(borders.avail),"\n")
				curr.ward <- get.avail.ward(borders.avail,districts)
				if (curr.ward == -1) {
					cat("Unused for pop - unable to obtain available ward\n")
					return()
				}
				borders.avail <- remove.avail.ward(borders.avail,curr.ward)
				if (length(borders.avail) > 0 && is.na(borders.avail)) {
					cat("after get remove introduced NA?\n")
					return()
				}
#				cat("avail after",length(borders.avail),"\n")
				next
			}
			borders <- unlist(adjobj[curr.ward])
			curr.ward <- 0
#			cat("borders len",length(borders),"avail len",length(borders.avail),"\n")
			already.there <- 0
			ward.list <- get.border.ward(borders,borders.avail,districts,asm=i,adjobj,c())
			curr.ward <- unlist(ward.list[1])
			borders.avail <- unlist(ward.list[2])
#			cat("after borders curr",curr.ward,"avail len",length(borders.avail),"\n")
			if (curr.ward == -1) {		# current had no valid border wards
				if (length(borders.avail) > 0) {
					curr.ward <- get.avail.ward(borders.avail,districts)
					if (curr.ward == -1) {
						cat("Unable to obtain available ward\n")
						return()
					}
					borders.avail <- remove.avail.ward(borders.avail,curr.ward)					
				}
				else {
					# clear populations added into current asm
					new.a12[i,"pop"] <- 0
					asm.reset <- which(districts == i)
					new.a12[i,"dem"] <- new.a12[i,"dem"] - sum(data[asm.reset,"WSADEM12"]+data[asm.reset,"WSADEM212"])
					new.a12[i,"rep"] <- new.a12[i,"rep"] - sum(data[asm.reset,"WSAREP12"]+data[asm.reset,"WSAREP212"])
#					cat("asm",i,"pop reset\n")
					# reset wards added into districts
					unset <- unset + sum(districts == i)
					districts[which(districts == i)] <- 0
					# get unassigned wards 
					open <- which(districts == 0)
					# randomly select a open ward to start over with
					curr.ward <- sample(1:length(open),1) # randomly select starting municipal ward
#					cat("restarting",i,"with ward",curr.ward,"\n")
				}
			}			
		}
#		cat("end of ",i,"COMPLETE",COMPLETE,"\n")
	}
#	districts[which(districts == 0)]
#	cat("set",set,"unset",unset,"\n")
#	cat("data rows",nrow(data),"dist num",length(districts),"\n")
#	cat("used districts",sum(districts > 0),"\n")
#	cat("data pop",sum(as.integer(as.character(data$PERSONS))),"\n")
#	cat("a12 pop",sum(a12$pop),"avg",mean(a12$pop),"\n")
#	cat("new.a12 pop",sum(new.a12$pop),"avg",mean(new.a12$pop),"\n")
#	cat("pop 99 from data",sum(as.integer(as.character(data$PERSONS)))-sum(new.a12$pop),"\n")
#	cat("pop 99 from a12",sum(a12$pop)-sum(new.a12$pop),"\n")
	print(table(districts))
	asm99 <- which(districts == 99)
	new.a12[99,"pop"] <- sum(data[asm99,"PERSONS"])
	pop.max <- max(new.a12$pop)
	pop.min <- min(new.a12$pop)
	pop.mean <- mean(new.a12$pop)
#	print(new.a12$pop)
#	cat("sim max",pop.max,"min",pop.min,"mean",pop.mean,"\n")
	eg.sim <- eg(new.a12$dem,new.a12$rep)*100
#	cat("eg",eg.sim,"\n")
#	print(table(new.a12$rep > new.a12$dem))
	seats <- sum(new.a12$rep > new.a12$dem)
	return(c(eg.sim,seats))
#	cat("Done!\n")
}

sim.runs <- function(data,adjobj,runs=25) {
	NUM.RUNS <- runs
	cat("Run",1,"\n")
	result <- simulate(data,adjobj)
	df <- data.frame(cbind(result[1],result[2]))
	names(df) <- c("EG","Seats")
	for (i in 2:(NUM.RUNS-1)) {
		cat("Run",i,"\n")
		df <- rbind(df,simulate(data,adjobj))
	}
	write.csv(df,"simruns.csv",row.names=FALSE)
	reg1 <- lm(EG~Seats,data=df) 
	print(summary(reg1))
	
	with(df,plot(Seats, EG))
	abline(reg1)
}

redist <- function(data,adjobj) {
	data <- data.prep(data)
	districts <- rep(0,nrow(data))
	#
	# Compute initial EG
	#
	a12 <- data %>% group_by(ASM) %>% summarize(dem <- sum(WSADEM12), dem2 <- sum(WSADEM212), rep <- sum(WSAREP12), rep2 <- sum(WSAREP212), pop <- sum(PERSONS), voting.age <- sum(PERSONS18),n())
	names(a12) <- c("asm","dem","dem2","rep","rep2","pop","voting.age","n")
	a12 <- impute(a12)
	eg.init <- eg(a12$dem,a12$rep)*100
	dem.seats <- sum(a12$dem > a12$rep)
	rep.seats <- sum(a12$rep > a12$dem)
	pop.max <- max(a12$pop)
	pop.min <- min(a12$pop)
	pop.mean <- mean(a12$pop)
	cat("Initial EG  ",eg.init,"dem seats",dem.seats,"rep seats",rep.seats,"\n")
	cat("Populations max",pop.max,"min",pop.min,"mean",pop.mean,"\n")
	eg.curr <- eg.init
	DEBUG = FALSE
	cnt.same = 0
	cnt.reject.pop = 0
	cnt.reject.waste = 0
	cnt.accept = 0
	eg.curr <- eg.init
	dwin <- a12$dem > a12$rep
	rwasted <- rep(0,nrow(a12))
    rwasted[dwin] <- a12$rep[dwin]
    rwasted[!dwin] <- a12$rep[!dwin]-((a12$dem[!dwin]+a12$rep[!dwin])/2+1)
    dwasted <- rep(0,nrow(a12))
    dwasted[!dwin] <- a12$dem[!dwin]
    dwasted[dwin] <- a12$dem[dwin]-((a12$dem[dwin]+a12$rep[dwin])/2+1)
    wasted <- data.frame(dwasted,rwasted)
    wasted$total <- rowSums(wasted)
    print("wasted")
    print(head(wasted,10))
#    print(paste("total d wasted",sum(wasted[wasted$party=="d","votes"])))
#    print(paste("total r wasted",sum(wasted[wasted$party=="r","votes"])))
	CHANGED <- TRUE
	while (CHANGED) {
		CHANGED <- FALSE
		for (i in 1:length(adjobj)) {
			adj <- unlist(adjobj[i])
			asm <- data[i,"ASM"]
			for (nbr in adj) {			# nbr = neighbor
				if (asm != data[nbr,"ASM"]) {
					# Check population constraint
					if (a12$pop[data[nbr,"ASM"]] + data[i,"PERSONS"] < pop.max 
						& a12$pop[data[i,"ASM"]] - data[i,"PERSONS"] > pop.min) {
						# save current values
                       	from.dem <- a12$dem[data[i,"ASM"]]
						from.rep <- a12$rep[data[i,"ASM"]]
						to.dem <- a12$dem[data[nbr,"ASM"]]
						to.rep <- a12$rep[data[nbr,"ASM"]]					
						# Will changing district reduce 'waste'?
						from.dem.new <- a12$dem[data[i,"ASM"]] - (data[i,"WSADEM12"]+data[i,"WSADEM212"])
						from.rep.new <- a12$rep[data[i,"ASM"]] - (data[i,"WSAREP12"]+data[i,"WSAREP212"])
						to.dem.new <- a12$dem[data[nbr,"ASM"]] + (data[i,"WSADEM12"]+data[i,"WSADEM212"])
						to.rep.new <- a12$rep[data[nbr,"ASM"]] + (data[i,"WSAREP12"]+data[i,"WSAREP212"])	
						# compute new 'waste'					
						if (from.dem.new > from.rep.new) {
							from.dw <- from.dem.new - ((from.dem.new+from.rep.new)/2+1)
							from.rw <- from.rep.new
						}
						else {
							from.rw <- from.rep.new - ((from.dem.new+from.rep.new)/2+1)
							from.dw <- from.dem.new
						}
						from.w <- from.rw+from.dw				
						if (to.dem.new > to.rep.new) {
							to.dw <- to.dem.new - ((to.dem.new+to.rep.new)/2+1)
							from.rw <- from.rep.new
						}
						else {
							to.rw <- to.rep.new - ((to.dem.new+to.rep.new)/2+1)
							to.dw <- to.dem.new
						}
						to.w <- to.rw+to.dw
						tot.w <- from.w+to.w
						# will change decrease 'waste'?
#						if (from.dw-to.dw > (from.rw-to.rw)) {     # If democrats improve more
						if (wasted[asm,"total"]+wasted[data[nbr,"ASM"],"total"] > tot.w) {
							a12$dem[data[i,"ASM"]] <- from.dem.new
							a12$rep[data[i,"ASM"]] <- from.rep.new
							a12$dem[data[nbr,"ASM"]] <- to.dem.new
							a12$rep[data[nbr,"ASM"]] <- to.rep.new
							eg.new <- eg(a12$dem,a12$rep)
							if ((eg.curr > 0 & eg.new < eg.curr) | (eg.curr < 0 & eg.new > eg.curr)) {
								cnt.accept <- cnt.accept+1
								CHANGED <- TRUE
								eg.curr <- eg.new
#								cat("ward ",nbr,"(","from ASM",data[i,"ASM"],"to ASM",data[nbr,"ASM"],"\n")
							}
							else {        # eg calc rejected - backout change
								a12$dem[data[i,"ASM"]] <- from.dem 
								a12$rep[data[i,"ASM"]] <- from.rep 
								a12$dem[data[nbr,"ASM"]] <- to.dem 
								a12$rep[data[nbr,"ASM"]] <- to.rep 	
								cnt.reject.waste = cnt.reject.waste + 1		 
							}						
						}
#						else {
#							cnt.reject.waste = cnt.reject.waste + 1
#						}
					}
					else {
						cnt.reject.pop = cnt.reject.pop + 1
					} 
				}
				else {
					cnt.same = cnt.same + 1
				}
			
			}
		}
		eg.new <- eg(a12$dem,a12$rep)
		dem.seats <- sum(a12$dem > a12$rep)
		rep.seats <- sum(a12$rep > a12$dem)
		cat("Current EG  ",eg.new,"dem seats",dem.seats,"rep seats",rep.seats,"\n")
	}
	
	cat("same",cnt.same,"pop reject",cnt.reject.pop,"waste reject",cnt.reject.waste,"accept",cnt.accept,"\n")
}
