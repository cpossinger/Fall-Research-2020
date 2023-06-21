---
title: "Fall 2020 Medfly Research"
description: |
    Initial Research for Functional Principal Compotnent Analysis of Medfly Hazard Functions.
author:
  - name: Camden Possinger
    along with: Joanne Xiong, Han Chen, and Professor Hans Georg-Mueller
    affiliation: UC Davis
date: "2020-12-17"
bibliography: bibliography.json
output:  distill::distill_article
runtime: shiny
---



## Introduction 

One of the greatest mysteries that humankind has ever tried to solve is the secrets of longevity. Why do some live longer and some shorter? Can we do anything to prolong our longevity? While we don't have all the answers yet humankind has been slowly but surely uncovering the mystery behind longevity. This study will not fully uncover the relationships that affect longevity, but hopefully it will contribute and spark interest in this area of study in order to one day fully understand human longevity. In the initial exploratory data analysis and eventual formal analysis we aim to analyze the variance of male and female medfly hazard functions.   

## Why Medflies?

![[@lCeratitisCapitata1915]](/home/cam/Downloads/medfly.jpg) 

When considering longevity Medflies aren't the test species most people would think of. Medflies only live to be a maximum of fifty days old,which is enough time for them to reproduce and either get eaten or die of old age. Medfly's short lifespan is an advantage for us as researchers because we only have to wait fifty days for a whole generation to be born and die. If something goes wrong less time will be wasted on that research. Traditional test species like mice live for a couple years, which is a larger time investment and it is more devastating if something goes wrong. Another advantage of Medflies is that they are not protected by Animal Rights regulations. This is especially helpful in studies of how stress affects longevity. Medflies are also cheaper and easier to manage in large numbers, which is advantages for statistical studies whose power is fueled by large quantities of data. 
  There have been many different types of studies on  Medflies that study various aspects of longevity. Since there are no animal rights protections for medflies researchers are able to study how standardized acute trauma affects a fly's remaining life expectancy. This allows researchers the ability to study frailty and potentially extrapolate those insights to other animal models [@careyDietShapesMortality2016]. Studying medflies also gives researchers a look into potentially the mechanics of evolution. It is known that females generally live longer than males in Medflies. Researchers have attributed this to the female reproductive period where resources that would normally be allocated for maintenance and repair are used for reproduction [@mullerEarlyMortalitySurge1997 p.3]. This reproduction possibly weeds out the weaker female flies and creates a healthier population moving forward. This makes sense from an evolutionary perspective because it is not in a species' best interest to allow frailer females the opportunity to reproduce. If only the strong female flies are able to reproduce then the species would not evolve in a beneficent way. Finally researchers are able to study other possible indicators of mortality like declining neurological behavior. When fruit flies are close to the end of their lives they spend their time on their backs helpless and unable to move. This supine behavior has been linked as an biological marker that a fly is at the end of it's life. This has potential implications for research of human diseases that cause neurological decline like Parkinson's disease [@papadopoulosSupineBehaviourPredicts2002]. 
  Medflies are considered a nuisance by most but for us as researchers they serve as a useful model species, which we can study to understand longevity in the animal kingdom and in humans.

## Probability Density Function, Survival Function, Hazard Function

Our area of interest for this research is the hazard function, but before we talk about the hazard function we need to construct it first. In order to construct the hazard function we need to discuss the Probability Density Function and Survival Function. We need to construct the Probability Density Function of the survival time. Since our distribution of time is discrete the Probability Density Function is $f(x) = Pr[X = x]$ where the Probability Density Function is the probability that the variate has the value x [@RelatedDistributions]. Next we need the Survival Function which indicates the time before a certain event happens. The Survival Function $S(t)$ is defined as $S(t) = Pr[T > t]$ where $t$ is some time and $T$ is some random variable that represents the time of an event happening which in most cases is the time of death [@SurvivalAnalysis2020]. Now that we have defined the Probability Density Function and the Survival Function we can define the Hazard Function. The Hazard Function denoted as $h_Y(y)$ is defined as $h_Y(y) = \frac{f_Y(y)}{S_Y(y)}$ where $f_Y(y)$ is the probability density function of survival time Y and $S_Y$ is the survival function [@stephanieHazardFunctionSimple2016].    

