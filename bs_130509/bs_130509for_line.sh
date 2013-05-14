#!/bin/sh

for dist in `seq 10 10 60`
do
	#This script should set the parameters
	#cell to electrode distance DISTANCE=10	
	echo $dist
	
	echo $dist > celleldist.txt
	# set width of base function
	bwidth='100'
	echo $bwidth > basewidth.txt
	#number of electrodes
	elnum='10'
	echo $elnum > elnum.txt
	# set type of base function ('step or gauss'
	#btype='step'
	btype='gauss'
	echo $btype > basetype.txt
	#set number of base function
	bnum='27'
	echo $bnum > basenum.txt
	#Run the LFPy code for ballstick model
	#ipython bs_130509.py  #setting the distance at the end
	ipython bs_syn.py
	#Run the R Sweave code for ballstick model
	R CMD Sweave bs_1D_130509line.Rnw
	#Compile the latex file
	pdflatex bs_1D_130509line.tex 

	#el.nb=10
	#seg.db=18
	#copy the compiled file to a specific destination
	cp bs_1D_130509line.pdf out/'line_'$btype'_'$bwidth'_dist'$dist'_el'$elnum'_seg27bn'$bnum'.pdf'
done
