#!/bin/sh


#sh ./main.sh  #to run this script
	
	#number of electrodes
	elnum='32'
	echo $elnum > elnum.txt
	#where is the file with the coordinates of the electrodes
	eleccord='/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/elcoord_x_y_z'
	echo $eleccord > elwhere.txt
#Morphology
	#morpho='/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/morphology/03a_pyramidal9aFI.CNG2.swc'
	#morpho='/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/branching.swc'
	#morpho='/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/morphology/morpho1.swc'
	#morpho='/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/morphology/gulyas_pv08b.swc'
	morpho='/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/morphology/villa.swc'
	

	echo $morpho > morphology.txt
	#let's give a name to this cell
	#cellname='gulyas_pv08b'
	cellname='villa'  
	echo $cellname > cellname.txt
	#Run the LFPy code for generating membrane currents and EC potentials
	ipython branching.py  
#type of base dunctions
for btype in 'cos' 'gauss' 
do

#number of basis functions
for bnum in `seq 80 20 120`
do
#width of basis functions
for bwidth in `seq 30 10 60`
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
	R CMD Sweave /media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/ksCSD_main.Rnw
	#Compile the latex file
	pdflatex /media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/ksCSD_main.tex 

	#el.nb=10
	#seg.db=18
	#copy the compiled file to a specific destination
	cp /media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/ksCSD_main.pdf /media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/out_$cellname/'main_line_'$btype'_'$bwidth'_dist'$dist'_el'$elnum'_seg20_bn'$bnum'.pdf'
done
done
done

#run R once more with the best parameters, produce gif and output file
R CMD Sweave /media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/ksCSD_best.Rnw
#Compile the latex file
pdflatex /media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/ksCSD_best.tex 

#this creates the gif animation
cd /media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/out_$cellname/pics
for a in `ls -1` ; do convert $a $a.gif; done
gifsicle --delay 30 --colors 256 `ls -1 *.gif` > ksCSD_test.gif
rm s*




