place<-'/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/bs_130509/out0516/'


mit<-'measurecurr'
#mit<-'meaure1'
#mit<-'normRMSEtot'

parameters<-c('BF.type', 'BF.width','BF.number','SEG.number', 'EL.number', 'EL.shift', 'DIST.10','DIST.20','DIST.30','DIST.40', 'DIST.50','DIST.60')

BF.type<-c('gauss','step', 'sinxpx','cos')
BF.width<-seq(20,50,10)
BF.number<-seq(40,80,20)
SEG.number<-20
EL.number<-16
col.number<-length(BF.width)*length(BF.number)*length(BF.type)
measures<-matrix(0,nrow=length(parameters),col.number)
dimnames(measures)<-list(parameters,c(1:col.number))
colnames<-numeric()
j<-0
for(bf.type in 1: length(BF.type)){
for(bf.width in 1: length(BF.width)){

for(bf.number in 1: length(BF.number)){
j<-j+1
colnames<-c(colnames,paste(BF.type[bf.type],BF.width[bf.width],'BF nb',BF.number[bf.number]))
for(dist in 1:6){
file.name<-paste(place,mit,'_',BF.type[bf.type],'_bwidth',BF.width[bf.width],'_dist',dist*10,'_el',EL.number,'_seg',SEG.number,'_bnum',BF.number[bf.number],sep='')
measures[1,j]<-BF.type[bf.type]
measures[2,j]<-BF.width[bf.width]
measures[3,j]<-BF.number[bf.number]
measures[4,j]<-SEG.number
measures[5,j]<-EL.number
measures[6,j]<-0 #EL.shift
measures[(6+dist),j]<-as.numeric(read.table(file.name))

}#dist
} #bf.number
} #bf.width
} #bf.type
dimnames(measures)<-list(parameters,colnames)
whichones<-which(measures[1,]=='gauss')
par(mar=c(5.1, 4.1, 4.1, 12.1), xpd=TRUE)
matplot((1:6)*10,measures[7:12,whichones],t='l',lty = 1:5, lwd = 1,col=1:6,, xlab='Cell to electrode distance', ylab='RMSE',main='RMSE in case of different gaussian basis functions')
 legend('topright',  inset=c(-0.6,0),colnames[whichones],
            lty = 1:5, lwd = 1,col=1:6)

whichones<-which(measures[1,]=='sinxpx')
par(mar=c(5.1, 4.1, 4.1, 12.1), xpd=TRUE)
matplot((1:6)*10,measures[7:12,whichones],t='l',lty = 1:5, lwd = 1,col=1:6,, xlab='Cell to electrode distance', ylab='RMSE',main='RMSE in case of different sinxpx basis functions')
 legend('topright',  inset=c(-0.6,0),colnames[whichones],
            lty = 1:5, lwd = 1,col=1:6)

whichones<-which(measures[3,]=='40')
par(mar=c(5.1, 4.1, 4.1, 12.1), xpd=TRUE)
matplot((1:6)*10,measures[7:12,whichones],t='l',lty = 1:5, lwd = 1,col=1:6,, xlab='Cell to electrode distance', ylab='RMSE',main='RMSE in case of 40 basis functions')
 legend('topright',  inset=c(-0.6,0),colnames[whichones],
            lty = 1:5, lwd = 1,col=1:6)

