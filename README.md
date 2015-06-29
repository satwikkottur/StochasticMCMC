## StochasticMCMC
MCMC for posterior distribution sampling

[Satwik Kottur](https://github.com/satwikkottur) and [Krishna Pillutla](https://github.com/krishnap25), Carnegie Mellon University

This project is a part of [10-708: Probabilistic Graphical Models](http://www.cs.cmu.edu/~epxing/Class/10708/), Fall 2015, in
requirement for the course completion.

The idea is to handle non-smooth energy functions in the setting of Hamiltonian dynamics for Monte Carlo Markov chain (MCMCM) sampling. Hamiltonian Monte Carlo (HMC) methods evolve a set of differential equations and non-smooth energies do not fit in, as in. The [report](https://github.com/satwikkottur/StochasticMCMC/blob/master/report.pdf) provides further details on the various strategies adopted to solve the problem.

Parts of the code are adapted from two sources:
 1. [Hamiltonian Monte Carlo MATLAB Implementation](http://www.mathworks.com/matlabcentral/fileexchange/2654-netlab/content/hmc.m)
 2. [Tianqi Chen's Implementation for Stochastic Gradient-HMC](https://github.com/tqchen/ML-SGHMC)
 
