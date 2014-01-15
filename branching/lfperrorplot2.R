#hol<-'/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/out_morpho1_el128/'
#hol<-'/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/out_morpho1_el36/'
hol<-'/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/out_morpho1_el72/'
#hol<-'/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/out_villa_el36/'
#hol<-'/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/out_villa_el128/'
#hol<-'/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/out_villa/'
#hol<-'/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/out_ballstick_el128/'
#hol<-'/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/out_ballstick_el36/'
#hol<-'/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/out_ballstick/'
library('fields')
params<-read.table(paste(hol,'parameterek.txt',sep=''))
basis.which<- which(params[,1]=='gauss')
basis.width<-params[basis.which,2] #number of basis function
basis.number<-params[basis.which,3] #width of basis function
lfperror<-params[basis.which,4]
currenterror<-params[basis.which,5]
smoothederror<-params[basis.which,6]
cv_error<-params[basis.which,7]
#scatterplot3d(basis.width, basis.number,smoothederror,pch=16,grid=TRUE, highlight.3d=TRUE, type="h", main="3D Scatterplot")

####################
#lfp error
png(paste(hol,'errorplot.png',sep=''))
fit<- Tps( params[basis.which,2:3],params[basis.which,4]) # fit surface to data 

# surface of variables 2 and 3 
#    holding 1 and 4 fixed at their median levels
 out.p<-predict.surface(fit, xy=c(1,2))  
 plot.surface(out.p, type="C",xlab='R',ylab='M',main='Error values',zlim=c(0,0.000017)) # surface plot  
#points(fit$x[which.min(fit$y),][1],fit$x[which.min(fit$y),][2],pch=8,cex=2)

points(out.p$x[which(out.p$z==min(out.p$z),arr.ind=TRUE)[1]],out.p$y[which(out.p$z==min(out.p$z),arr.ind=TRUE)][2],pch=8,cex=2)
dev.off()

# current error
png(paste(hol,'C_errorplot.png',sep=''))
fit<- Tps( params[basis.which,2:3],params[basis.which,5]) # fit surface to data 

# surface of variables 2 and 3 
#    holding 1 and 4 fixed at their median levels
 out.p<-predict.surface(fit, xy=c(1,2))  
 plot.surface(out.p, type="C",xlab='R',ylab='M',main='Error values',zlim=c(0,3)) # surface plot 
points(out.p$x[which(out.p$z==min(out.p$z),arr.ind=TRUE)[1]],out.p$y[which(out.p$z==min(out.p$z),arr.ind=TRUE)][2],pch=8,cex=2)
dev.off()

# smoothed current error
png(paste(hol,'smoothC_errorplot.png',sep=''))
fit<- Tps( params[basis.which,2:3],params[basis.which,6]) # fit surface to data 

# surface of variables 2 and 3 
#    holding 1 and 4 fixed at their median levels
 out.p<-predict.surface(fit, xy=c(1,2))  
 plot.surface(out.p, type="C",xlab='R',ylab='M',main='Error values',zlim=c(0,3)) # surface plot 
points(out.p$x[which(out.p$z==min(out.p$z),arr.ind=TRUE)[1]],out.p$y[which(out.p$z==min(out.p$z),arr.ind=TRUE)][2],pch=8,cex=2)
dev.off()

# smoothed current error
png(paste(hol,'cv_errorplot.png',sep=''))
fit<- Tps( params[basis.which,2:3],params[basis.which,7]) # fit surface to data 

# surface of variables 2 and 3 
#    holding 1 and 4 fixed at their median levels
 out.p<-predict.surface(fit, xy=c(1,2))  
 plot.surface(out.p, type="C",xlab='R',ylab='M',main='CV Error Values',zlim=c(0,1)) # surface plot 
points(out.p$x[which(out.p$z==min(out.p$z),arr.ind=TRUE)[1]],out.p$y[which(out.p$z==min(out.p$z),arr.ind=TRUE)][2],pch=8,cex=2)
dev.off()




