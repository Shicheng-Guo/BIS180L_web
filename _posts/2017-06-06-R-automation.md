---
title: "R automation"
layout: lab
tags:
- R
hidden: true
---

# THIS LAB IS NOT BEING COVERED IN 2017.  I LEAVE IT HERE FOR THOSE THAT ARE INTERESTED.

# Automating analysis in R

This document serves to introduce, or re-introduce, programming features in R that can greatly help speed up repetitive analyses. 

## Assignment:
Because the final is being handed out today, we will not require that this be turned in.  __But it could show up on the final__

## Background
One of the nice things about using a scripting language like R is that we can program R to run through many analyses.

We have already seen several examples of this:

### apply
`apply()` will apply a function to each row or each column of a data.frame or matrix.

```r
m <- matrix(1:24,ncol=4)
m
```

```
##      [,1] [,2] [,3] [,4]
## [1,]    1    7   13   19
## [2,]    2    8   14   20
## [3,]    3    9   15   21
## [4,]    4   10   16   22
## [5,]    5   11   17   23
## [6,]    6   12   18   24
```

```r
apply(m,2,max) #maximum value in each column
```

```
## [1]  6 12 18 24
```

```r
apply(m,1,mean) #mean value of each row
```

```
## [1] 10 11 12 13 14 15
```

### tapply
`tapply()` will apply a function to each level of a factor.

