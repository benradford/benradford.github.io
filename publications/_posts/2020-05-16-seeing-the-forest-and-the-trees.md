---
layout: publication
categories: publications

title: Seeing the Forest and the Trees
subtitle: Detection and Cross-Document Coreference Resolution of Militarized Interstate Disputes
author: Benjamin J. Radford
venue: Proceedings of AESPEN 2020, LREC 2020
pages: 35--41

link-text: PDF
link-download: https://www.aclweb.org/anthology/2020.aespen-1.7.pdf

featured-image: /images/forest-header-1.png
tags: [event extraction, machine learning, security studies & war]
date: 2020-05-16
---

Previous efforts to automate the detection of social and political events in text have primarily focused on identifying events described within single sentences or documents. Within a corpus of documents, these automated systems are unable to link event references—recognize singular events across multiple sentences or documents. A separate literature in computational linguistics on event coreference resolution attempts to link known events to one another within (and across) documents. I provide a data set for evaluating methods to identify certain political events in text and to link related texts to one another based on shared events. The data set, Headlines of War, is built on the Militarized Interstate Disputes data set and offers headlines classified by dispute status and headline pairs labeled with coreference indicators. Additionally, I introduce a model capable of accomplishing both tasks. The multi-task convolutional neural network is shown to be capable of recognizing events and event coreferences given the headlines’ texts and publication dates.