## Functional Principal Component Analysis
In today's world the cost of data collection has gone down and computing power has gone up creating many situations where high dimensional data is being collected. When each data point is recorded enough times we get dense functional data that emulate a function or curve. The problem with this type of analysis is that it is infinitely dimensional and ironically it's difficult to obtain any information from an infinite amount of information. Thankfully there are dimensionality reduction methods that take an infinitely dimensional problem and coverts it into a finite problem where we can gain useful information. One of the main dimension reduction methods is Principal Component Analysis (PCA). I'm not qualified yet to explain all of the intricate linear algebra theory behind this method, but conceptually PCA takes a complex data matrix, which has a potentially noisy or redundant native basis and changes that basis to a basis that will best represent the given data. To achieve this goal a general solution is to use Singular Value Decomposition (SVD) to decompose an arbitrary $m \times n$ data matrix X so that it can be expressed in terms of:

An orthogonal matrix of orthonormal eigenvectors V where $V = [\hat{v_1} \hat{v_2} . . . \hat{v_m}]$ for the symmetric matrix $X^TX$

A diagonal matrix $\Sigma$ consisting of rank ordered singular values $\sigma_{i}$ derived by $\sigma_{i} = \sqrt{\lambda_{i}}$ where $\lambda_{i} = \{\lambda_1,\lambda_2, . . .,\lambda_{r}\}$ are the eigenvalues of the eigenvectors in V for $X^TX$

Another orthogonal matrix U defined by $U = [\hat{u_1} \hat{u_2} . . . \hat{u_n}]$ where $\hat{u_i}$ is defined as $\hat{u_n} = \frac{1}{\sigma_{i}}X\hat{v_i}$

We can express X such that $X = V\Sigma U$

Continuing with the PCA method if we have an $m \times n$ data matrix X an $n \times m$ matrix Y can be expresses as $Y = \frac{1}{\sqrt{n}}X^T$. It can be shown that $Y^TY = C_{x}$ where $C_{x}$ is the covariance matrix of X. We can calculate the SVD of Y which contains the eigenvectors of $C_{x}$ in V. These eigenvectors in the columns of V are the principal components of X. V is also an orthonormal basis that spans the column space of X.   Almost all of this explanation was summarized in a fantastic tutorial paper by Jonathon Shlens [@shlensTutorialPrincipalComponent2014]. 
 The beauty and possible curse of PCA is that you will always be able to obtain an answer from any arbitrary matrix. 
PCA is a useful dimension reduction tool in most situations, but for functional data it can be problematic. For functional data the problem is that for our $m \times n$ data matrix n becomes infinity creating an infinite-dimensional matrix that lives in a Hilbert Space. This curse of dimensionality stems from sparse data when the dimensionality becomes high. Even though we will get a numerical answer from using PCA it has been shown that under this high dimensionality the sample covariance matrix is not a good estimate for the population covariance matrix [@shangSurveyFunctionalPrincipal2014]. To overcome this observation Functional Principal component Analysis was developed.  

Functional Principal Component Analysis (FPCA) is similar to PCA but the notation is converted to accommodate for functions that live in a Hilbert Space. "Vectors are replaced by functions, matrices by compact linear operators, covariance matrices by covariance operators, and scalar products in vector space by scalar products in square-integrable functional space." [@shangSurveyFunctionalPrincipal2014] The goal of FPCA is the same as PCA: find the principal components that maximize the variance while reducing the number of dimensions. In the following exploratory data analysis we calculate the hazard function from our medfly mortality data and visualize the results to find a direction for an eventual FPCA. Additionally we calculate and visualize the eigenfunctions of these hazard functions.    

## Exploratory Data Analysis





