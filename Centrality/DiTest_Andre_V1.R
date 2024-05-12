
bilatDistance <- function(lo, la){ # gives correctly computed bilateral distancs in km
  radj=6371
  la <- 2 * pi * la/360
  lo <- 2 * pi * lo/360
  coslat <- cos(la)
  sinlat <- sin(la)
  dvect <- sinlat %o% sinlat + (coslat %o% coslat) * cos(-outer(lo,  lo, "-"))
  dvect <- dvect[lower.tri(dvect)]
  dvect <- ifelse(dvect > 1, 1, dvect)
  dvect <- radj * acos(dvect)
  return(dvect)
}

convertXY<- function(lat,lon){
  R=6371000
  x = R * (cos(9000-lat)* cos(lon))
  y = R * (cos(9000-lat) *sin(lon))
  ergeb=objects();
  ergeb$x=x
  ergeb$y=y

  return (ergeb)
}

calcDi<- function(y,x, fun){
  thresh=1 # min distance
  dist=bilatDistance(y,x)# calculaution of bilateral distances according to McSpatial
  dist[dist<thresh] <-thresh
  Di=rep(0,length(y))
  pos=1
  i=1
  for(i in 1:(length(Di)-1)){ # calculate Di vlaues
    upTo=length(Di)-i # length of array
    #print(paste("Von ",pos,"um",upTo, sep=" " ))
    for(z in 1:upTo){ # different possible functions to play with --> use invert
      if(fun=="invert" ){
        val=1/(dist[pos]*(length(Di)-1));
      }
      if(fun=="expo"){
        val=exp(-0.05*dist[pos])
        val=val/(length(Di)-1)
      }

      Di[i]=Di[i]+val
      mypos=i+z
      Di[mypos]=Di[mypos]+val
      # print(paste("Updaze bei",i,"und",mypos, sep=" " ))
      #print(pos)
      pos=pos+1

    }

  }
  return (Di)
}


getPercentileGlobalConfidenceBand <- function (KDEValues,esp, maxNumb,numIter, startPercentile, percentileStep, upperOrLower){
  counter=0
  observedNumb=maxNumb+1
  while(observedNumb>maxNumb){
    bound=vector();
    counter=counter+1
    for(i in 1:esp){
      if(upperOrLower=="lower"){
        percentile=startPercentile-(counter*percentileStep)
      }
      else{
        percentile=startPercentile+(counter*percentileStep)
      }
      quantiles <- quantile(KDEValues[,i], percentile)
      bound=append(bound,quantiles[[1]])
    }
    observedNumb=0
    for(i in 1:numIter){# WIe oft wird der Bound getroffen
      iter=KDEValues[i,]
      if(upperOrLower=="lower"){
        if(sum(iter<bound)>=1){ # Bound wurden an mindestens einer Stelle getroffen
          observedNumb=observedNumb+1
        }
      }
      else{
        if(sum(iter>bound)>=1){ # Bound wurden an mindestens einer Stelle getroffen
          observedNumb=observedNumb+1
        }
      }
    }
    print(paste("Percenetik:",percentile, " Treffer: ",observedNumb))
  }
  ergeb=objects();
  ergeb$bound=bound;
  ergeb$percentile=percentile
  return (ergeb)
}
globalConfidenceBand <- function (KDEValues,esp, thresh){
  numIter=length(KDEValues[,1])
  maxNumb=(thresh/100)*numIter
  print(maxNumb)

  #Calclulation of lower Bound at 1 % Steps
  lowerBoundCalc=getPercentileGlobalConfidenceBand(KDEValues,esp, maxNumb,numIter, 0.05, 0.01, "lower")
  #Calclulation of lower Bound at 0.1 % Steps
  start=lowerBoundCalc$percentile+0.01 # set last position
  lowerBoundCalc=getPercentileGlobalConfidenceBand(KDEValues,esp, maxNumb,numIter, start, 0.001, "lower")

  #Calclulation of upper Bound at 1 % Steps
  upperBoundCalc=getPercentileGlobalConfidenceBand(KDEValues,esp, maxNumb,numIter, 0.95, 0.01, "upper")
  #Calclulation of upper Bound at 0.1 % Steps
  start=upperBoundCalc$percentile-0.01 # set last position
  upperBoundCalc=getPercentileGlobalConfidenceBand(KDEValues,esp, maxNumb,numIter, start, 0.001, "upper")

  ergeb=objects(); # ergeb means result in German ;)
  ergeb$lowerBound=lowerBoundCalc$bound
  ergeb$upperBound=upperBoundCalc$bound
  ergeb$KDEValues=KDEValues
  return (ergeb)
}



