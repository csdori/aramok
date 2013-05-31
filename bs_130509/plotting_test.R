place<-'/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/bs_130509/out_test/'
saving.location<-'/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/bs_130509/out_test/comparison'



#mit<-'measurecurr'
#mit<-'meaure1'
#mit<-'normRMSEtot'
mit<-'error1'
#parameters<-c('BF.type', 'BF.width','BF.number','SEG.number', 'EL.number', 'EL.shift', 'DIST.10','DIST.20','DIST.30','DIST.40', 'DIST.50','DIST.60')


BF.type<-c('gauss','step', 'sinxpx','cos')
#BF.type<-c('step', 'sinxpx','cos')
BF.width<-seq(20,50,10)
BF.number<-seq(40,80,20)
#SEG.number<-20
EL.number<-16
EL.dist<-seq(10,60,10)
DIST.type<-1:22 #there 12 different types of distributions

#col.number<-length(BF.width)*length(BF.number)*length(BF.type)

measures<-array(0,c(length(BF.type),length(BF.width),length(BF.number),length(EL.dist),length(DIST.type)))
dimnames(measures)<-list(BF.type,BF.width,BF.number,EL.dist,DIST.type)

for(el.dist in 1: length(EL.dist)){
for(bf.type in 1: length(BF.type)){
for(bf.width in 1: length(BF.width)){

for(bf.number in 1: length(BF.number)){




file.name<-paste(place,mit,'_',BF.type[bf.type],'_bwidth',BF.width[bf.width],'_dist',EL.dist[el.dist], '_el', EL.number, '_where', 600 ,'_bnum',BF.number[bf.number],sep='')
measures[bf.type, bf.width, bf.number, el.dist, ]<-as.matrix(read.table(file.name))


} #bf.number
} #bf.width
} #bf.type
} #el.dist


##############################################
############ PLotting x=dist y=error for different BFs
###################################################
#c(length(BF.type),length(BF.width),length(BF.number),length(EL.dist),DIST.type)
bf.type<- c("step") #BF.type[1] #('step', 'sinxpx','cos')
bf.width<-c("20","30","40","50") #20,30,40,50
bf.number<-c( "40" ) #40,60,80
el.dist<-c("30") #10,20,30,40,50,60
type<-1:22 #1-22
whereto<-paste(saving.location,"/R_dist_types_",bf.type,"_nb_",bf.number ,"_dist_",el.dist,sep="")
png(whereto)
par(mar=c(5.1, 4.1, 4.1, 12.1), xpd=TRUE)
matplot(bf.width,measures[bf.type, bf.width, bf.number ,el.dist,type],t='l',ylab='error',lty = 1:4, lwd = 2,col=1:7,
main="Error of estimation")
legend('topright',  inset=c(-0.3,0),paste(c(type)),
            lty = 1:4, lwd = 2,col=1:7)
mtext(paste("bf",bf.type, "bf.nb:", bf.number, "dist", el.dist))
dev.off()

#############################################################
bf.type<- c("sinxpx") #BF.type[1] #('step', 'sinxpx','cos')
bf.width<-c("20","30","40","50") #20,30,40,50
bf.number<-c( "40" ) #40,60,80
el.dist<-c("30") #10,20,30,40,50,60
type<-1:22 #1-22
whereto<-paste(saving.location,"/R_dist_types_",bf.type,"_nb_",bf.number ,"_dist_",el.dist,sep="")
png(whereto)
par(mar=c(5.1, 4.1, 4.1, 12.1), xpd=TRUE)
matplot(bf.width,measures[bf.type, bf.width, bf.number ,el.dist,type],t='l',ylab='error',lty = 1:4, lwd = 2,col=1:7,
main="Error of estimation")
legend('topright',  inset=c(-0.3,0),paste(c(type)),
            lty = 1:4, lwd = 2,col=1:7)
mtext(paste("bf",bf.type, "bf.nb:", bf.number, "dist", el.dist))
dev.off()
################################################
#############################################################
bf.type<- c("step") #BF.type[1] #('step', 'sinxpx','cos')
bf.width<-c("20","30","40","50") #20,30,40,50
#40,60,80
el.dist<-c("30") #10,20,30,40,50,60
#type<-18:22 #1-22
type<-3:17 #1-22

whereto<-paste(saving.location,"/type_cos_error_",bf.type,"_nb_",bf.number ,"_dist_",el.dist,sep="")
png(whereto,width = 1200, height = 600)
par(mfrow=c(1,3),mar=c(5.1, 4.1, 4.1, 5.1), xpd=TRUE)

bf.number<-c( "40" ) 
matplot(t(measures[bf.type, bf.width, bf.number ,el.dist,type]),t='l',ylab='error',lty = 1:4, lwd = 2,col=1:7,
main="Error of estimation")
legend('topright',  inset=c(-0.15,0),bf.width,
            lty = 1:4, lwd = 2,col=1:7)
mtext(paste("bf",bf.type, "bf.nb:", bf.number, "dist", el.dist))


