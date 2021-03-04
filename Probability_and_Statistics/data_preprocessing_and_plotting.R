###Submission of h1 of Stochastics 406-0603-AAL, by LAW_Toby, Legi 19-945-484
## We will work on a data set on obesity.

## The ‘bp.obese’ text file has 102 rows (plus header) and 3 columns.
## It contains data from a random sample of Mexican-American adults in
## a small California town. Values in this file are separated by a
## comma. This is standard format, if you export data from Excel (by
## using "Save as" and then selecting ".csv"). I suggest you have a
## look at this file with a text editor.

## This text file contains the following columns:
## ‘sex’   a numeric vector, code 0: male, 1: female.
## ‘obese’ a numeric vector, ratio of actual weight to ideal weight
##         from New York Metropolitan Life Tables.
## ‘bp’    a numeric vector, systolic blood pressure (mm Hg).

## To get started, check your current working directory. 
## Adapt your current working directory so that it points to the folder 
## where you saved the text file "bp.obese.txt".
getwd()
setwd("worksamples/Probability_and_Statistics")

## 1) Read in the data set from the text file "bp.obese.csv" and save
## it in a data frame called "bp.obese". The first column must be
## saved as a "factor", the other columns must be saved as
## "numeric". (Hint: Use the command "read.table" and the option "sep"
## and "colClasses"; also check "?read.table")

#Solution to Question 1)
bp.obese <- read.table("bp.obese.csv", sep = ",", header = TRUE, colClasses = c("factor", "numeric", "numeric"))

## 2) Compute the mean systolic blood pressure of all persons in this 
## data set!

#Solution to Question 2)
sum_bp <- sum(bp.obese$bp)
mean_bp <- sum_bp/length(bp.obese$bp)
mean_bp

## 3) Use the function "tapply" to compute the mean systolic blood
## pressure for man and women.

#Solution to Question 3)
table(bp.obese$sex)
tapply(bp.obese$bp, bp.obese$sex, mean)

## 4) Make a new data frame called "dat2" that contains all males with
## a systolic blood pressure bp satisfying bp >= 100 and bp <= 120. 

#Solution to Question 4)
dat2 <- data.frame(bp.obese$bp[bp.obese$sex == "M" & bp.obese$bp >=100 & bp.obese$bp <=120])

## 5) Make a new data frame called "dat3" that contains the old data
## frame "bp.obese" but has two additional columns: One column called
## "bpSq" which contains the squared values of the column "bp" (the
## square of "x" in R can be computed using "x^2"); the other column
## called "special" must contain the values of "bp" divided by the
## mean of all values in column "obese". The mean of "obese" must not
## occur in "dat3". 

#Solution to Question 5)
dat3 <- within(bp.obese, bpSq <- bp.obese$bp^2)
dat3 <- within(dat3, special <- bp.obese$bp/mean(bp.obese$obese))
dat3

#ALTERNATIVE ANSWER for Question 5):
#bpSq <- bp.obese$bp^2
#special <- bp.obese$bp/mean(bp.obese$obese)
#dat3 <- cbind(bp.obese, bpSq, special)

## 6) We now carry on with the original data "bp.obese". Make a
## boxplot comparing the systolic blood pressure for men and
## women. Under each boxplot, there should be an indicator "M" or "W"
## indicating the group.

#Solution to Question 6)
bp_men <- bp.obese$bp[bp.obese$sex == "M"]
bp_women <- bp.obese$bp[bp.obese$sex == "W"]
boxplot(bp_men, bp_women, names = c("M", "W"), col = c("gold", "darkgreen"), xlab = "Sex",
        ylab = "Systolic Blood Pressure", main = "Range of Systolic Blood Pressure in Male/Female Test Subjects")

## 7) Plot "bp" (y-axis) vs. "obese" (x-axis). Use the options "xlab"
## and "ylab" to write "Obesity" on the x-axis and "Blood Pressure" on
## the y-axis. Put the title "Scatterplot" on top of the graph.

#Solution to Question 7)
bp <- bp.obese$bp
obese <- bp.obese$obese
plot(obese, bp, xlab = "Obesity", ylab = "Blood Pressure", type = "p", main = "Scatterplot")


## 8) We now discretize the variable blood pressure into four groups:
## Make a two-way table of all persons according to "bpDiscrete" and
## "sex". Save the table in the variable "tab1".

#Solution to Question 8)
bpDiscrete <- cut(bp.obese$bp, 4)
sex <- bp.obese$sex
tab1 <- table(sex, bpDiscrete)
tab1

## 9) Transform "tab1" into a table called "tab2" that contains the
## proportions of blood pressure within sex (I.e., if you add all 4
## proportions for males, you get 1).

#Solution to Question 9
men_sum <-length(bpDiscrete[sex == "M"])
women_sum <-length(bpDiscrete[sex == "W"])
tab2 <- tab1
tab2[1,] <- tab1[1,]/men_sum
tab2[2,] <- tab1[2,]/women_sum
tab2

## 10) Visualize the table "tab2" using a bar plot (choose the default
## layout).

#Solution to Question 10)
plot_men <- tab2[1,]
plot_women <- tab2[2,]
barplot.default(tab2, beside = TRUE, col = c("peachpuff", "skyblue"), legend.text = c("Men", "Women"),
                xlab = "Range of Systolic Blood Pressure", ylab = "Proportion of all male/female subjects",
                ylim = c(0,0.7), main = "Distribution of systolic blood pressure among male/female subjects")
