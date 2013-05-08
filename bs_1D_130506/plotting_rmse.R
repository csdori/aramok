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


plot(c(1:6)*10,nrmse.step.R30*100,xlab='d (um)', ylab='NRMSE (%)',main='The Dependence of NRMSE on the Cell to Electrode Distance',ylim=c(0,1.5),t='o')
lines(c(1:6)*10,nrmse.gauss.R30*100,col='RED',t='o')
lines(c(1:6)*10,nrmse.step.R20*100,col='PURPLE',t='o')
lines(c(1:6)*10,nrmse.gauss.R20*100,col='ORANGE',t='o')
legend("topright",c("step R30","gauss R30","step R20","gauss R20"),col=c("BLACK","RED", "PURPLE","ORANGE"),lty=1)
#Lets change the calue of R and run an other set of simulations



















