#hol<-'/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/out_morpho1_el128/'
#hol<-'/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/out_morpho1/'
hol<-'/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/out_villa_el32/'
#hol<-'/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/out_ballstick_el32/'
library('fields')
params<-read.table(paste(hol,'parameterek.txt',sep=''))
basis.which<- which(params[,1]=='gauss')
basis.width<-params[basis.which,2] #number of basis function
basis.number<-params[basis.which,3] #width of basis function
lfperror<-params[basis.which,4]
currenterror<-params[basis.which,5]
smoothederror<-params[basis.which,6]
#scatterplot3d(basis.width, basis.number,smoothederror,pch=16,grid=TRUE, highlight.3d=TRUE, type="h", main="3D Scatterplot")

####################
png(paste(hol,'errorplot.png',sep=''))
fit<- Tps( params[basis.which,2:3],params[basis.which,4]) # fit surface to data 

# surface of variables 2 and 3 
#    holding 1 and 4 fixed at their median levels
 out.p<-predict.surface(fit, xy=c(1,2))  
 plot.surface(out.p, type="C",xlab='R',ylab='M',main='Error values') # surface plot  
dev.off()


