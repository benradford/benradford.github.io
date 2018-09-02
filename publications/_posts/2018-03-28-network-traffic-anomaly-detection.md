---
layout: publication

title: Network Traffic Anomaly Detection Using Recurrent Neural Networks
subtitle: 
author: Benjamin J. Radford, Leonardo M. Apolonio, Antonio J. Trias, and Jim A. Simpson
venue: Procedings of the 2017 National Symposium on Sensor and Data Fusion

link-text: Available on arXiv
link-download: https://arxiv.org/abs/1803.10769

featured-image: /images/fiber-optic-header-1.png
tags: [cybersecurity]
date: 2018-03-03
---

We show that a recurrent neural network is able to learn a model to represent sequences of communications between computers on a network and can be used to identify outlier network traffic. Defending computer networks is a challenging problem and is typically addressed by manually identifying known malicious actor behavior and then specifying rules to recognize such behavior in network communications. However, these rule-based approaches often generalize poorly and identify only those patterns that are already known to researchers. An alternative approach that does not rely on known malicious behavior patterns can potentially also detect previously unseen patterns. We tokenize and compress netflow into sequences of "words" that form "sentences" representative of a conversation between computers. These sentences are then used to generate a model that learns the semantic and syntactic grammar of the newly generated language. We use Long-Short-Term Memory (LSTM) cell Recurrent Neural Networks (RNN) to capture the complex relationships and nuances of this language. The language model is then used predict the communications between two IPs and the prediction error is used as a measurement of how typical or atyptical the observed communication are. By learning a model that is specific to each network, yet generalized to typical computer-to-computer traffic within and outside the network, a language model is able to identify sequences of network activity that are outliers with respect to the model. We demonstrate positive unsupervised attack identification performance (AUC 0.84) on the ISCX IDS dataset which contains seven days of network activity with normal traffic and four distinct attack patterns.
