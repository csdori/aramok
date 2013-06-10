
library(scatterplot3d)


#I took a random cell morphology from neuromorpho
#http://neuromorpho.org/neuroMorpho/neuron_info.jsp?neuron_name=03a_pyramidal9aFI
#This program:
#gets the coordinates
#finds the branching points
#calculates a function for the branching points

#melyik szegmenshez kapcsolódik,soma-apical-basal,x,y,z, d, melyik másik szegmenshez kapcsolódik

#alak:shape of the cell.
#alak<-as.matrix(read.table('morphology/pyramid.txt'))
alak<-as.matrix(read.table('branching.swc'))
#SWC: There are four default segment tags in SWC: 1 soma, 2 axon, 3 dendrite (basal when apical present), and 4 apical dendrite.
#The three dimensional structure of a neuron can be represented in a SWC format (Cannon et al., 1998). SWC is a simple Standardized format. Each line has 7 fields encoding data for a single neuronal compartment:
#an integer number as compartment identifier
#type of neuronal compartment 
#x coordinate of the compartment
#y coordinate of the compartment
#z coordinate of the compartment
#radius of the compartment
#parent compartment


comp.nb<-dim(alak)[1] #number of compartments
soma<-length(alak[which(alak[,2]==1)]) #how many points represent the soma
branching.points<-numeric() #finding the branching points
branches<-numeric() #which segment belongs to which branch
branch.nb<-numeric() #number of branches

cell.length<-numeric()
##########################
j<-0 #just some counters

branches<-c(rep(1,soma))
j<-j+1
for (i in (soma+1): (comp.nb)){
if(alak[i,1]!=(alak[i,7]+1) | alak[i,2]!=(alak[i-1,2])){ 
branching.points<-c(branching.points,alak[which(alak[,1]==alak[i,7]),1])
j<-j+1
}
branches<-c(branches,j)
}

remove(j,i)
####################################
branch.nb<-max(branches) #number of branches
branch.comp.nb<-numeric(branch.nb) #how many compments are there in a branch

for(k in 1: branch.nb){
branch.comp.nb[k]<-length(which(branches==k))
}
####################################
####Plotting
#3D plot
colours<-color.scale(branches,col=rainbow(branch.nb))
sc<-scatterplot3d(alak[,3],alak[,4],alak[,5],color=colours,pch=20)
sc$points3d(alak[branching.points,3],alak[branching.points,4],alak[branching.points,5],col='BLACK',pch=20)

#2D plot
colours<-color.scale(branches,col=rainbow(branch.nb))
plot(alak[,3],alak[,4],col=colours,pch=20,cex=1.5,xlab='x',ylab='y',main='Cell morphology')
points(alak[branching.points,3],alak[branching.points,4],col='BLACK',pch=20,cex=1.5)
########################################################

 
branch.length<-numeric(branch.nb) #length of branches
comp.length<-list(branch.nb) #compartments in the branches
comp.place<-list(branch.nb) #the distance measured from the beginning of the branch

