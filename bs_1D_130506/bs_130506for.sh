#!/bin/sh

for dist in `seq 10 10 60`
do
	#This script should set the parameters
	#cell to electrode distance DISTANCE=10	
	echo $dist
	
	echo $dist > celleldist.txt
	# set width of base function
	bwidth='20'
	echo $bwidth > basewidth.txt
	# set type of base function ('step or gauss'
	btype='step'
	#btype='gauss'
	echo $btype > basetype.txt

	#Run the LFPy code for ballstick model
	ipython bs_130506.py  #setting the distance at the end
	#Run the R Sweave code for ballstick model
	R CMD Sweave bs_1D_130506.Rnw
	#Compile the latex file
	pdflatex bs_1D_130506.tex 

	#el.nb=10
	#seg.db=18
	#copy the compiled file to a specific destination
	cp bs_1D_130506.pdf out/$bytpe'_'$bwidth'_dist'$dist'_el20_seg27.pdf'
done
