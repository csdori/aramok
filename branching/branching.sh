#!/bin/sh


#sh ./branching.sh  #to run this script

#for btype in 'step' 'gauss' 'cos' 'sinxpx'
for btype in   'gauss' 
do

for dist in `seq 30 10 30`
do

echo $dist
	
	echo $dist > celleldist.txt
	#number of electrodes
	elnum='16'
	echo $elnum > elnum.txt

#Morphology
	morpho='/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/morphology/03a_pyramidal9aFI.CNG2.swc'
	#morpho='/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/branching.swc'
	morpho='/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/morphology/morpho1.swc'
	echo $morpho > morphology.txt
	#cell to electrode distance DISTANCE=10	



	#Run the LFPy code for ballstick model
	ipython branching.py  
	#ipython bs_syn.py
	#ipython bs_syn_many.py

for bnum in `seq 80 20 120`
do
for bwidth in `seq 10 5 40`
do

	#This script should set the parameters
		
	
	
	# set width of base function
	#bwidth='40'
	echo $bwidth > basewidth.txt
	

	echo $btype > basetype.txt
	#set number of base function
	#bnum='60'
	echo $bnum > basenum.txt

	#Run the R Sweave code for ballstick model
	R CMD Sweave ksCSD_branching.Rnw
	#Compile the latex file
	pdflatex ksCSD_branching.tex 

	#el.nb=10
	#seg.db=18
	#copy the compiled file to a specific destination
	cp ksCSD_branching.pdf out_branch/'line_'$btype'_'$bwidth'_dist'$dist'_el'$elnum'_seg20_bn'$bnum'.pdf'
done
done
done
done


