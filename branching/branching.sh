#!/bin/sh


#sh ./branching.sh

#for btype in 'step' 'gauss' 'cos' 'sinxpx'
for btype in   'gauss' 
do

for dist in `seq 30 10 30`
do

echo $dist
	
	echo $dist > celleldist.txt
	#number of electrodes
	elnum='32'
	echo $elnum > elnum.txt

	#Run the LFPy code for ballstick model
	ipython branching.py  
	#ipython bs_syn.py
	#ipython bs_syn_many.py

for bnum in `seq 80 20 80`
do
for bwidth in `seq 25 10 35`
do

	#This script should set the parameters
	#cell to electrode distance DISTANCE=10	
	
	# set width of base function
	#bwidth='40'
	echo $bwidth > basewidth.txt
	

	echo $btype > basetype.txt
	#set number of base function
	#bnum='60'
	echo $bnum > basenum.txt

	#Run the R Sweave code for ballstick model
	#R CMD Sweave branching.Rnw
	#Compile the latex file
	#pdflatex branching.tex 

	#el.nb=10
	#seg.db=18
	#copy the compiled file to a specific destination
	#cp bs_1D_130509line.pdf out_branch/'line_'$btype'_'$bwidth'_dist'$dist'_el'$elnum'_seg20_bn'$bnum'.pdf'
done
done
done
done


