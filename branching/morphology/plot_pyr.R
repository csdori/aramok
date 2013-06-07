


#I took a random cell morphology from neuromorpho
#http://neuromorpho.org/neuroMorpho/neuron_info.jsp?neuron_name=03a_pyramidal9aFI
#This program:
#gets the coordinates
#finds the branching points
#calculates a function for the branching points

#melyik szegmenshez kapcsolódik,soma-apical-basal,x,y,z, d, melyik másik szegmenshez kapcsolódik

#alak:shape of the cell.
alak<-as.matrix(read.table('morphology/pyramid.txt'))
#SWC: There are four default segment tags in SWC: 1 soma, 2 axon, 3 dendrite (basal when apical present), and 4 apical dendrite.
#The three dimensional structure of a neuron can be represented in a SWC format (Cannon et al., 1998). SWC is a simple Standardized format. Each line has 7 fields encoding data for a single neuronal compartment:
#an integer number as compartment identifier
#type of neuronal compartment 
#x coordinate of the compartment
#y coordinate of the compartment
#z coordinate of the compartment
#radius of the compartment
#parent compartment


seg.nb<-dim(alak)[1] #number of segments
#how many points represent the soma<-
soma<-3



#finding the branching points
branching.points<-numeric()
#which segment belongs to which branch
branches<-numeric()

#just some counters
j<-0
#soma
branch.seg.nb<-3
branches<-c(rep(1,soma))
j<-j+1
for (i in (soma+1): (seg.nb)){
if(alak[i,1]!=(alak[i,7]+1)){ 
branching.points<-c(branching.points,i)
j<-j+1
}
branches<-c(branches,j)
}

remove(j,i,branch.seg.count)
#number of branches
branch.nb<-max(branches)
#how many segments are there in a branch
branch.seg.nb<-numeric(branch.nb)
for(k in 1: branch.nb){
branch.seg.nb[k]<-length(which(branches==k))
}



#3D plot
colours<-color.scale(branches,col=rainbow(branch.nb))
sc<-scatterplot3d(alak[,3],alak[,4],alak[,5],color=colours,pch=20)
sc$points3d(alak[branching.points,3],alak[branching.points,4],alak[branching.points,5],col='BLACK',pch=20)

#2D plot
colours<-color.scale(branches,col=rainbow(branch.nb))
plot(alak[,3],alak[,4],col=colours,pch=20,cex=1.5,xlab='x',ylab='y',main='Cell morphology')
points(alak[branching.points,3],alak[branching.points,4],col='BLACK',pch=20,cex=1.5)


#length of branches and the segments in the branches
branch.length<-numeric(branch.nb)
seg.length<-list(branch.nb)
for(j in 1: branch.nb){
lengthseg<-numeric()
if(branch.seg.nb[j]!=1){
for (i in 1: (branch.seg.nb[j]-1)){
wh<-sum(branch.seg.nb[0:(j-1)])+i #which
lengthseg<-c(lengthseg,sqrt((alak[wh+1,3]-alak[wh,3])^2+(alak[wh+1,4]-alak[wh,4])^2+(alak[wh+1,5]-alak[wh,5])^2))

}
seg.length[[j]]<-lengthseg
} else seg.length[[j]]<-0
branch.length[j]<-sum(seg.length[[j]])
}#j
remove(wh,j,i)

#equations fo the line on the branches
#a splinefun tud ilyet is....
#problem, the t parameter i s not going evenly, the distance between the segmentse differ a lot, we shoul somehow rescale this...

vonal<-list(branch.nb)
vonalfun<-list(branch.nb)
for(j in 1:branch.nb){
if(branch.seg.nb[j]!=1){
coords<-alak[which(branches==j),c(1,3,4,5)]
ts<-seq( from = min(coords[,1]),  max(coords[,1]), length=100 )
vonal[[j]]<-apply( coords[,-1], 2, function(u) spline( c(coords[,1]), u, xout = ts )$y ) 
vonalfun[[j]]<-apply( coords[,-1], 2, function(u) splinefun( c(coords[,1]), u,method="monoH.FC")(x) ) 
} 

else {vonal[[j]]<-alak[which(branches==j),c(3,4,5)]
vonalfun[[j]]<-NA
}
}
#curve(vonalfun[[j]]$V3(x),790,820)
#theát itt már vannak függvények, amikre lehet bázisfüggvényket pakolászni stb

library(scatterplot3d)
p <- scatterplot3d(vonal[[3]], type="l", lwd=3,xlim=range(alak[,3]),ylim=range(alak[,4]),zlim=range(alak[,5]))
for(i in 4:15 ){
p$points(vonal[[i]], type="l", lwd=3)

}




p$points3d( coords[,-1], type="h" )













