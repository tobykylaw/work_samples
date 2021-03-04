## AddReq Stochastics
## Graded Homework 4
## Toby_LAW (Legi 19-945-484)

## Instructions:
## =============
## Type all solutions INTO THIS FILE OR ONTO THE PRINTOUT OF THIS FILE. When you are done, save it.
## Print this file and send it to me via mail or hand it in as last time.

##################################################
## Problem 1
##################################################
## A machine fills up bottles with 500 ml of fluid. However, there was
## a power failure and after restarting the machine, an engineer thinks,
## that the machine might be broken and fill up a little bit too much fluid.
## He makes a test with 10 bottles:
vol <- c(501.26,502.83,500.66,501.90,501.49,499.74,501.02,502.09,500.87,499.92)
t1 <- t.test(vol,alternative = "greater", mu = 500, paired = FALSE, conf.level = 0.95)
t1
p_value_t1 <- t1$p.value

## a) Use a one-sided test (the alternative assumes that there is too
## much fluid being filled up). What is the p-value?
p_value_t1
## Answer: With confidence level = 0.95, p = 0.001819 (4 significant figures)

## b) What is the 99% (!) one-sided confidence interval for the mean
## volume filled up?
t2 <- t.test(vol,alternative = "greater", mu = 500, paired = FALSE, conf.level = 0.99)
conf_interval_t2 <- t2$conf.int
conf_interval_t2
## Answer: The 99% confidence interval of the mean volume is greater than 500.3251 ml. 

w1 <- wilcox.test(vol, alternative = "greater", mu = 500, paired = FALSE, conf.level = 0.95)
w1
p_value_w1 <- w1$p.value
p_value_w1
## c) Do a one-sided Wilcoxon-Test. What is the p-value?
## Answer: p = 0.004883 (4 significant figures)

##################################################
## Problem 2
##################################################
## 14 people were randomly assigned to a control group (7 people) and
## treatment group (7 people). The people in the treatment group
## received a sleeping medication in the evening; the others received
## a placebo. Did the treatment group have a significantly longer
## sleep during the following night?

## Here is the data
trtmnt <- c(10.1,6.9,8.1,8.5,7.7,8.2,9.2) ## amount of sleep in hours
contr <- c(8.3,6.1,7.6,8.0,6.0,6.6,8.4)

## Do a two-sided "Welch Two Sample t-test".
## Check ?t.test

t3 <- t.test(trtmnt, contr, alternative = "two.sided")
t3
p_value_t3 <- t3$p.value
conf_interval_t3 <- t3$conf.int

## a) What is the p-value?
p_value_t3
## Answer: p = 0.06972 (4 significant figures)

## b) What is the 95% confidence interval for the mean difference
## in amount of sleep?
conf_interval_t3
## Answer: The 95% confidence interval for the mean difference in amount of sleep is -0.104 to +2.30 hours. 
## (corrected to 3 significant figures).

## Do now the corresponding one-sided test. (For the alternative, we expect the
## medication to increase the amount of sleep).
t4 <- t.test(trtmnt, contr, alternative = "greater")
t4
p_value_t4 <- t4$p.value
conf_interval_t4 <- t4$conf.int
## c) What is the p-value now?
p_value_t4
## Answer: p = 0.03486 (4 significant figures)

## d) What is the 95% confidence interval now?
conf_interval_t4
## Answer: The 95% confidence interval for the mean difference in amount of sleep is +0.115 hours.
## (corrected to 3 significant figures)

## e) What is the p-value for the two sided Wilcoxon-Test?
w2 <- wilcox.test(trtmnt, contr, alternative = "two.sided")
w2
p_value_w2 <- w2$p.value
p_value_w2
## Answer: p = 0.09732 (4 significant figures)

##################################################
## Problem 3
##################################################
## In the supermarket, I counted for 19 customers the number of
## products they bought and the time they needed at the cash desk.

## Here is the data:
nmb <- c(8,9,1,15,8,5,16,11,10,2,5,3,6,3,9,26,18,13,33) ## nmb products
time <- c(60, 41, 26, 79, 54, 28, 76, 54, 39, 26, 31, 32, 55, 32, 60,
          147, 100, 96, 148) ## time at cash desk
dat <- data.frame(nmb = nmb, time = time)

cor <- cor(nmb, time)
cor
## a) What is the Pearson correlation between nmb and time?
## Answer: cor = 0.9531 (4 significant figures)

cor_test1 <- cor.test(nmb, time, alternative = "two.sided", method = "pearson", conf.level = 0.90)
conf_interval_c1 <- cor_test1$conf.int

## b) What is a 90% (!) two-sided confidence interval for the
## Pearson correlation? 
conf_interval_c1
## Answer: The 90% confidence two-sided interval for the Pearson correlation is greater or equal than 0.896 and smaller
## or equal than 0.979 (corrected to 3 significant figures).

cor_test2 <- cor.test(nmb, time, method = "spearman")
spearman_cor <- cor_test2$estimate
spearman_cor
## c) What is the Spearman correlation between nmb and time?
## Answer: Spearman correlation between nmb and time is 0.9071 (4 significant figures).

## Fit a linear regression explaining the time by number of products.
## This fits the model:
## time = a + b*nmb + e, with e ~ N(0, s^2)

s <- summary(lm(time~nmb, data = dat))
s
a <- s$coefficients[1,1]
b <- s$coefficients[2,1]
## d) What is the estimate of a?
## a = 16.58 (corrected to 4 significant figures)

## e) What is the estimate of b?
## b = 4.324 (corrected to 4 significant figures)

## f) Does the number of products significantly (at 5% level) increase
## the time at the cash desk?
## Answer: We can see for per increase in number of product, the time at the cash desk increases by b times = 4.324 times.
## This estimate has a p-value of 3e^-10, which is much smaller than 5%, therefore we can conclude the number of products 
##significantly increase the time at the cash desk.

## g) What is the estimate of s?
std_error_resi <- s$sigma
std_error_resi
## s = 11.69 (corrected to 4 significant figures)

## h) What is the (standard) R^2?
std_rsq <- s$r.squared
std_rsq
## R^2 = 0.9084 (corrected to 4 significant figures)

## i) Suppose a group of 1000 customers all buy 12 products. Give a
## 95% confidence interval for the mean time spent at the cash desk.
lm.purchase_time <- lm(time~nmb)
conf_int.3i <- predict(lm.purchase_time, interval = "c")
conf_int.3i
## Answer: Supposing 1000 customers all buy 12 products, the 95% confidence interval of the mean time spent at the cash desk 
## is greater or equal to 21.77 and smaller or equal to 37.32 (corrected to 4 significant figures).

## j) Suppose a random customer with 12 items comes to the cash
## desk. Give a 95% prediction interval for her time at the cash desk.
pred_int.3i <- predict(lm.purchase_time, interval = "p")
pred_int.3i
## Answer: The 95% prediction interval for the time at the cash desk of a customer with 12 items is greater or equal to
## 3.679 and smaller or equal to 55.41 (corrected to 4 significant figures).