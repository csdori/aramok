
library('scatterplot3d')
library('foreach')
library('doMC')
library('fields')
library('MASS')
#branching detailes based on the morphology file
workingdirectory<-'/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching'
setwd(workingdirectory)
source('alprogik/branching_info.R')
####################################
####Plotting


#coordinates of electrode
elwhere<-read.table('elwhere.txt')
elec.kord<-as.matrix(read.table(paste(elwhere[1,1])))
elec.kord<-matrix(elec.kord,ncol=3)
elec.dist<-elec.kord[2,3]-elec.kord[1,3]
el.nb<-dim(elec.kord)[1] #number of electrodes
sigma<-as.matrix(read.table('elprop'))[2] #sigma

#Reading in the segment information from LFPy
seg.cord<-as.matrix(read.table('coordsmid_x_y_z'))
seg.cord<-matrix(seg.cord,ncol=3)
#seg.kord<-matrix(0,c(dim(seg.cord)))
seg.kord<-seg.cord
seg.start<-matrix(as.matrix(read.table('coordsstart_x_y_z')),ncol=3)
seg.end<-matrix(as.matrix(read.table('coordsend_x_y_z')),ncol=3)
seg.diam<-as.matrix(read.table('segdiam_x_y_z'))
seg.db<-length(seg.diam)

segbranches<-1
br<-1
for (i in 1:(seg.db-1)){
if (seg.start[i+1,1]==seg.end[i,1] & seg.start[i+1,2]==seg.end[i,2] & seg.start[i+1,3]==seg.end[i,3]){
 segbranches<-c(segbranches,br)
}

if (seg.start[i+1,1]!=seg.end[i,1] | seg.start[i+1,2]!=seg.end[i,2] | seg.start[i+1,3]!=seg.end[i,3]) {
br<-br+1
segbranches<-c(segbranches,br)
}
}

#segbranch.num<-length(seg.diam)
segbranch.nb<-max(segbranches)

segbranch.comp.nb<-numeric(segbranch.nb)
for(k in 1: segbranch.nb){
segbranch.comp.nb[k]<-length(which(segbranches==k))
}



segbranch.coords<-list()
for (j in 1:segbranch.nb){

cordmatr<-array(0,c(segbranch.comp.nb[[j]]+1,3))
cordmatr[1:segbranch.comp.nb[j],]<-seg.start[which(segbranches==j),]
cordmatr[segbranch.comp.nb[j]+1,]<-seg.end[which(segbranches==j)[segbranch.comp.nb[j]],]
segbranch.coords[[j]]<-cordmatr
}
mit.x<-1#1
mit.y<-2#2
colours<-color.scale(branches,col=rainbow(branch.nb))


#png("morpho1.png",width=300,height=600)
plot(alak[,mit.x+2],alak[,mit.y+2],col=colours,pch=20,cex=1.5,xlab='x (um)',ylab='y (um)',main='Cell morphology',asp=1)
points(alak[branching.points,mit.x+2],alak[branching.points,mit.y+2],col='BLACK',pch=1,cex=1.5)
points(seg.start[,mit.x],seg.start[,mit.y])
points(seg.end[,mit.x],seg.end[,mit.y],col='RED')
points(seg.cord[,mit.x],seg.cord[,mit.y],col='BLUE')
#dev.off()



##############################################xx
