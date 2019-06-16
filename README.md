# LogisticRegression-DecisionTrees

A supermarket is offering a new line of organic products. The supermarket's
management wants to determine which customers are likely to purchase these products. The supermarket
has a customer loyalty program. As an initial buyer incentive plan, the supermarket provided coupons for
the organic products to all of the loyalty program participants and collected data that includes whether
these customers purchased any of the organic products.

The “organics” data set contains 13 variables and over 22,000 observations. The variables in the data set
are shown below with the appropriate roles and levels:
Name
Model
Role Data Type Description
ID ID Categoric Customer loyalty identification number
DemAffl Input Numeric Affluence grade on a scale from 1 to 30
DemAge Input Numeric Age, in years
DemCluster Rejected Categoric Type of residential neighborhood
DemClusterGroup Input Categoric Neighborhood group
DemGender Input Categoric M = male, F = female, U = unknown
DemRegion Input Categoric Geographic region
DemTVReg Input Categoric Television region
PromClass Input Categoric Loyalty status: tin, silver, gold, or platinum
PromSpend Input Numeric Total amount spent
PromTime Input Numeric Time as loyalty card member
TargetBuy Target Numeric Organics purchased? 1 = Yes, 0 = No
TargetAmt Rejected Numeric Number of organic products purchased
Although two target variables are listed, these exercises concentrate on the binary target
variable TargetBuy.

(a) Import the data to R. Copy the R code used below.
(b) Examine the distribution of the target variable: (1) plot a bar chart to show the number of
observations in each category, and (2) plot a bar chart to show the frequency of observations in each
category. Copy the code used and the resulting plots below. How many individuals purchased organic
products? What is the approximate proportion of individuals who purchased organic products?
(c) The variable DemClusterGroup contains collapsed levels of the variable DemCluster. Presume
that, based on previous experience, you believe that DemClusterGroup is sufficient for this type of
modeling effort. Exclude the variable DemCluster for the analysis. Copy the R code used below.
(d) As noted above, only TargetBuy will be used for this analysis and should have a role of target.
Can TargetAmt be used as an input for a model used to predict TargetBuy? Why or why not?
(e) Partition the data: set records 1, 3, 5, … (the rows with odd numbers) as the training data, and set
records 2, 4, 6, … (the rows with even numbers) as the validation data, which results in 50%/50%
partition for training/validation. Copy the code used below.
(f) Implement a decision tree on the Training data to predict “TargetBuy” status. Plot the tree. Copy
the code used and the result below. How many leaves are in the tree? Which variable was used for the
first split? Create a confusion matrix which shows the accuracy rate of your classification. Copy the
code used and the result below.
(g) Apply your decision tree from the training data to the validation data, and compare the accuracy
of classification of your validation and training data sets. Show the confusion matrix. Copy the code
used and the results below. How is the accuracy using validation data different from that using
training data? Is this what you expected? Why?
(h) Imposing maxdepth = 2, create another decision tree on the training data to predict TargetBuy
status. Plot the tree. Create a confusion matrix which shows the accuracy rate of your classification.
Copy the code used and the result below. How many leaves are in the tree? Compared with the tree in
(f), which one appears to be better? Is this what you expected? Why?
(i) Next, consider using a logistic regression model. First, are there any missing values? If so, is any
missing values imputation needed for logit model? Is imputation required before generating the
decision tree models and why?
(j) Impute: impute “U” for unknown class variable values and the overall mean for unknown interval
variable values. Copy the code used below.
(k) Use a logistic regression model to classify the data set using the same dependent variable,
TargetBuy. Copy the code used and the result below.
(l) Compare the performance of the logit model on the training and validation data sets by creating
confusion matrixes which show the accuracy rates. Copy the code used and the result below. Which
one appears to be better?
(m) Plot ROC curves for the decision tree in (f) and the logit model using validation data. Summarize
each curve by its ROC index (“area under the curve (AUC)”). Copy the code used and the result
below. In terms of ROC index, which model is better?

