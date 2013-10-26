#Lets calculate the traditional CSD as well
outname<-paste('out_',readLines('cellname.txt'),sep='')
LFP<-as.matrix(read.table('myLFP'))
elec.kord<-as.matrix(read.table('elcoord_x_y_z'))
hanyoszlop<-4
hanysor<-16
idopill<-dim(LFP)[2]
dx<-200/3
dy<-40
xelec<--100+(1:(hanyoszlop-2))*dx
yelec<--100+(1:(hanysor-2))*dy
LFP.array<-list()
for(i in 1: idopill){
LFP.array[[i]]<-matrix(LFP[,i],nrow=hanysor)
}
#az-e az x, aminek mi hisszük???

#ez csak speciális geometriák esetén érvényes, vagy legyen inkább kCSD

CSD.array<-list()
for(i in 1: idopill){
	CSD.array[[i]]<-array(0,c(hanysor-2,hanyoszlop-2))
	for(x in 2: (hanysor-1)){
		for(y in 2:(hanyoszlop-1)){
			CSD.array[[i]][x-1,y-1]<-(LFP.array[[i]][x-1,y]+LFP.array[[i]][x+1,y]-2*LFP.array[[i]][x,y])/dx^2+(LFP.array[[i]][x,y+1]+LFP.array[[i]][x,y-1]-2*LFP.array[[i]][x,y])/dy^2
		}
	}

#plotting
limits.CSD<-max(abs(range(CSD.array[[i]])))#,memb.currents.vona
picname<-paste(outname,'/pics/skCSD_C',i,'.png', sep='')
png(picname)
image(xelec,yelec,t(CSD.array[[i]]),zlim=c(-limits.CSD,limits.CSD),col=rainbow(150),main='Traditional CSD')
dev.off()
}


#kéne egy 2D simítást csinálni és a pontokat tényleg a megfelelő rácson ábrázolni....



