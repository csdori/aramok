#Plotting the setup 
plot(elec.kord[,1],elec.kord[,3],xlim=c(-35,d+10),pch=15,xlab="x (um)",ylab="y (um)", main="Simulational setup",ylim=c(elec.kord[1,3]-10,elec.kord[el.nb,3]+10))
points(seg.kord[,1],seg.kord[,3],pch=20)
points(source.cord[,1],source.cord[,3],col='RED')
rect(-seg.diam[db]/2,seg.start[db,3],seg.diam[db]/2,seg.end[db,3])

if (base=='step'){
rect(-30,source.cord[1:M,3]-R/2,-20,source.cord[1:M,3]+R/2,col=rainbow(1,start=0.3,alpha=0.3))
}
if (base=='gauss'){
for(j in 1:M){
x<-matrix(-200:600,ncol=1)
gaus<-function(r.t) exp(-sum((source.cord[j,3]-r.t)^2)/(R^2))
y<-apply(x,1,gaus)
lines(-10*y-20,x)
}
}


if (base=='cos'){
for(j in 1:M){
x<-matrix((source.cord[j,3]-R/2):(source.cord[j,3]+R/2),ncol=1)
cosinus<-function(r.t) cos(pi/R*(source.cord[j,3]-r.t))
y<-apply(x,1,cosinus)
lines(-10*y-20,x)
}
}

if (base=='sinxpx'){
for(j in 1:M){
#x<-matrix(-100:600,ncol=1)
x<-matrix((source.cord[j,3]-R/2):(source.cord[j,3]+R/2),ncol=1)
sinxpx<-function(r.t) ifelse(((source.cord[j,3]-r.t)!=0),  sin(4*pi/R*(source.cord[j,3]-r.t))/(4*pi/R*(source.cord[j,3]-r.t)),1)

y<-apply(x,1,sinxpx)
lines(-10*y-20,x)
}
}

legend("topleft",c("centre of bf","middle of seg","electrodes"),col=c("RED","BLACK","BLACK"),pch=c(1,1,15),bg="WHITE" )

png("elrendezes.png",width=400, height=400)
plot(elec.kord[,1],elec.kord[,3],xlim=c(-50,d+10),pch=15,xlab="x (um)",ylab="y (um)", main="Simulational setup")
points(seg.kord[,1],seg.kord[,3],pch=20)
points(source.cord[,1],source.cord[,3],col='RED')
rect(-seg.diam[db]/2,seg.start[db,3],seg.diam[db]/2,seg.end[db,3])

#rect(-40,source.cord[1:M,3]-R/2,-30,source.cord[1:M,3]+R/2,col=rainbow(1,start=0.3,alpha=0.3))


for(j in 1:M){
x<-matrix(-100:600,ncol=1)
gaus<-function(r.t) exp(-sum((source.cord[j,3]-r.t)^2)/(R^2))
y<-apply(x,1,gaus)
lines(-10*y-13,x)
}
legend("topleft",c("centre of bf","middle of seg","electrodes"),col=c("RED","BLACK","BLACK"),pch=c(1,20,15),bg="WHITE" )
dev.off()

