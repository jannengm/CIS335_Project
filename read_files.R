# Import needed libraries
library("arules", lib.loc="~/R/x86_64-pc-linux-gnu-library/3.3")

# Read in the data. Must be in correct working directory first
cust <- read.table("custs.txt", sep="\t", header=TRUE, stringsAsFactors = FALSE)
prod <- read.table("product.txt", sep="\t", header=FALSE)
trans <- read.transactions("trans.txt", sep=",")

# Replace "Org" value in customer data with 1 for b, 2 for g
cust[cust$org == "b",]$org <- 1
cust[cust$org == "g",]$org <- 0
cust$org <- as.integer(cust$org)