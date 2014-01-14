#Lets calculate the traditional CSD as well
outname<-paste('out_',readLines('cellname.txt'),sep='')
LFP<-as.matrix(read.table('myLFP'))
#this script works for multielectrode arrays (where electrodes are arrenged in rows and columns)
nb.columns<-3 #4 #number of columns in the electrode
nb.rows<-12 #16 #number of rows in the electrode
el.nb<-nb.rows*nb.columns
elec.kord<-as.matrix(read.table('elcoord_x_y_z'))
elec.kord<-matrix(elec.kord,nrow=el.nb)

nb.timestep<-dim(LFP)[2]
dx<-200/(nb.columns-1) #distance between the electrodes in a row
dy<-550/(nb.rows-1) #40 #distance between the electrodes in a column
xelec<--100+(1:(nb.columns-2))*dx
yelec<--50+(1:(nb.rows-2))*dy
LFP.array<-list()
for(i in 1: nb.timestep){
LFP.array[[i]]<-matrix(LFP[,i],nrow=nb.rows)
}
#az-e az x, aminek mi hisszük???

CSD.array<-list()
for(i in 1: nb.timestep){
	CSD.array[[i]]<-array(0,c(nb.rows-2,nb.columns-2))
	for(x in 2: (nb.rows-1)){
		for(y in 2:(nb.columns-1)){
			CSD.array[[i]][x-1,y-1]<-(LFP.array[[i]][x-1,y]+LFP.array[[i]][x+1,y]-2*LFP.array[[i]][x,y])/dx^2+(LFP.array[[i]][x,y+1]+LFP.array[[i]][x,y-1]-2*LFP.array[[i]][x,y])/dy^2
		}
	}

#plotting
limits.CSD<-max(abs(range(CSD.array[[i]])))#,memb.currents.vona
picname<-paste(outname,'/pics/CSD',i,'.png', sep='')
filname<-paste(outname,'/pics/CSD_data_',i, sep='')
png(picname)
image(xelec,yelec,t(CSD.array[[i]]),zlim=c(-limits.CSD,limits.CSD),col=rainbow(150),main='Traditional CSD',asp=1)
dev.off()

write.table(CSD.array[[i]],filname,col.names=FALSE, row.names=FALSE)
}

#kéne egy 2D simítást csinálni és a pontokat tényleg a megfelelő rácson ábrázolni....


################################
############# sCSD
################################
#For 2 dimensional arrays
#de ha szimmetrikus a sejtre, akkor a T mátrixnak lesznek aszonos sorai, így nincs rendes inverze... ami szívás.

cell.l<-500 #tudjuk, hogy nullától 500-ig megy a sejt a z tengelyen
modeln.nb<-el.nb#*2/3

cell.pos<-array(0, c(modeln.nb,3))
cell.pos[,3]<-(0:(modeln.nb-1))*cell.l/(modeln.nb-1)

T<-array(0,c(modeln.nb, modeln.nb))
for(i in 1:modeln.nb){
for(j in 1:modeln.nb){

T[i,j]<-konst/sqrt(sum((cell.pos[i,]-elec.kord[j,])^2))
}#j
}#i

library('MASS')
aram<-ginv(T)%*%LFP
#aram<-solve(T)%*%LFP[1:modeln.nb,]
par(mfrow=c(2,1))
image(t(LFP),col=rainbow(100))
image(t(aram),col=rainbow(100))


