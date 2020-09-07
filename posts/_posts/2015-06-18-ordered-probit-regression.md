---
layout: post
title: Ordered Probit Regression with Integrated Variable Selection
subtitle: 
author: Benjamin J. Radford
featured-image: /images/2015-06-18/bayesian_turtle.jpg
tags: [machine learning]
date: 2015-06-18
---

Occasionally in political science, we run into problems in which we have a small dataset and a large array of possible of predictors. Choosing a parsimonious model can be difficult. When theory-based model selection is out of the question, automated variable selection allows us to estimate the probability that each predictor is included in the "true model." We can use these estimates to then prune our model. Here, I describe a Bayesian ordered probit regression model with stochastic search variable selection (SSVS).

I developed this model (below) as part of a research project for a course on Bayesian and Modern Statistics at Duke. It is an ordered probit regression model and therefore assumes that the dependent variable is a vector of ordered categories. Given a prior exclusion probability, the model estimates the probability that each of several supplied independent variables are a part of the real data generating process. The prior exclusion probability places a weight on the size of the final model. An exclusion probability of 0.8 will result in a model in which approximately 80% of predictors are omitted. Variables are selected by forcing some beta values to precisely 0 with a spike and slab prior.

R code to implement this model is available upon request. I will add it to this post when I find it.

<h3>Priors:</h3>
{% katexmm %}
$$ 
\pi(\gamma) = \prod_{j=1}^{m-1} N(\gamma_j;\mu_0,\sigma_0^2) \\
\pi(\beta) = \prod_{k=1}^p\delta_0(\beta_{0k})p_{0k} + (1-p_{0k})N(\beta_{0k};0,c_k^2) \\
\pi(p_{0k}) \in [0,1]
$$

<h3>Likelihood function:</h3>
$$ 
L(Y|\beta,X,\gamma) = \prod_{i=1}^n N(z_i; x_i^T\beta,1) \sum_{j=1}^{m-1} I(y_i=j)I(\gamma_{j-1} < z_i < \gamma_j)
$$

<h3>Posterior distribution:</h3>
$$ 
\pi(\beta ,\gamma ,z|y) \propto \pi(\beta)\pi(\gamma)\pi(p_0)\prod_{i=1}^n N(z_i; X_i\beta,1) \sum_{j=1}^m I(Y_i=j)I(\gamma_{j-1} < z_i < \gamma_j)
$$

<h3>Full conditional posterior distributions:</h3>
$$ 
\pi(\beta_k | \beta_{-k}, z, \gamma, y, X) \propto \hat{p_{0k}}\delta_0(\beta_k) + (1-\hat{p_{0k}})N(\beta_k; E_k,V_k)\\
E_k = V_kX^T(z-X_{-k}B_{-k})\\
V_k = (c_k^2+x_k^Tx_k)^{-1}\\
\hat{p_{0k}} = \frac{p_{0k}}{p_{0k}+(1-p_{0k})\frac{N(0;\beta_{0k},c_k^2)}{N(0;E_k,V_k)}}\\
\pi(\gamma_j | \beta, z, y, X) \propto N(\gamma_j;\mu_0,\sigma_0^2)\\
\pi(z_i | \beta, z_{-i}, \gamma, y, X) \propto N(z_i;X_i\beta,1)
$$
{% endkatexmm %}

<hr>
<small>Header Image by John from U.S. of A. (Baby Turtle 023) [<a href="http://creativecommons.org/licenses/by/2.0">CC BY 2.0</a>], via Wikimedia Commons.</small>