bf.number<-c( "60" ) 
matplot(t(measures[bf.type, bf.width, bf.number ,el.dist,type]),t='l',ylab='error',lty = 1:4, lwd = 2,col=1:7,
main="Error of estimation")
legend('topright',  inset=c(-0.15,0),bf.width,
            lty = 1:4, lwd = 2,col=1:7)
mtext(paste("bf",bf.type, "bf.nb:", bf.number, "dist", el.dist))


bf.number<-c( "80" ) 
matplot(t(measures[bf.type, bf.width, bf.number ,el.dist,type]),t='l',ylab='error',lty = 1:4, lwd = 2,col=1:7,
main="Error of estimation")
legend('topright',  inset=c(-0.15,0),bf.width,
            lty = 1:4, lwd = 2,col=1:7)
mtext(paste("bf",bf.type, "bf.nb:", bf.number, "dist", el.dist))




dev.off()
################################################


whichones<-array(0,c(length(DIST.type), 5))
for(i in 1:length(DIST.type)){
whichones[i,]<-c(which(measures[,,,,i]==min(measures[,,,,i]),arr.ind=TRUE))
}
####################################################################x
#lets plot the distributions
cell.length<-600
memb.currents<- list()

memb.currents[[1]]<- function(x){ ifelse(x>cell.length | x<0, 0, (x-cell.length/2)/(cell.length/2))}

memb.currents[[2]]<- function(x){ ifelse(x>cell.length | x<0, 0, (abs(x)-cell.length/2)/(cell.length/2))}
#a frekvencia <- fp2/2
#for(fp2 in 1:15){
memb.currents[[3]]<- function(x){ ifelse(x>cell.length | x<0, 0, sin(fp2*pi/cell.length*x))}

#}

#for(w in 1:5){
memb.currents[[4]]<- function(x){ ifelse(x>cell.length | x<0, 0, exp(-(x-cell.length/2)^2/((2*w*10)^2)))}
#}



###########xHOw many distribution types

distribution.nb<-22

time<-1:distribution.nb

memb.points<-c(1:600)
memb.currents.points<-array(0,c(600,distribution.nb ))
for(t in 1:2){
memb.currents.points[,t]<-memb.currents[[t]](memb.points)
}

for(fp2 in 1:15){
memb.currents.points[,2+fp2]<-memb.currents[[3]](memb.points)
}

for(w in 1:5){
memb.currents.points[,17+w]<-memb.currents[[4]](memb.points)
}
#transfer matrix for sCSD
#Az eloszlások külön időpillanatokban alkotott pintazatoknak felelnek meg
whereto<-paste(saving.location,"/currentdis_cos.png",sep="")
png(whereto,width = 1200, height = 600)



par(mar=c(5.1, 4.1, 4.1, 12.1), xpd=TRUE)
matplot(memb.points,memb.currents.points[,type],t='l',xlab='x (um)',ylab='current density',main='Original current densities',
            lty = 1:4, lwd = 2,col=1:7)
legend('topright', paste(DIST.type[type]), inset=c(-0.15,-0.18), 
            lty = 1:4, lwd = 2,col=1:7)
dev.off()

whereto<-paste(saving.location,"/currentdis_gauss.png",sep="")
png(whereto,width = 1200, height = 600)
par(mar=c(5.1, 4.1, 4.1, 12.1), xpd=TRUE)
matplot(memb.points,memb.currents.points[,18:22],t='l',xlab='x (um)',ylab='current density',main='Original current densities',
            lty = 1:4, lwd = 2,col=1:7)
legend('topright', paste(c(1:5)), inset=c(-0.15,-0.18), 
            lty = 1:4, lwd = 2,col=1:7)
dev.off()



##############################################################x
############## Special plots: error vs R
###########
########cos

BF.width<-seq(20,100,10)
BF.number<-seq(40,80,20)
speciald<-array(0,c(3,length(BF.width)))
speciald2<-array(0,c(3,length(BF.width)))

