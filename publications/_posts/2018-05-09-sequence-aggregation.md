---
layout: publication
categories: publications

title: Sequence Aggregation Rules for Anomaly Detection in Computer Network Traffic
subtitle:  
author: Benjamin J. Radford, Bartley D. Richardson, Shawn E. Davis
venue: American Statistical Association's Symposium on Data Science and Statistics 2018

link-text: arXiv:1805.03735
link-download: https://arxiv.org/abs/1805.03735

featured-image: /images/silicon-chip-header-1.png
tags: [cybersecurity incident detection, machine learning]
date: 2018-05-09
---

We evaluate methods for applying unsupervised anomaly detection to cybersecurity applications on computer network traffic data, or flow. We borrow from the natural language processing literature and conceptualize flow as a sort of "language" spoken between machines. Five sequence aggregation rules are evaluated for their efficacy in flagging multiple attack types in a labeled flow dataset, CICIDS2017. For sequence modeling, we rely on long short-term memory (LSTM) recurrent neural networks (RNN). Additionally, a simple frequency-based model is described and its performance with respect to attack detection is compared to the LSTM models. We conclude that the frequency-based model tends to perform as well as or better than the LSTM models for the tasks at hand, with a few notable exceptions. 

Replication files are available at [https://github.com/benradford/replication_arxiv_1805_03735](https://github.com/benradford/replication_arxiv_1805_03735).
