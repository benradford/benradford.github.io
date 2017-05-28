---
layout: post
title: Mixtures of Linear Models
subtitle: With example code in R.
author: Benjamin J. Radford
tags: [data analysis, r]
date-string: April 19, 2015
---

So, somehow you managed to find a lot of data for which you want to fit a linear model. The problem is that there are several different categories in the data and you forgot to record which $$x$$ falls into which category. Oops. This is especially bad because the relationship between your dependent and independent variables changes across categories. How do we solve this?

<h4>Finite Mixture of Linear Models</h4>
For example, let's look at the mad popular <em>Iris</em> dataset. We've got three different kinds of iris: <em>setosa</em>, <em>versicolor</em>, and <em>virginica</em>. For all 150 irises in the dataset, we have their sepal length and petal length. Clearly, there three different clusters of iris and we can run a single linear regression for each cluster to pull out the true relationships between petal length and sepal length. But, if we didn't know which iris was which, we wouldn't be able to do this with basic linear regression. That's where a mixture of linear models comes in.

The model described here uses the Expectation Maximization (EM) algorithm to estimate three linear models and infer the species of iris without any category information. The model comes from a 2010 paper by Faria and Soromenho. The basic outline is this:

1. Initialization Step - We more or less randomly assign values to all of the parameters described below.
2. Expectation Step - We use a normal PDF to calculate the probability that each iris is a member of each species. Then we standardize these values so that the probability that iris #1 is a setosa, versicolor, or virginica is equal to 1. It has to be one of those and only one of those.
3. Maximization Step - We calculate three weighted linear regressions, one per species. We use all of the irises to calculate each regression, but they are weighted by how likely they are to be a member of that species (from step 2). So irises that are unlikely to be versicolor are weighted very low in the versicolor regression compared to irises that are likely to be versicolor.
4. Then, we repeat steps 2 and 3 until the algorithm converges.

```r
mixlm <- function(formula, data, k, sims=100)
{
  data <- model.frame(formula,data)
  y <- model.response(data)
  x <- model.matrix(formula,data)
  n <- length(y)
  
  # INITIATE PARAMETERS
  beta <- matrix(rnorm(k*ncol(x), 0, 1), ncol=k, nrow=ncol(x), byrow=T)
  sigma <- matrix(1, ncol=k, nrow=ncol(x))
  pi <- rep(1/k, k)
  phi <- matrix(1/k, ncol=k, nrow=n)
  w <- matrix(1/k, ncol=k, nrow=n)
  beta_list <- array(NA, dim=c(ncol(x),k,sims+1))
  beta_list[,,1] <- beta
  
  for(j in 1:sims)
  {
    # E-STEP (EXPECTATION)
    # VECTORIZE THIS LATER
    for(i in 1:k)
    {
      phi[,i] <- dnorm(y, x%*%beta[,i], sqrt(sigma[,i]))
    }
    
    for(i in 1:n)
    {
      w[i,] <- (phi[i,] * pi) / sum(phi[i,] * pi)
    }
  
    # M-STEP (MAXIMIZATION)
    pi <- colSums(w)/n
  
    for(i in 1:k)
    {
      w_mat <- diag(w[,i], nrow=n, ncol=n)
      beta[,i] <- (solve(t(x) %*% w_mat %*% x)) %*% t(x) %*% w_mat %*% y
      
      sigma[i] <- ( w[,i] %*% (y - x %*% beta[,i])^2 ) / sum(w[,i])
    }
    if(sum(is.nan(beta))>0) break
    beta_list[,,j+1] <- beta
  }
  return(list(beta, sigma, beta_list, w))
}
```