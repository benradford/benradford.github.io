---
layout: post
title: Electiogeddon
subtitle: Did e-voting swing the 2016 US presidential election?
author: Benjamin J. Radford
featured-image: /images/2016-11-24/header_map.png
tags: [data analysis, political science, r, statistics, cybersecurity, hacking]
date: 2016-11-24
---
In a <a href="http://fivethirtyeight.com/features/election-update-leave-the-la-times-poll-alone/">shocking</a> turn of events, Donald Trump won the 2016 U.S. presidential election. After the shock (and distress) subsided, some (myself included) were left wondering if this twist ending was the work of hackers manipulating electronic voting machines. It is certainly possible to <a href="http://www.foxnews.com/tech/2011/09/30/researchers-hack-voting-machine-for-26.html">hack e-voting machines</a>. And there is evidence that a [state actor](https://en.wikipedia.org/wiki/Russia) did engage in an effort to <a href="http://www.nytimes.com/2016/10/08/us/politics/us-formally-accuses-russia-of-stealing-dnc-emails.html">manipulate the U.S. election</a>. Putting the two together, some experts have advised the Clinton campaign that votes cast on e-voting machines should be audited for the possibility that these machines were [compromised by foreign agents](http://nymag.com/daily/intelligencer/2016/11/activists-urge-hillary-clinton-to-challenge-election-results.html). These experts claim to have found evidence that Trump performed disproportionately well in certain counties where electronic voting machines were used. <a href="https://www.fivethirtyeight.com">Nate Silver of 538</a> <a href="https://twitter.com/NateSilver538/status/801221546685661184">disagrees</a>. In this article, I provide the data and code necessary to test this hypothesis and to potentially uncover evidence of manipulated, hacked, or otherwise unfair e-voting machines. While I find no evidence that e-voting machines were biased in favor of either candidate, I encourage others to build on this analysis and verify (or contradict) these results.

All code and data to replicate this analysis can be found at <a href="https://www.github.com/benradford/electiogeddon">GitHub.com/benradford/electiogeddon</a>.

<figure>
<img src="/images/2016-11-24/election_map.png" alt="2016 presidential election votes by county for the continental U.S." style="width:100%">
<figcaption>2016 presidential election votes by county for the continental U.S.</figcaption></figure>

<h2>Data Sources</h2>
First, we need to obtain several sets of data. These are listed below and include election returns, voting technology by county, and demographic data. Fortunately, all of these are available online for free and are also available in easy CSV format in this project's associated <a href="https://www.github.com/benradford/electiogeddon">GitHub repository</a>. Additionally, all but one source of data use <a href="https://www.census.gov/geo/reference/codes/cou.html">FIPS codes</a> to facilitate merging the disparate sources together.

* Demographic data on race and sex from the [U.S. Census Bureau](https://www.census.gov/popest/data/counties/asrh/2015/index.html).
* Education data from the [U.S. Department of Agriculture](https://www.ers.usda.gov/data-products/county-level-data-sets/download-data.aspx).
* Population data from the [U.S. Department of Agriculture](https://www.ers.usda.gov/data-products/county-level-data-sets/download-data.aspx).
* Unemployment data from the [U.S. Department of Agriculture](https://www.ers.usda.gov/data-products/county-level-data-sets/download-data.aspx).
* 2016 U.S. presidential election results from [tonmcg](https://github.com/tonmcg/County_Level_Election_Results_12-16).
* 2016 U.S. presidential election voting technology from [VerifiedVoting.org](https://www.verifiedvoting.org).
* County-level (adm02) shapefile for U.S.A. from the [U.S. Census Bureau](https://www.census.gov/geo/maps-data/data/cbf/cbf_counties.html).

For data merging issues, Alaska is omitted. For ease of visualization, Hawaii is also omitted.

<figure>
<img src="/images/2016-11-24/electronic_voting.png" alt="Counties with electronic voting machines in the 2016 U.S. presidential election.">
<figcaption>
Counties with electronic voting machines in the 2016 U.S. presidential election.</figcaption></figure>

We are testing the hypothesis that, all else considered, counties with electronic voting machines produced vote tallies indistinguishable from those of counties without electronic voting machines. This hypothesis follows from the observation that hackers could manipulate electronic voting machines but could probably not interfere with paper or optical ballots. If we observe a measurable effect of electronic voting machines on the proportion of the vote received by the GOP candidate, we will have evidence to reject the null hypothesis (above) and should consider the possibility that the electronic voting machines were somehow unfair.

The dependent variable is the _proportion of vote_ received by the GOP candidate, Donald Trump, per county. Predictors include _electronic voting machines (indicator)_, _population (logged)_, _percent unemployment_, _percent college degree_, and _precent white_. For simplicity the dependent variable is conceptualized as a continuous-valued response and no link function is used. Therefore, these are purely linear models and predicted values are not bound by 0 and 1 as proportions would be.

<center></center>
<table style="border-collapse: collapse; border: none; border-bottom: double;">
<tbody>
<tr>
<td style="padding:0.2cm; border-top:double;">&nbsp;</td>
<td style="border-bottom:1px solid; padding-left:0.5em; padding-right:0.5em; border-top:double;">&nbsp;</td>
<td style="padding:0.2cm; text-align:center; border-bottom:1px solid; border-top:double;" colspan="3">A. GOP Vote Share</td>
<td style="border-bottom:1px solid; padding-left:0.5em; padding-right:0.5em; border-top:double;">&nbsp;</td>
<td style="padding:0.2cm; text-align:center; border-bottom:1px solid; border-top:double;" colspan="3">B. GOP Vote Share</td>
</tr>
<tr>
<td style="padding: 0.2cm; font-style: italic;"></td>
<td style="padding-left: 0.5em; padding-right: 0.5em; font-style: italic;"></td>
<td style="padding: 0.2cm; text-align: center; font-style: italic;">B</td>
<td style="padding: 0.2cm; text-align: center; font-style: italic;">CI</td>
<td style="padding: 0.2cm; text-align: center; font-style: italic;">p</td>
<td style="padding-left: 0.5em; padding-right: 0.5em; font-style: italic;"></td>
<td style="padding: 0.2cm; text-align: center; font-style: italic;">B</td>
<td style="padding: 0.2cm; text-align: center; font-style: italic;">CI</td>
<td style="padding: 0.2cm; text-align: center; font-style: italic;">p</td>
</tr>
<tr>
<td style="padding: 0.2cm; text-align: left; border-top: 1px solid; font-weight: bold;" colspan="9">Fixed Parts</td>
</tr>
<tr>
<td style="padding: 0.2cm; text-align: left;">(Intercept)</td>
<td style="padding-left: 0.5em; padding-right: 0.5em;"></td>
<td style="padding: 0.2cm; text-align: center;">0.62</td>
<td style="padding: 0.2cm; text-align: center;">0.59&nbsp;–&nbsp;0.66</td>
<td style="padding: 0.2cm; text-align: center;"><b>&lt;.001</b></td>
<td style="padding-left: 0.5em; padding-right: 0.5em;"></td>
<td style="padding: 0.2cm; text-align: center;">0.49</td>
<td style="padding: 0.2cm; text-align: center;">0.44&nbsp;–&nbsp;0.54</td>
<td style="padding: 0.2cm; text-align: center;"><b>&lt;.001</b></td>
</tr>
<tr>
<td style="padding: 0.2cm; text-align: left;"><span style="color: #ff0000;">electronic</span></td>
<td style="padding-left: 0.5em; padding-right: 0.5em;"><span style="color: #ff0000;">&nbsp;</span></td>
<td style="padding: 0.2cm; text-align: center;"><span style="color: #ff0000;">0.01</span></td>
<td style="padding: 0.2cm; text-align: center;"><span style="color: #ff0000;">-0.00&nbsp;–&nbsp;0.03</span></td>
<td style="padding: 0.2cm; text-align: center;"><span style="color: #ff0000;">.135</span></td>
<td style="padding-left: 0.5em; padding-right: 0.5em;"><span style="color: #ff0000;">&nbsp;</span></td>
<td style="padding: 0.2cm; text-align: center;"><span style="color: #ff0000;">0.01</span></td>
<td style="padding: 0.2cm; text-align: center;"><span style="color: #ff0000;">-0.00&nbsp;–&nbsp;0.01</span></td>
<td style="padding: 0.2cm; text-align: center;"><span style="color: #ff0000;">.260</span></td>
</tr>
<tr>
<td style="padding: 0.2cm; text-align: left;">population</td>
<td style="padding-left: 0.5em; padding-right: 0.5em;"></td>
<td style="padding: 0.2cm; text-align: center;"></td>
<td style="padding: 0.2cm; text-align: center;"></td>
<td style="padding: 0.2cm; text-align: center;"></td>
<td style="padding-left: 0.5em; padding-right: 0.5em;"></td>
<td style="padding: 0.2cm; text-align: center;">-0.02</td>
<td style="padding: 0.2cm; text-align: center;">-0.02&nbsp;–&nbsp;-0.01</td>
<td style="padding: 0.2cm; text-align: center;"><b>&lt;.001</b></td>
</tr>
<tr>
<td style="padding: 0.2cm; text-align: left;">unemployment</td>
<td style="padding-left: 0.5em; padding-right: 0.5em;"></td>
<td style="padding: 0.2cm; text-align: center;"></td>
<td style="padding: 0.2cm; text-align: center;"></td>
<td style="padding: 0.2cm; text-align: center;"></td>
<td style="padding-left: 0.5em; padding-right: 0.5em;"></td>
<td style="padding: 0.2cm; text-align: center;">-0.02</td>
<td style="padding: 0.2cm; text-align: center;">-0.02&nbsp;–&nbsp;-0.01</td>
<td style="padding: 0.2cm; text-align: center;"><b>&lt;.001</b></td>
</tr>
<tr>
<td style="padding: 0.2cm; text-align: left;">college</td>
<td style="padding-left: 0.5em; padding-right: 0.5em;"></td>
<td style="padding: 0.2cm; text-align: center;"></td>
<td style="padding: 0.2cm; text-align: center;"></td>
<td style="padding: 0.2cm; text-align: center;"></td>
<td style="padding-left: 0.5em; padding-right: 0.5em;"></td>
<td style="padding: 0.2cm; text-align: center;">-0.01</td>
<td style="padding: 0.2cm; text-align: center;">-0.01&nbsp;–&nbsp;-0.01</td>
<td style="padding: 0.2cm; text-align: center;"><b>&lt;.001</b></td>
</tr>
<tr>
<td style="padding: 0.2cm; text-align: left;">percent_white</td>
<td style="padding-left: 0.5em; padding-right: 0.5em;"></td>
<td style="padding: 0.2cm; text-align: center;"></td>
<td style="padding: 0.2cm; text-align: center;"></td>
<td style="padding: 0.2cm; text-align: center;"></td>
<td style="padding-left: 0.5em; padding-right: 0.5em;"></td>
<td style="padding: 0.2cm; text-align: center;">0.64</td>
<td style="padding: 0.2cm; text-align: center;">0.61&nbsp;–&nbsp;0.66</td>
<td style="padding: 0.2cm; text-align: center;"><b>&lt;.001</b></td>
</tr>
<tr>
<td style="padding: 0.2cm; padding-top: 0.5em; padding-bottom: 0.1cm; text-align: left; font-weight: bold;" colspan="9">Random Parts</td>
</tr>
<tr>
<td style="padding: 0.2cm; padding-top: 0.1cm; padding-bottom: 0.1cm; text-align: left;">σ<sup>2</sup></td>
<td style="padding-left: 0.5em; padding-right: 0.5em;"></td>
<td style="padding: 0.2cm; text-align: center; padding-top: 0.1cm; padding-bottom: 0.1cm;" colspan="3">0.018</td>
<td style="padding-left: 0.5em; padding-right: 0.5em;"></td>
<td style="padding: 0.2cm; text-align: center; padding-top: 0.1cm; padding-bottom: 0.1cm;" colspan="3">0.007</td>
</tr>
<tr>
<td style="padding: 0.2cm; padding-top: 0.1cm; padding-bottom: 0.1cm; text-align: left;">τ<sub>00, state</sub></td>
<td style="padding-left: 0.5em; padding-right: 0.5em;"></td>
<td style="padding: 0.2cm; text-align: center; padding-top: 0.1cm; padding-bottom: 0.1cm;" colspan="3">0.014</td>
<td style="padding-left: 0.5em; padding-right: 0.5em;"></td>
<td style="padding: 0.2cm; text-align: center; padding-top: 0.1cm; padding-bottom: 0.1cm;" colspan="3">0.007</td>
</tr>
<tr>
<td style="padding: 0.2cm; padding-top: 0.1cm; padding-bottom: 0.1cm; text-align: left;">N<sub>state</sub></td>
<td style="padding-left: 0.5em; padding-right: 0.5em;"></td>
<td style="padding: 0.2cm; text-align: center; padding-top: 0.1cm; padding-bottom: 0.1cm;" colspan="3">49</td>
<td style="padding-left: 0.5em; padding-right: 0.5em;"></td>
<td style="padding: 0.2cm; text-align: center; padding-top: 0.1cm; padding-bottom: 0.1cm;" colspan="3">49</td>
</tr>
<tr>
<td style="padding: 0.2cm; text-align: left; padding-top: 0.1cm; padding-bottom: 0.1cm;">ICC<sub>state</sub></td>
<td style="padding-left: 0.5em; padding-right: 0.5em;"></td>
<td style="padding: 0.2cm; text-align: center; padding-top: 0.1cm; padding-bottom: 0.1cm;" colspan="3">0.435</td>
<td style="padding-left: 0.5em; padding-right: 0.5em;"></td>
<td style="padding: 0.2cm; text-align: center; padding-top: 0.1cm; padding-bottom: 0.1cm;" colspan="3">0.507</td>
</tr>
<tr>
<td style="padding: 0.2cm; padding-top: 0.1cm; padding-bottom: 0.1cm; text-align: left; border-top: 1px solid;">Observations</td>
<td style="padding-left: 0.5em; padding-right: 0.5em; border-top: 1px solid;"></td>
<td style="padding: 0.2cm; padding-top: 0.1cm; padding-bottom: 0.1cm; text-align: center; border-top: 1px solid;" colspan="3">3107</td>
<td style="padding-left: 0.5em; padding-right: 0.5em; border-top: 1px solid;"></td>
<td style="padding: 0.2cm; padding-top: 0.1cm; padding-bottom: 0.1cm; text-align: center; border-top: 1px solid;" colspan="3">3105</td>
</tr>
<tr>
<td style="padding: 0.2cm; text-align: left; padding-top: 0.1cm; padding-bottom: 0.1cm;">R<sup>2</sup> / Ω<sub>0</sub><sup>2</sup></td>
<td style="padding-left: 0.5em; padding-right: 0.5em;"></td>
<td style="padding: 0.2cm; text-align: center; padding-top: 0.1cm; padding-bottom: 0.1cm;" colspan="3">.319 / .319</td>
<td style="padding-left: 0.5em; padding-right: 0.5em;"></td>
<td style="padding: 0.2cm; text-align: center; padding-top: 0.1cm; padding-bottom: 0.1cm;" colspan="3">.746 / .746</td>
</tr>
</tbody>
</table>

For the national models, linear mixed effects models are selected. Random intercepts are included per state. These allow us to account for state-level heterogeneity; we are essentially controlling for all of the systematic differences between states that are otherwise unaccounted for by the variables in our model. For example, differences between states in geography, state history, and industry should all more-or-less be covered by these higher-level random effects. Neither model __A__ nor __B__ provides evidence of a significant or substantial correlation between voting technology and vote share. This means we have found no evidence to reject the null hypothesis and are still safe to assume that, nationally, electronic voting machines do not correlate with unusual voting behaviors at the county level.

We turn now to a state-level analysis. For this, I have elected to use 22 simple linear regression models - one per state with mixed voting types. Because we need to measure variation within the state, we must omit the remaining states that utilize either electronic voting or other voting methods but not both. Rather than show 22 regression tables, the results are shown here as a series of maps.

<figure>
    <img src="/images/2016-11-24/dre_states.png" alt="State level analysis of voting machine behavior. Note that the predicted vote share distributions are truncated to 0 and 1. Actual predicted vote shares exceed these limits.">
    <figcaption>
        State level analysis of voting machine behavior. Note that the predicted vote share distributions are truncated to 0 and 1. Actual predicted vote shares exceed these limits.
    </figcaption>
</figure>

Underneath each state map is a pair of overlapping density plots. These represent the predicted values of GOP vote share given the state model and model uncertainty. If the red (e-voting) and gray (not e-voting) densities overlap, that means the predicted values for vote share in that state are roughly the same for counties that use electronic voting machines and those that do not. If, on the other hand, the two densities do not line up, we would suspect that there are systematic (but otherwise unaccounted for) differences in the e-voting and not e-voting counties in that particular state.

Below the density plots, we see the regression coefficient _beta_, standard error _s.e._, and t-score _t_ for that state's model. In only two of 22 analyzed states is _e-voting_ a significant predictor of vote share at traditional levels of confidence. In Wisconsin counties with e-voting were more likely to lean Trump than Clinton. However, in Wyoming, counties with e-voting leaned Clinton over Trump. Neither of these results holds up to a [Bonferroni correction](https://en.wikipedia.org/wiki/Bonferroni_correction) for multiple hypothesis testing and should therefore be viewed skeptically. See the [edit] below for results from an alternative modeling strategy.

<figure>
    <img src="/images/2016-11-24/population_map.png" alt="Population by county in the United States.">
    <figcaption>
        Population by county in the United States.
    </figcaption>
</figure>

<h2>Conclusion</h2>
This miniature study finds no compelling evidence that electronic voting machines were biased for or against either of the candidates in the 2016 U.S. presidential election. This result agrees with a similar analysis by Nate Silver. However, there are a few caveats:

* It is unlikely that hackers would target all electronic voting machines rather than a particular make or model of machine. Given that each model is likely to run on its own software and contain its own unique vulnerabilities, hackers may be more likely to single out a particular brand or type of voting machine rather than target an entire state's worth of voting machines. A follow-up analysis should consider machine make and model as a predictor of vote share. Voting machine make and model are included in the [provided data](https://www.github.com/benradford/electiogeddon).
* Hackers are smart and will cover their tracks well. The fact that county-level vote manipulation is not obvious from this analysis does not mean that vote hacking did not occur. It only means that, if it did, the perpetrators were more clever than I assume here.

I encourage anybody interested in politics and data analysis to replicate and expand on this study. The code and data to get started are available for free [here](https://www.github.com/benradford/electiogeddon).

<h2>Update</h2>
Thanks to a good suggestion in the comments from Tracy Carr, I have repeated the state-level analysis using generalized linear models and stipulating a quasi-binomial response variable (proportion of votes received by GOP). I have elected to use a quasi-binomial over a standard binomial distribution to allow the model to account for under or over-dispersion in observed vote proportions from county to county. The results are visualized below. Estimated t-scores and relative predicted values largely mirror those described by the linear models above.

<figure>
    <img src="/images/2016-11-24/dre_states_quasibinomial.png" alt="State-by-state predicted values for GOP vote proportion given the presence of e-voting machines and their absence. Models assume a binomial response with possible under or over-dispersion (quasi-binomial).">
    <figcaption>
        State-by-state predicted values for GOP vote proportion given the presence of e-voting machines and their absence. Models assume a binomial response with possible under or over-dispersion (quasi-binomial).
    </figcaption>
</figure>

Additionally, I have re-estimated the national-level models. The results are below. Again, these are generalized linear models and an assumed quasi-binomial response. Due to the limitations of my preferred R package for estimated mixed effects models, I have instead opted to use state fixed effects. The fixed effects are omitted here.

```
Bivariate model
Estimate Std. Error t value Pr(>|t|)
(Intercept)         0.64841    0.07368   8.800  < 2e-16 ***
electronic          0.04608    0.03471   1.328 0.184416

Multiple regression model
Estimate Std. Error t value Pr(>|t|)
(Intercept)         0.6808860  0.1179998   5.770 8.71e-09 ***
electronic          0.0113319  0.0225596   0.502 0.615485
population         -0.0855596  0.0069790 -12.260  < 2e-16 ***
unemployment       -0.0774218  0.0056691 -13.657  < 2e-16 ***
college            -0.0284239  0.0011195 -25.389  < 2e-16 ***
percent_white       0.0285929  0.0006607  43.275  < 2e-16 ***
```