for(j in 1: branch.nb){
lengthcomp<-numeric()
compplace<-0

for (i in 1: (branch.comp.nb[j])){
wh<-sum(branch.comp.nb[0:(j-1)])+i #which
length<-sqrt(sum((alak[wh,c(3:5)]-alak[which(alak[,1]==alak[wh,7]),c(3:5)])^2))

lengthcomp<-c(lengthcomp,length)
compplace<-c(compplace,compplace[i]+length)
}
comp.place[[j]]<-compplace
comp.length[[j]]<-lengthcomp
branch.length[j]<-sum(comp.length[[j]])
}#j
remove(wh,j,i,lengthcomp,compplace,length)
cell.length<-sum(branch.length) #length of the cell
############################################################
#equations fo the line on the branches
#probléma: 1 pont két branchhez is tartozhat... ez az elágazás
#a splinefun tud ilyet is....
vonal<-list(branch.nb)
vonalfun<-list(branch.nb)
for(j in 1:branch.nb){
#soma
if(j==1){
#A szomán belül elég bánűn vannak megoldva a dolgok, így jobb, ha feltételezésekkel élünk c(2,soma)
t.param<-comp.place[[j]][-1] # a távolságoktól függ... így a görbén egyenletesen lehet elosztani a pontokat.

coords<-alak[which(branches==j),c(1,3,4,5)]
ts<-seq( from = 0, branch.length[j], length=100 )
vonal[[j]]<-apply( coords[c(2,soma),-1], 2, function(u) spline( t.param[c(1,soma)], u, xout = ts )$y ) 
vonalfun[[j]]<-apply( coords[c(2,soma),-1], 2, function(u) splinefun( t.param[c(1,soma)], u,method="monoH.FC") ) 

}
#others
if(j!=1){

t.param<-comp.place[[j]] # a távolságoktól függ... így a görbén egyenletesen lehet elosztani a pontokat.

coords<-alak[c(branching.points[j-1],which(branches==j)),c(1,3,4,5)]
ts<-seq( from = 0, branch.length[j], length=100 )
vonal[[j]]<-apply( coords[,-1], 2, function(u) spline( t.param, u, xout = ts )$y ) 
vonalfun[[j]]<-apply( coords[,-1], 2, function(u) splinefun( t.param, u,method="monoH.FC") ) 
} 
#else {vonal[[j]]<-alak[which(branches==j),c(3,4,5)]
#vonalfun[[j]]<-NA
#}
}
#curve(vonalfun[[j]]$V3(x),0,max(t.param))

#theát itt már vannak függvények, amikre lehet bázisfüggvényket pakolászni stb

#################################################
#Ha van LFPy-os szimuláció






#####################################x
#GETTING DATA AND PARAMETERS
#1D kCSD for cells
#reading in the middle points of the segments
lfpy<-1
if(lfpy==1){
seg.cord<-as.matrix(read.table('coordsmid_x_y_z'))
seg.cord<-matrix(seg.cord,ncol=3)
#seg.kord<-matrix(0,c(dim(seg.cord)))
seg.kord<-seg.cord
seg.start<-matrix(as.matrix(read.table('coordsstart_x_y_z')),ncol=3)
seg.end<-matrix(as.matrix(read.table('coordsend_x_y_z')),ncol=3)
seg.diam<-as.matrix(read.table('segdiam_x_y_z'))
seg.db<-length(seg.diam)

#time
time<-as.matrix(read.table('time'))

#cell to electrode distance
d<-as.matrix(read.table("elprop"))[1]

#length of the segments
seg.length<-as.matrix(read.table('seglength'))

#cell.length<-sum(seg.length)
#coordinates of electrode
elec.kord<-as.matrix(read.table('elcoord_x_y_z'))
elec.kord<-matrix(elec.kord,ncol=3)
elec.dist<-elec.kord[2,3]-elec.kord[1,3]
el.nb<-dim(elec.kord)[1] #number of electrodes
sigma<-as.matrix(read.table('elprop'))[2] #sigma
#membrane currents
memb.currents<-as.matrix(read.table('membcurr'))

M<-as.numeric(read.table('basenum.txt')) #number of sources (a feltételezett

}

########################################
############x Basis functions
#########################################
M<-as.numeric(read.table('basenum.txt'))
source.branch.db<-round(branch.length/cell.length*M)
# real number of the basis functions
M<-sum(source.branch.db)
source.cord<-array(0,c(M,3))
b.cordx<-numeric()
b.cordy<-numeric()
b.cordz<-numeric()
for (j in 1:branch.nb){
t<-seq(0,max(comp.place[[j]]),length.out=source.branch.db[j])
b.cordx<-c(b.cordx,vonalfun[[j]]$V3(t))
b.cordy<-c(b.cordy,vonalfun[[j]]$V4(t))
b.cordz<-c(b.cordz,vonalfun[[j]]$V5(t))
}
source.cord[,1]<-b.cordx
source.cord[,2]<-b.cordy
source.cord[,3]<-b.cordz
remove(t,j,b.cordx,b.cordy,b.cordz)
###############################################
where.cord<-seg.cord
where.db<-seg.db


#########################################
###########LFP
############################################x
LFP<-as.matrix(read.table('myLFP'))
<<parameterek,echo=FALSE>>=

#Parameters



d<-as.matrix(read.table('elprop'))[1] #distance of electrode

#R<- 20 #width of Gaussian or length of step funtion
R<-as.numeric(read.table('basewidth.txt'))