# calculate local confidence Bands ( not used in Paper)
localConfidenceBand <- function (KDEValues,esp){
  lowerBound=vector();
  upperBound=vector();
  for(i in 1:esp){
    quantiles <- quantile(KDEValues[,i], c(.05,.95))
    lowerBound=append(lowerBound,quantiles[[1]])
    upperBound=append(upperBound,quantiles[[2]])
  }
  ergeb=objects();
  ergeb$lowerBound=lowerBound
  ergeb$upperBound=upperBound
  return (ergeb)
}

#####  Global Values  ###################################################################################################

# function is used to calculate global dispersion or concentration
# needs the calculated Di values of the observes industry and the bechmark
globalVaues<- function (kdeObs, kdeBench){
  #calculate the median value of Benchmark
  meanIntegral=0
  i=1
  while (meanIntegral<0.5){
    maxb=max(kdeBench$y[i],kdeBench$y[(i+1)])
    d=abs(kdeBench$y[i]-kdeBench$y[(i+1)])
    c=kdeBench$x[(i+1)]-kdeBench$x[i]
    integral=maxb*c-(0.5*(c*d))
    meanIntegral=meanIntegral+integral
    i=i+1
  }
  myMean=kdeBench$x[i]
  omega=0
  theta=0
  print(myMean)
  for(i in 1:(length(kdeObs$y)-1)){

    if(kdeObs$y[i]>kdeBench$y[i] && kdeObs$y[(i+1)]>kdeBench$y[(i+1)]){
      maxbObs=max(kdeObs$y[i],kdeObs$y[(i+1)])
      maxbBench=max(kdeBench$y[i],kdeBench$y[(i+1)])
      dObs=abs(kdeObs$y[i]-kdeObs$y[(i+1)])
      dBench=abs(kdeBench$y[i]-kdeBench$y[(i+1)])
      c=kdeObs$x[(i+1)]-kdeObs$x[i]
      integralObs=maxbObs*c-(0.5*(c*dObs))
      integralBench=maxbBench*c-(0.5*(c*dBench))
      integral=integralObs-integralBench
      if(kdeBench$x[i]< myMean){#Dispersion
        omega=omega+integral
        #print(paste("Dispersion an der Stelle",kdeObs$x[i],"mit Wert",kdeObs$y[i],"zu",kdeBench$y[i], "ergibt:",integral, sep=" "))
      }
      else{#Concentration
        theta=theta+integral
        #print(paste("Konzentration an der Stelle",kdeObs$x[i],"mit Wert",kdeObs$y[i],"zu",kdeBench$y[i], "ergibt:",integral, sep=" "))
      }
    }
  }
  ergeb=objects();
  ergeb$theta=theta
  ergeb$omega=omega
  ergeb$delta=theta-omega
  ergeb$myMean=myMean

  return (ergeb)
}


####################################################
  # code from here seems to be not usefull
##################################################

calcDiBenchmarkBootstrap<- function(mat, numb_firms, numb_rep,esp, fun){

  DiValues=matrix(ncol = numb_firms, nrow = numb_rep);# set martrix for iterative values
  for(rep in 1: numb_rep){ # number of iterations
    sample_mat=mat[sample(length(mat[,1]), numb_firms), ]# Draw random firms
    Di=calcDi(sample_mat[,1], sample_mat[,2],fun)#calculate Di Values
    DiValues[rep,]=Di# append generated values
  }
  return (DiValues);
}