I use the rice data set that you previously saw in the GWAS lab.  If you need to re-download it, you can [get it here](http://jnmaloof.github.io/BIS180L_web/data/RiceDiversity.44K.MSU6.Phenotypes.csv)


```r
data.pheno <- read.csv("../data/RiceDiversity.44K.MSU6.Phenotypes.csv")

#calculate the mean seed length for each Region
tapply(data.pheno$Seed.length,data.pheno$Region,mean)
```

```
##   Africa  America   C Asia   E Asia   Europe Mid East  Pacific   S Asia 
##       NA       NA 8.119348       NA 8.578272       NA       NA       NA 
##  SE Asia 
## 8.111602
```

```r
#why all the NAs?  By default mean throws an NA if there are any NAs in the data
tapply(data.pheno$Seed.length,data.pheno$Region,mean,na.rm=T)
```

```
##   Africa  America   C Asia   E Asia   Europe Mid East  Pacific   S Asia 
## 8.947659 8.849237 8.119348 7.809964 8.578272 8.542502 8.271677 8.066818 
##  SE Asia 
## 8.111602
```
* The first argument is the data that you want to act on,
* The second argument is the data that want to use to split up your observations
* The third argument is the function that you want to apply 
* The fourth argument (optional) are any additional arguments to the function that is being applied

It is also possible to split up your data by multiple categories.  For example if you wanted to look at Amylose content both by region and Pericarp color.  In this case we join together the two grouping variables with `list()`

```r
tapply(data.pheno$Amylose.content, list(data.pheno$Region,data.pheno$Pericarp.color),mean,na.rm=T)
```

```
##              dark    light
## Africa   23.21333 19.75583
## America  25.36000 19.64386
## C Asia         NA 16.46625
## E Asia   25.93333 17.79858
## Europe   16.76500 17.00434
## Mid East 27.29333 21.16111
## Pacific  22.65333 19.68096
## S Asia   25.09868 24.26455
## SE Asia  24.00300 18.26039
```

## For loops

You have seen `for loops` in Linux.  R also has for loops.  The syntax is a bit different.

Previously I had you plot a histogram for a single trait.  What if you wanted a histogram for every trait?  In that case we could use a for() loop.

What is a for loop?  A for loop will repeat the same lines of code for each element of a sequence.

A common example is to loop through a series of numbers:

```r
index <- 1:10
for (i in index) { # 'i' will take on each value of index in turn
  print(i) #squiggly brackets denote the lines of code that are repeated
  }
```

```
## [1] 1
## [1] 2
## [1] 3
## [1] 4
## [1] 5
## [1] 6
## [1] 7
## [1] 8
## [1] 9
## [1] 10
```

What is going on here?  The command `for (i in index)` is computerese for "For each item in `index`, place it in `i` and then perform the code enclosed in the squiggly brackets { }.

So `i` takes a value of 1, the code betweeen the squigly brackets is run (in this case `print(i)` ), and then i takes on the next value in index (2 in this case) and the codes is run again.

More commonly, the first two lines in the code snippet above would be combined:

```r
for (i in 1:10) { 
  print(i)
  }
```

```
## [1] 1
## [1] 2
## [1] 3
## [1] 4
## [1] 5
## [1] 6
## [1] 7
## [1] 8
## [1] 9
## [1] 10
```

So far this seems relatively pointless, but what if we wanted to paste each element of a list into a sentence and print it:

```r
my.numbers <- c(10,2,3,4,5)
for(i in my.numbers) { 
  print(paste("The value of i is",i))
  } 
```

```
## [1] "The value of i is 10"
## [1] "The value of i is 2"
## [1] "The value of i is 3"
## [1] "The value of i is 4"
## [1] "The value of i is 5"
```

### EXERCISE 1
Use a for loop to print the 1st, 5th, 10th, 15th, 20th, and 25th letters of the alphabet  (hint they are in the built-in object `LETTERS` (type `LETTERS` at the R command line to see what I mean).  Format the output so that it identifies the letter (example for the 1st letter): "Letter 1 is 'A'"

### EXERCISE 2
Imagine that there was no `sum()` function and you need to sum a vector of numbers.  Use a for loop to sum the numbers 1 to 100.

#### BONUS: Turn this into an actual function.
(hint: the snippet below creates a function `printName()` which does the obvious)


```r
printName <- function(name) { 
  print(paste("My name is",name))
  } # the code between the squiggly brackets is run when the function is called

printName("Julin") #call the function with the argument "Julin"
```

```
## [1] "My name is Julin"
```
For more information on functions, try the `swirl()` tutorial on functions.

Still not impressed?  Understandable.  But for loops turns out to be quite powerful.  Let's return to the issue I brought up at the beginning of the lession: what if we need a histogram of every trait in a data frame?  Using a for loop makes it trivial.  Here we use the Rice data set from the GWAS lab.


```r
data.pheno <- read.csv("../RiceDiversity.44K.MSU6.Phenotypes.csv",row.names=1)
names(data.pheno) #figure out what the trait names are
my.traits <- names(data.pheno)[4:31] #make a vector to hold the trait names of interest
pdf(file="rice_histograms.pdf") # open a file to save our histograms
for (trait in my.traits) {
  print(hist(data.pheno[,trait],main=trait,xlab=trait,col="skyblue"))
  }
dev.off() #close the PDF file
```


### EXERCISE 3
Download the dataset [Tomato.csv](http://jnmaloof.github.io/BIS180L_web/data/Tomato.csv).  Import it into R.  This data set has a variety of plant measurement taken on different tomato species grown in siulated sun ("H") or shade ("L").  For each trait "hyp  int1  int2  int3	int4	intleng	totleng	petleng	leafleng	leafwid" produce a boxplot (or violin plot) split by treatment (trt) saved as a separate page in a PDF file.  Be sure that the plots have appropriate titles.

What if we want an anova for each trait?

```r
my.traits <- names(data.pheno)[5:32]
for(trait in my.traits) {
  print(trait)
  print(summary(aov(data.pheno[,trait] ~ data.pheno[,"Region"])))
  print("-----------------")
}
```

### Further extenstions: store aov results
It would be helpful if we could store the results of these analyses for later examination, instead of having to scroll through our results:

```r
aov.results <- list()
my.traits <- names(data.pheno)[5:32]
for(trait in my.traits) {
    aov.results[trait] <- summary(aov(data.pheno[,trait] ~ data.pheno[,"Region"]))
}
names(aov.results)
```

```
##  [1] "Alu.Tol"                       "Flowering.time.at.Arkansas"   
##  [3] "Flowering.time.at.Faridpur"    "Flowering.time.at.Aberdeen"   
##  [5] "FT.ratio.of.Arkansas.Aberdeen" "FT.ratio.of.Faridpur.Aberdeen"
##  [7] "Culm.habit"                    "Leaf.pubescence"              
##  [9] "Flag.leaf.length"              "Flag.leaf.width"              
## [11] "Awn.presence"                  "Panicle.number.per.plant"     
## [13] "Plant.height"                  "Panicle.length"               
## [15] "Primary.panicle.branch.number" "Seed.number.per.panicle"      
## [17] "Florets.per.panicle"           "Panicle.fertility"            
## [19] "Seed.length"                   "Seed.width"                   
## [21] "Seed.volume"                   "Seed.surface.area"            
## [23] "Brown.rice.seed.length"        "Brown.rice.seed.width"        
## [25] "Brown.rice.surface.area"       "Brown.rice.volume"            
## [27] "Seed.length.width.ratio"       "Brown.rice.length.width.ratio"
```

```r
#now we can access these as needed!  This would be very helpful if we were running an analysis that was very slow.  We could set the for loop running, come back later, and have all of our results stored.
aov.results[["Culm.habit"]]
```

```
##                         Df Sum Sq Mean Sq F value    Pr(>F)    
## data.pheno[, "Region"]   8 242.06 30.2578  11.152 5.337e-14 ***
## Residuals              336 911.68  2.7133                      
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
aov.results[["Seed.volume"]]
```

```
##                         Df Sum Sq Mean Sq F value    Pr(>F)    
## data.pheno[, "Region"]   8  6.047 0.75588  18.896 < 2.2e-16 ***
## Residuals              331 13.241 0.04000                      
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

### Further extensions: storing the aov p-value
What is just wanted the p-value from each aov?

First we need to figure out where the p-value is stored in the aov object:

```r
aov1 <- summary(aov(data.pheno$Seed.number.per.panicle ~ data.pheno[,"Region"]))[[1]]
aov1
```

```
##                         Df Sum Sq Mean Sq F value    Pr(>F)    
## data.pheno[, "Region"]   8  4.255 0.53188  5.3752 2.287e-06 ***
## Residuals              330 32.654 0.09895                      
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
names(aov1)
```

```
## [1] "Df"      "Sum Sq"  "Mean Sq" "F value" "Pr(>F)"
```

```r
aov1[1,"Pr(>F)"] # found it!
```

```
## [1] 2.287191e-06
```

Now we can use a for loop

```r
my.traits <- names(data.pheno)[5:32]
aov.pvalues <- vector()
for(trait in my.traits) {
   tmp.aov <- summary(aov(data.pheno[,trait] ~ data.pheno[,"Region"]))[[1]]
   aov.pvalues[trait] <- tmp.aov[1,"Pr(>F)"]
   aov.pvalues
}
```

## If...else statements
Sometimes we only want a code segment to execute if a particular condition is met.  For this we use an if statment:


```r
a <- rnorm(n=1,mean=0)
b <- rnorm(n=1,mean=0)

if(sum(a,b) > 0) {
  print("the sum of a + b is greater than zero") #could we have a more boring example?
  }
```

if statements can be placed inside a for loop

```r
for (i in 1:10) {
  if(i < 5) {
    print(i)
    }
  }
```

```
## [1] 1
## [1] 2
## [1] 3
## [1] 4
```

Sometimes we want one code segment to run if a condition is met, and a second code segment to run if it not met.  For this we use an if...else statement


```r
for (i in 1:10) {
  if(i < 5) {
    print(i)
    } else {
      print("the number is greater than 4")
   }
}
```

```
## [1] 1
## [1] 2
## [1] 3
## [1] 4
## [1] "the number is greater than 4"
## [1] "the number is greater than 4"
## [1] "the number is greater than 4"
## [1] "the number is greater than 4"
## [1] "the number is greater than 4"
## [1] "the number is greater than 4"
```

### EXERCISE 4
For each of the traits in the Tomato dataset: "hyp  int1  int2	int3	int4	intleng	totleng	petleng	leafleng	leafwid" perform a t-test to determine if the light treatment (trt) significantly affects the trait.  If the p-value is less than .05 print the results.
HINT: to get the p-value for a single t-test:

```r
tmp.result <- t.test(rnorm(10) ~ rep(c("a","b"),each=5)) #made-up t-test
tmp.result$p.value #The p-value for the t-test
```

```
## [1] 0.2282061
```




