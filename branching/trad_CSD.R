#Lets calculate the traditional CSD as well
outname<-paste('out_',readLines('cellname.txt'),sep='')
LFP<-as.matrix(read.table('myLFP'))
#this script works for multielectrode arrays (where electrodes are arrenged in rows and columns)
elec.kord<-as.matrix(read.table('elcoord_x_y_z'))
nb.columns<-4 #number of columns in the electrode
nb.rows<-16 #number of rows in the electrode
nb.timestep<-dim(LFP)[2]
dx<-200/3 #distance between the electrodes in a row
dy<-40 #distance between the electrodes in a column
xelec<--100+(1:(nb.columns-2))*dx
yelec<--100+(1:(nb.rows-2))*dy
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
png(picname)
image(xelec,yelec,t(CSD.array[[i]]),zlim=c(-limits.CSD,limits.CSD),col=rainbow(150),main='Traditional CSD',asp=1)
dev.off()
}


#kéne egy 2D simítást csinálni és a pontokat tényleg a megfelelő rácson ábrázolni....