calcDi2<- function(y,x){
  thresh=1
  numb=(length(y))
  print(numb)
  Di=rep(0,numb)
  for(i in 1:(numb-1)){ # calculate Di vlaues
    for(z in (i+1):numb){
      dist=distHaversine(c(y[i],x[i]),c(y[z],x[z]), r=6378)
      #print(paste(i,"zu",z,":", dist, sep=" "))
      if(dist<thresh){dist=thresh}
      val=1/(dist*(numb-1))
      Di[i]= Di[i]+val
      Di[z]= Di[z]+val

    }

  }
  return (Di)
}

calcDiBenchmark<- function(totalY,totalX, anz){
  obsPP=ppp()
  randPosStart <- sample(1:length(totalY), anz)

  for(i in 1: anz){
    obsPP$y=append(obsPP$y, totalY[randPosStart[i]])
    obsPP$x=append(obsPP$x, totalX[randPosStart[i]])
  }
  print(length(obsPP$y))
  thresh=1
  print(paste(length(obsPP$y),"repititions. Total number of benchmark firms:",length(totalY), sep=" "))
  Di=rep(0,length(obsPP$y))
  for(i in 1: length(obsPP$y)){
    print(i)
    randPos <- sample(1:length(totalY), length(obsPP$y))# generate random numbers accodring to the length of the observed point sample
    delPos=which(randPos == randPosStart[i])# check if the same number was drawn
    if(length(delPos)>0){
      randPos=randPos[-c(delPos)]# delete the entry
    }
    else{
      randPos <- randPos[1:(length(obsPP$y)-1)]
    }
    #newPoission=rpoispp(80, win=myWin) #Poission Point for reference
    for(z in 1:(length(obsPP$y)-1)){
      dist=distHaversine(c(obsPP$y[i],obsPP$x[i]),c(totalY[randPos[z]],totalX[randPos[z]]), r=6378)
       #dist=distHaversine(c(obsY[i],obsX[i]),c(newPoission$y[z],newPoission$x[z]), r=6378)
      #print(paste("Von",i,"nach",z, ":", dist, sep=" "))
      if(dist<thresh){
        print(paste("Treffer:", dist,"bei",randPosStart[i],"--",obsPP$y[i], "zu",randPos[z],"--",totalY[randPos[z]],  sep=" "));
        dist=thresh;
      }
      val=1/(dist*(length(obsPP$y)-1))
      Di[i]= Di[i]+val
    }
  }
  return (Di)
}

######  Global Values  ###################################################################################################
globalVauesBootstrap<- function (kdeObs, upperBound,myMean){

  omega=0
  theta=0

  for(i in 1:(length(kde$x)-1)){
    if(kdeObs$y[i]>upperBound[i] && kdeObs$y[(i+1)]>upperBound[(i+1)]){
      maxbObs=max(kdeObs$y[i],kdeObs$y[(i+1)])
      maxbBench=max(upperBound[i],upperBound[(i+1)])
      dObs=abs(kdeObs$y[i]-kdeObs$y[(i+1)])
      dBench=abs(upperBound[i]-upperBound[(i+1)])
      c=kdeObs$x[(i+1)]-kdeObs$x[i]
      integralObs=maxbObs*c-(0.5*(c*dObs))
      integralBench=maxbBench*c-(0.5*(c*dBench))
      #integral=integralObs
      integral=integralObs-integralBench
      if(kdeObs$x[i]< myMean){#Dispersion
        omega=omega+integral
        print(paste("Dispersion an der Stelle",kdeObs$x[i],"mit Wert",kdeObs$y[i], "ergibt:",integral, sep=" "))
      }
      else{#Concentration
        theta=theta+integral
        print(paste("Konzentration an der Stelle",kdeObs$x[i],"mit Wert",kdeObs$y[i],"ergibt:",integral, sep=" "))
      }
    }
  }
  print(theta)
  ergeb=objects();
  ergeb$theta=theta
  ergeb$omega=omega
  ergeb$delta=theta-omega
  ergeb$myMean=myMean
  return (ergeb)
}