#base<-'step' #type of base function ('step', 'Gaussian')
#base<-'gauss'
base<-paste(readLines('basetype.txt')) #getting it from a text file made by the .sh file
#printing the parameters to the pdf file 
cat(paste('Number of electrodes:',el.nb))
cat(paste('Number of base functions:',M))
cat(paste('Number of segments:',seg.db))
cat(paste('Type of base functions:',base))
cat(paste('Width of base functions:',R, 'um'))
cat(paste('sigma:',sigma))
cat(paste('Shift of overlapping of base functions:', delta, 'um'))
cat(paste('Cell to electrode distance:',d))

@


<<units,echo=FALSE>>=
Units:
cat('Potential 	  [mV]')
cat('Current      [nA]')
cat('Conductivity [S/m]') 
#cat('Capacitance 	[μF/cm2]')
cat('Dimension 	  [μm]')
#cat('Syn. weight 	[nS]')
@




##############################################x
##############xx
########################################

<<bazisfgv,echo=FALSE>>=
#location of base function

const<-1/(4*pi*sigma) 

####################### kCSD
source('alprogik/basisfun.R')

@


<<setup,fig=FALSE,echo=FALSE>>=

db<-1:length(seg.diam)
setwd(hovament)
#source('alprogik/plotsetup.R')
@




##############################################x
##############xx
########################################


library(foreach)
library(doMC)
#registerDoMC(cores=4)
registerDoMC(cores=16)

################# 
#Számoljuk ki a B illetve B.tilda mátrixot
#egy sor egy adott i-hez tartozó fgv, oszlopokban azonos helyekhez tartozó
#[i,j] : az i.függvény a j-dik helyen

source.nb<-M

#branch #melyik branchen vagyunk????


B.tilda<-array(0,c(source.nb,where.db))
B<-array(0,c(source.nb,el.nb))
for(i in 1:source.nb){
whichbranch<-source.branch[i,2]
a<-branch.beg[whichbranch,]
b<-branch.end[whichbranch,]

#cat(i)
Bj.result<-numeric(el.nb)
Bj.result<-foreach(j=1:el.nb,.combine=c) %dopar% {
b.i(i,R,source.cord,elec.kord[j,])
}
B[i,]<-Bj.result

B.t.j.result<-numeric(where.db)
B.t.j.result<-foreach(j=1:where.db,.combine=c) %dopar% {
#b.tilda.i(i,R, source.cord,source.cord[j,]) #ide a t-nek a megfelelő értékét kéne beírni a source coord helyén
b.tilda.i(i,R, source.cord,where.cord[j,]) #if (b[3]-a[3])!=0 !!

}
B.tilda[i,]<-B.t.j.result
#ha az i és j nem ugyanabban a branchben vannak, akkor ki kéne nullázni...

#B.tilda[i,c(which(source.branch[i,2]!=source.branch[,2]))]<-0
} #i


K<-array(0,c(el.nb,el.nb))
K.tilda<-array(0,c(source.nb,el.nb))

K<-t(B)%*%B
K.tilda<-t(B)%*%B.tilda

C<-1/const*t(K.tilda)%*%solve(K)%*%LFP#*1000000#hogy nV-ban legyen az LFP ,
#C<-C/10^6 #a sigmaban cm^2-et használnak



sinxx<- function (x) {
out<-ifelse((x!=0), sin(4*pi/R*x)/(4*pi/R*x),1)
return(out)}

#C.curr.many<-C
#for (i in 1: where.db) C.curr.many[i,]<-C[i,]*(where.cord[where.db,3]-where.cord[1,3])/(where.db-1)
#A density fgv-t kiintegralva kapjuk meg az aramot!!
C.curr<-array(0,dim(memb.currents))
#piece.length<-(where.cord[where.db,3]-where.cord[1,3])/(where.db-1)
for(t in 1:length(time)){
inter<-splinefun(where.cord[,3],C[,t],method="monoH.FC")
for(db2 in 1:seg.db ) {output<-integrate(inter,seg.kord[db2,3]-seg.length[db2]/2,seg.kord[db2,3]+seg.length[db2]/2)
C.curr[db2,t]<-output$value
}

}
C.dens<-C

@




















