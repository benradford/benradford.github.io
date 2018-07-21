---
layout: publication

title: Sequence Aggregation Rules for Anomaly Detection in Computer Network Traffic
subtitle:  
author: Benjamin J. Radford, Bartley D. Richardson, Shawn E. Davis
venue: American Statistical Association's Symposium on Data Science and Statistics 2018

link-text: Available on arXiv
link-download: ttps://arxiv.org/abs/1805.03735

featured-image: /images/default-header.png
tags: [cybersecurity]
date-string: May 9, 2018
---

We evaluate methods for applying unsupervised anomaly detection to cybersecurity applications on computer network traffic data, or flow. We borrow from the natural language processing literature and conceptualize flow as a sort of "language" spoken between machines. Five sequence aggregation rules are evaluated for their efficacy in flagging multiple attack types in a labeled flow dataset, CICIDS2017. For sequence modeling, we rely on long short-term memory (LSTM) recurrent neural networks (RNN). Additionally, a simple frequency-based model is described and its performance with respect to attack detection is compared to the LSTM models. We conclude that the frequency-based model tends to perform as well as or better than the LSTM models for the tasks at hand, with a few notable exceptions.
