#Plotting the results



#The Dependence of NRMSE on the Cell to Electrode Distance in case of the parameters in the file names
setwd("/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/bs_1D_130506/out")
#R30
nrmse.gauss.R30<-numeric()
for (i in 1:6){
nevrmse<-paste('normRMSEtot_gauss_R30_dist',i*10,'_el10_seg18',sep='')
nrmse.gauss.R30<-c(nrmse.gauss.R30, as.numeric(read.table(nevrmse)))
}

nrmse.step.R30<-numeric()
for (i in 1:6){
nevrmse<-paste('normRMSEtot_step_R30_dist',i*10,'_el10_seg18',sep='')
nrmse.step.R30<-c(nrmse.step.R30, as.numeric(read.table(nevrmse)))
}
plot(c(1:6)*10,nrmse.step.R30*100,xlab='d (um)', ylab='NRMSE (%)',main='The Dependence of NRMSE on the Cell to Electrode Distance',ylim=c(0,1.5),t='o')
lines(c(1:6)*10,nrmse.gauss.R30*100,col='RED',t='o')
legend("topright",c("step","gauss"),col=c("BLACK","RED"),lty=1)

#R20
nrmse.gauss.R20<-numeric()
for (i in 1:6){
nevrmse<-paste('normRMSEtot_gauss_R20_dist',i*10,'_el10_seg18',sep='')
nrmse.gauss.R20<-c(nrmse.gauss.R20, as.numeric(read.table(nevrmse)))
}

nrmse.step.R20<-numeric()
for (i in 1:6){
nevrmse<-paste('normRMSEtot_step_R20_dist',i*10,'_el10_seg18',sep='')
nrmse.step.R20<-c(nrmse.step.R20, as.numeric(read.table(nevrmse)))
}

#R40
nrmse.gauss.R40<-numeric()
for (i in 1:6){
nevrmse<-paste('normRMSEtot_gauss_R40_dist',i*10,'_el10_seg18',sep='')
nrmse.gauss.R40<-c(nrmse.gauss.R40, as.numeric(read.table(nevrmse)))
}

nrmse.step.R40<-numeric()
for (i in 1:6){
nevrmse<-paste('normRMSEtot_step_R40_dist',i*10,'_el10_seg18',sep='')
nrmse.step.R40<-c(nrmse.step.R40, as.numeric(read.table(nevrmse)))
}


png("nrmsedistR20_30_40_el10_seg18.png")
plot(c(1:6)*10,nrmse.step.R30*100,xlab='d (um)', ylab='NRMSE (%)',main='The Dependence of NRMSE on the Cell to Electrode Distance',ylim=c(0,1.5),t='o')
lines(c(1:6)*10,nrmse.gauss.R30*100,col='RED',t='o')
lines(c(1:6)*10,nrmse.step.R20*100,col='PURPLE',t='o')
lines(c(1:6)*10,nrmse.gauss.R20*100,col='ORANGE',t='o')
lines(c(1:6)*10,nrmse.step.R40*100,col='BLUE',t='o')
lines(c(1:6)*10,nrmse.gauss.R40*100,col='YELLOW',t='o')
legend("topright",c("step R30","gauss R30","step R20","gauss R20","step R40","gauss R40"),col=c("BLACK","RED", "PURPLE","ORANGE","BLUE","YELLOW"),lty=1)
legend("topleft", "number of electrodes: 10 \nnumber of base functions: 18")
dev.off()
#Lets change the calue of R and run an other set of simulations



















