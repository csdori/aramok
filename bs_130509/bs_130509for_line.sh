#!/bin/sh


for dist in `seq 10 10 60`
do

echo $dist
	
	echo $dist > celleldist.txt
	#number of electrodes
	elnum='16'
	echo $elnum > elnum.txt

	#Run the LFPy code for ballstick model
	ipython bs_130509.py  
	#ipython bs_syn.py
	#ipython bs_syn_many.py

for bnum in `seq 40 20 80`
do
for bwidth in `seq 20 10 50`
do

	#This script should set the parameters
	#cell to electrode distance DISTANCE=10	
	
	# set width of base function
	#bwidth='40'
	echo $bwidth > basewidth.txt
	

	# set type of base function ('step or gauss'
	#btype='step'
	btype='gauss'
	#btype='cos'
        #btype='sinxpx'
	echo $btype > basetype.txt
	#set number of base function
	#bnum='60'
	echo $bnum > basenum.txt

	#Run the R Sweave code for ballstick model
	R CMD Sweave bs_1D_130509line.Rnw
	#Compile the latex file
	pdflatex bs_1D_130509line.tex 

	#el.nb=10
	#seg.db=18
	#copy the compiled file to a specific destination
	cp bs_1D_130509line.pdf out0516/'line_'$btype'_'$bwidth'_dist'$dist'_el'$elnum'_seg20_bn'$bnum'.pdf'
done
done
done

