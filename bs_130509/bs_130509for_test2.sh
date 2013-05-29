#!/bin/sh

#for btype in 'step' 'gauss' 'gauss2' 'cos' 'sinxpx'
for btype in   'gauss2' 
do
#for dist in `seq 10 10 60`
for dist in `seq 30 10 30`

do

echo $dist
	
	echo $dist > celleldist.txt
	#number of electrodes
	elnum='32'
	echo $elnum > elnum.txt

	#ipython bs_syn_many.py

for bnum in `seq 40 20 80`
do
for bwidth in `seq 10 10 50`
do

	#This script should set the parameters
	#cell to electrode distance DISTANCE=10	
	
	# set width of base function
	#bwidth='40'
	echo $bwidth > basewidth.txt
	

	# set type of base function ('step or gauss'
	#btype='step'
	#btype='gauss'
	#btype='cos'
        #btype='sinxpx'
	echo $btype > basetype.txt
	#set number of base function
	#bnum='60'
	echo $bnum > basenum.txt

	#Run the R Sweave code for ballstick model
	R CMD Sweave bs_1D_130509test2.Rnw
	#Compile the latex file
	pdflatex bs_1D_130509test2.tex 

	#el.nb=10
	#seg.db=18
	#copy the compiled file to a specific destination
	cp bs_1D_130509test2.pdf out_test/'test_'$btype'_'$bwidth'_dist'$dist'_el'$elnum'_seg20_bn'$bnum'.pdf'
done
done
done
done

