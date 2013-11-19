#!/bin/sh


#bash main.sh  #to run this script
	
	#number of electrodes
	#elnum='32'
	#echo $elnum > elnum.txt
	#where is the file with the coordinates of the electrodes
	eleccord='/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/elcoord_x_y_z'
	echo $eleccord > elwhere.txt
#Morphology
	#morpho='/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/morphology/03a_pyramidal9aFI.CNG2.swc'
	#morpho='/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/branching.swc'
	#morpho='/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/morphology/morpho1.swc'
	#morpho='/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/morphology/gulyas_pv08b.swc'
	#morpho='/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/morphology/villa.swc'
	morpho='/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/morphology/ballstick.swc'

	echo $morpho > morphology.txt
	#let's give a name to this cell
	#cellname='gulyas_pv08b'
	cellname='ballstick'  
	echo $cellname > cellname.txt
	#Run the LFPy code for generating membrane currents and EC potentials
	#ipython branching.py
	ipython branching_villa.py  
	echo 'simulation of EC ready!'


#the branching_villa python code saves the length of the cell, lets read it back
celllength=$(< celllength)
echo 'The total length of the branchis is:' $celllength
#there is a minimum number of basis functions needed if we want to cover the cell with them
#this number should be bigger than the number of electrodes
elnum=$(< elnum.txt)

#Hogyan járjuk be az egész paraméterteret???
#paraméterek: bnum,bwidthc

#number of basis functions
#for bnum in `seq 80 20 120`
((bnumlow=elnum))
((bnumstep=elnum*2))
((bnumhigh=elnum*8))

echo -n "" > parameterek.txt
#type of base functions
for btype in  'gauss' 'cos' 
do
for bnum in `seq $bnumlow $bnumstep $bnumhigh`

#for bnum in `seq $bnumlow $elnum $bnumhigh`
do
#width of basis functions
((bwidthlow=celllength / bnum ))

((bwidthigh=celllength/bnum*3))
((bwidthstep=bwidthigh/2-bwidthlow/2))
for bwidth in `seq $bwidthlow $bwidthstep $bwidthigh`
do
#for bwidth in `seq $bwidthlow $bwidthstep $bwidthigh`
#for bwidth in `seq 10 10 40`

	#This script should set the parameters
	
	
	echo $btype $bwidth $bnum
	echo $btype $bwidth $bnum >> parameterek.txt
	# set width of base function
	#bwidth='40'
	echo $bwidth > basewidth.txt
	

	echo $btype > basetype.txt
	#set number of base functionecho $btype $bwidth $bnum >> parameterek.txt
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



#calculating traditional CSD
Rscript /media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/trad_CSD.R

#cd /media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/out_$cellname/pics
#for a in `ls -1` ; do convert $a $a.gif; done
#gifsicle --delay 30 --colors 256 `ls -1 CSD*.gif` > tradCSD.gif
#rm s*


#this creates the gif animation
#cd /media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/out_$cellname/pics
#for a in `ls -1` ; do convert $a $a.gif; done
#gifsicle --delay 30 --colors 256 `ls -1 *.gif` > ksCSD_test.gif
#rm s*




