#!/bin/sh
#This script should set the parameters
#DISTANCE=40
#Run the LFPy code for ballstick model
ipython bs_130506.py 
#Run the R Sweave code for ballstick model
R CMD Sweave bs_1D_130506.Rnw
#Compile the latex file
pdflatex bs_1D_130506.tex 

#Parameterek
#R=20
#d=30
#base=step
#el.nb=10
#seg.db=18
#copy the compiled file to a specific destination
cp bs_1D_130506.pdf out/gauss_20_dist10_el10_seg18.pdf