whereto<-paste(saving.location,"/error_Rtest_cos_patt3_12_el_both.png",sep="")
png(whereto,width = 1200, height = 600)
par(mfrow=c(5,4),mar=c(2, 2, 2, 2))
w<-0
#for(pattern in 1:1) {
#for(pattern in 13:22) {
for(pattern in 3:12) {
w<-w+1
plot(memb.currents.points[,pattern],t='l' ,xlab='x',ylab='current density')
if(w==1) {
legend('topright', paste(c(BF.number)) ,
            lty = 1, lwd = 2,col=1:7,title='el 32', bg='WHITE')
legend('bottomleft', paste(c(BF.number)) ,
            lty = 2, lwd = 2,col=1:7,title='el 16', bg='WHITE')
}
for(i in 1:length(BF.width)){
for(j in 1:length(BF.number)){

file.name<-paste(place,mit,'_','cos','_bwidth',BF.width[i],'_dist',30, '_el', 32, '_where', 600 ,'_bnum',BF.number[j],sep='')
if(file.exists(file.name)==TRUE) {speciald[j,i ]<-as.numeric(read.table(file.name)[pattern,])} else speciald[j,i ]<-NA


###############Ha egy másik verziór is ki akarunk rajzolni
file.name2<-paste(place,mit,'_','cos','_bwidth',BF.width[i],'_dist',30, '_el', 16, '_where', 600 ,'_bnum',BF.number[j],sep='')
speciald2[j,i ]<-as.numeric(read.table(file.name2)[pattern,])
}}

if(w==1) {
matplot(BF.width,t(speciald),t="l",xlab="Width of basis function", ylab="Error", main="Estimation error vs R" ,lty = 1,  ylim=c(0,0.3),
lwd = 2,col=1:7 )
matplot(BF.width,t(speciald2),t="l",xlab="Width of basis function", ylab="Error", main="Estimation error vs R" ,lty = 2,  ylim=c(0,0.3),
lwd = 2,col=1:7,add=TRUE )



}


else  {matplot(BF.width,t(speciald),t="l" ,lty = 1,  ylim=c(0,0.3),
lwd = 2,col=1:7 )

matplot(BF.width,t(speciald2),t="l" ,lty = 2,  ylim=c(0,0.3),
lwd = 2,col=1:7 ,add=TRUE)
}

} #distrib
dev.off()



##############################################################x
############## Special plots: error vs R
###########
########gauss

BF.width<-seq(5,55,10)
BF.number<-seq(40,80,20)
speciald<-array(0,c(3,length(BF.width)))
speciald2<-array(0,c(3,length(BF.width)))

whereto<-paste(saving.location,"/error_Rtest_gauss2_patt3_12_el_both2.png",sep="")
png(whereto,width = 1200, height = 600)
par(mfrow=c(5,4),mar=c(2, 2, 2, 2))
w<-0
#for(pattern in 1:1) {
#for(pattern in 13:22) {
for(pattern in 3:12) {
w<-w+1
plot(memb.currents.points[,pattern],t='l' ,xlab='x',ylab='current density')
if(w==1) {
legend('topright', paste(c(BF.number)) ,
            lty = 1, lwd = 2,col=1:7,title='el 32', bg='WHITE')
legend('bottomleft', paste(c(BF.number)) ,
            lty = 2, lwd = 2,col=1:7,title='el 16', bg='WHITE')
}
for(i in 1:length(BF.width)){
for(j in 1:length(BF.number)){

file.name<-paste(place,mit,'_','gauss2','_bwidth',BF.width[i],'_dist',30, '_el', 32, '_where', 600 ,'_bnum',BF.number[j],sep='')
if(file.exists(file.name)==TRUE) {speciald[j,i ]<-as.numeric(read.table(file.name)[pattern,])} else speciald[j,i ]<-NA


###############Ha egy másik verziór is ki akarunk rajzolni
file.name2<-paste(place,mit,'_','gauss2','_bwidth',BF.width[i],'_dist',30, '_el', 16, '_where', 600 ,'_bnum',BF.number[j],sep='')
speciald2[j,i ]<-as.numeric(read.table(file.name2)[pattern,])

###ha a becsült árameloszlásokat is ki akarjuk rajzolni

#file.name3<-paste(place,'C','_','gauss2','_bwidth',BF.width[i],'_dist',30, '_el', 16, '_where', 600 ,'_bnum',BF.number[j],sep='')

#C16[j,i ]<-as.numeric(read.table(file.name3)

#file.name4<-paste(place,'C','_','gauss2','_bwidth',BF.width[i],'_dist',30, '_el', 32, '_where', 600 ,'_bnum',BF.number[j],sep='')

#C32[j,i ]<-as.numeric(read.table(file.name3)


}}

if(w==1) {
matplot(BF.width,t(speciald),t="l",xlab="Width of basis function", ylab="Error", main="Estimation error vs R" ,lty = 1,  ylim=c(0,0.3),
lwd = 2,col=1:7 )
matplot(BF.width,t(speciald2),t="l",xlab="Width of basis function", ylab="Error", main="Estimation error vs R" ,lty = 2,  ylim=c(0,0.3),
lwd = 2,col=1:7,add=TRUE )



}


else  {matplot(BF.width,t(speciald),t="l" ,lty = 1,  ylim=c(0,0.3),
lwd = 2,col=1:7 )

matplot(BF.width,t(speciald2),t="l" ,lty = 2,  ylim=c(0,0.3),
lwd = 2,col=1:7 ,add=TRUE)
}

} #distrib
dev.off()


#################################################################
######################### Conclusions
###########################################

#Estimation works better in the middle of the cell, the reason for is, that the center of the basis funcion is distrinbuted on the cell only, so for the basis function on the edge there are no compensations

# should think over the meaning of R in case of Gaussian basis function, where exp(-x^₂/(2*R))

#larger number of base function -better estimation
#I shoul have used much longer Gaussians














