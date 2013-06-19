place<-'/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/out_branch/'
saving.location<-'/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/out_branch/'



mit<-'lfp_error'
#parameters<-c('BF.type', 'BF.width','BF.number','SEG.number', 'EL.number', 'EL.shift', 'DIST.10','DIST.20','DIST.30','DIST.40', 'DIST.50','DIST.60')


#BF.type<-c('gauss','step', 'sinxpx','cos')
BF.type<-c('gauss')
BF.width<-seq(10,40,5)
BF.number<-c(79,100,119) #seq(79,79,20)
#SEG.number<-20
EL.number<-32
EL.dist<-seq(30,30,10)
#DIST.type<-1:22 #there 12 different types of distributions


measures<-array(0,c(length(BF.width),length(BF.number),length(EL.dist)))
dimnames(measures)<-list(BF.width,BF.number,EL.dist)

for(el.dist in 1: length(EL.dist)){

for(bf.width in 1: length(BF.width)){

for(bf.number in 1: length(BF.number)){




file.name<-paste(place,mit,'_',BF.type,'_bwidth',BF.width[bf.width],'_dist',EL.dist[el.dist], '_el', EL.number, '_seg48','_bnum',BF.number[bf.number],sep='')
measures[ bf.width, bf.number, el.dist ]<-as.matrix(read.table(file.name))


} #bf.number
} #bf.width

} #el.dist


plot(c(BF.width), measures[,1,1])
matplot(measures[,,1],t='l')



