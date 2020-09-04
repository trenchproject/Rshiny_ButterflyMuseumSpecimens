#------------------------
#define functions 

ClassifySites= function(names, lon, lat, DistCut){
  
  new.names=names
  stat.coords= cbind(lon,lat)
  
  for(r in 1:length(lon) ){
    dists= spDistsN1(stat.coords, stat.coords[r,], longlat = TRUE) #find distances from focal site in km
    new.names[which(dists<DistCut)]= new.names[r] #rename sites within cutoff radius
  } #end loop sites
  
  return(new.names) #returns grouped site names
}

count=function(x) length(x)

#===================================================
# LM BOOTSTRAP

boot.lm<- function(x=absM$JJTave, y=absM$doy, sites= absM$YrSite, Nruns,Nsamp){
  out<- matrix(NA, nrow=Nruns, ncol=6)
  
  for(r in 1:Nruns){
    
    #sub sample
    z <- sapply(unique(sites), FUN= function(x){ 
      sample(which(sites==x), min(Nsamp, length(which(sites==x))), FALSE)
    })
    x.boot<- x[unlist(z)]
    y.boot<- y[unlist(z)]
    
    #run model
    mod1= lm(y.boot~x.boot)
    mod1$coefficients[2]
    
    out[r,]=c(summary(mod1)$coefficients[1,1], summary(mod1)$coefficients[2,], summary(mod1)$r.squared )
    
  }# end loop
  
  #average
  colnames(out)= c("Intercept","Estimate","SE","t","P","r^2")
  out.r= colMeans(out)
  
  return(out.r)
}

#=================================
#SPATIAL ANALYSIS 1 PREDICTOR

#FUNCTION TO RUN SPATIAL ANALYIS, error model, 40km neighborhood
spat.mod.reg= function(y, x, lon, lat){
  
  #define spatial neighborhood
  coords= as.matrix(cbind(lon,lat))
  ## Build neighborhood
  m.nb40 <- dnearneigh(coords,0,40,longlat=TRUE)
  # establish weights for the given list of neighbors, "B" = binary (all equal), "W" = row standardized
  m.sw40 <- nb2listw(m.nb40, glist=NULL, style="W", zero.policy=TRUE)
  
  #--------
  #MODELS
  m_SAR40= spautolm(y~x, listw= m.sw40, family = "SAR", method="eigen", na.action='na.pass')

  ret=c(summary(m_SAR40)$Coef[1,1], summary(m_SAR40)$Coef[2,], summary(m_SAR40)$LR1$statistic,  summary(m_SAR40)$LR1$p.value )
  
  return(ret )
  
} #end spatial analysis function

#--------------
#bootstrap

boot.sar.lm<- function(y,x,lon,lat, sites, Nruns,Nsamp){
  out<- matrix(NA, nrow=Nruns, ncol=7)
  
  for(r in 1:Nruns){
    
    #sub sample
    z <- sapply(unique(sites), FUN= function(x){ 
      sample(which(sites==x), min(Nsamp, length(which(sites==x))), FALSE)
    })
    x.boot<- x[unlist(z)]
    y.boot<- y[unlist(z)]
    lon.boot<- lon[unlist(z)]
    lat.boot<- lat[unlist(z)]
    
    #run model
    out[r,]=spat.mod.reg(y=y.boot, x=x.boot, lon=lon.boot, lat=lat.boot)
    
  }# end loop
  
  #average
  colnames(out)= c("Intercept","Estimate","SE","z","P","LR","LR_P")
  out.r= colMeans(out)
  
  return(out.r)
}

#=================================
#Multiple regression (no dredge or model selection, see below for model selection)
#fix for 2 predictors and interaction

#FUNCTION TO RUN SPATIAL ANALYIS, error model, 40km neighborhood
spat.mod.mult= function(y, x1,x2, lon, lat){
  
  #define spatial neighborhood
  coords= as.matrix(cbind(lon,lat))
  ## Build neighborhood
  m.nb40 <- dnearneigh(coords,0,40,longlat=TRUE)
  # establish weights for the given list of neighbors, "B" = binary (all equal), "W" = row standardized
  m.sw40 <- nb2listw(m.nb40, glist=NULL, style="W", zero.policy=TRUE)
  
  #--------
  #MODELS
  m_SAR40= spautolm(y~x1*x2, listw= m.sw40, family = "SAR", method="eigen", na.action='na.pass')
  
  ret=c(summary(m_SAR40)$Coef[1,1], summary(m_SAR40)$Coef[2,],summary(m_SAR40)$Coef[3,],summary(m_SAR40)$Coef[4,], summary(m_SAR40)$LR1$statistic,  summary(m_SAR40)$LR1$p.value )
  
  return(ret )
  
} #end spatial analysis function

#--------------
#bootstrap

boot.sar.mult<- function(y,x1,x2,lon,lat, sites, Nruns,Nsamp){
  out<- matrix(NA, nrow=Nruns, ncol=7)
  
  for(r in 1:Nruns){
    
    #sub sample
    z <- sapply(unique(sites), FUN= function(x){ 
      sample(which(sites==x), min(Nsamp, length(which(sites==x))), FALSE)
    })
    x.boot<- x[unlist(z)]
    y.boot<- y[unlist(z)]
    lon.boot<- lon[unlist(z)]
    lat.boot<- lat[unlist(z)]
    
    #run model
    out[r,]=spat.mod.reg(y=y.boot, x=x.boot, lon=lon.boot, lat=lat.boot)
    
  }# end loop
  
  #average
  colnames(out)= c("Intercept","Estimate","SE","z","P","LR","LR_P")
  out.r= colMeans(out)
  
  return(out.r)
}




#=================================
#SPATIAL ANALYSIS
dat= na.omit(absM)
spat.mod.var(dat, yvar="Corr.Val", xvars=c("JJTave","doy","doy:doy162to202"), dat$lon, dat$lat)
  
#FUNCTION TO RUN SPATIAL ANALYIS, error model, 40km neighborhood
spat.mod.var= function(dat, yvar, xvars, lon, lat){
  
  #define spatial neighborhood
  coords= as.matrix(cbind(lon,lat))
  ## Build neighborhood
  m.nb40 <- dnearneigh(coords,0,40,longlat=TRUE)
  # establish weights for the given list of neighbors, "B" = binary (all equal), "W" = row standardized
  m.sw40 <- nb2listw(m.nb40, glist=NULL, style="W", zero.policy=TRUE)
  
  #--------
  #MODELS
  m_SAR40= spautolm(as.formula(paste(yvar, "~", paste(xvars, collapse="+"))), data=dat, listw= m.sw40, family = "SAR", method="eigen", na.action='na.pass')
  
  #MODEL SELECTION
  d_SAR40=dredge(m_SAR40)
  
  #extract best 5 models and weights
  best.mods= d_SAR40[1:5,]
  
  ma_SAR40= model.avg(d_SAR40)
  
  #extract coefficients
  name.ord= c("(Intercept)",xvars,"lambda")
  ct= summary(ma_SAR40)$coefmat.full
  match1= match(name.ord, rownames(ct))
  coef.mods=ct[match1,]
  
  #add importance values
  imports= rep(NA, nrow(coef.mods))
  match1=match(names(ma_SAR40$importance), row.names(coef.mods))
  imports[match1]= ma_SAR40$importance
  coef.mods= cbind(coef.mods, imports)
  
  #full model as all terms have some support
  m_x.errorSAR40 <- errorsarlm(as.formula(paste(yvar, "~", paste(xvars, collapse="+"))), data=dat, m.sw40, method="eigen", quiet=TRUE, zero.policy=TRUE, na.action=na.fail, interval=c(-0.5,0.5),tol.solve=1e-25)
 
  mod.sum= summary(m_x.errorSAR40, Nagelkerke=TRUE, Hausman=TRUE)
  
  #extract Z values and pr(>|z|) 
  zs=mod.sum$Coef[,1:4] #z, p
  
  #Log-likelihood ratio tests
  # only use LR.sarlm when nested. otherwise compare Loglikelihood values
  mod.null <- errorsarlm(as.formula(paste(yvar,"~1")), data=dat, m.sw40, method="eigen", quiet=TRUE, zero.policy=TRUE, na.action=na.fail, interval=c(-0.5,0.5),tol.solve=1e-25)
  lr1= LR.sarlm(m_x.errorSAR40, mod.null)
  
  mod.stats= c(mod.sum$NK,lr1$statistic, lr1$p.value )
  names(mod.stats)[1]= "NKPseudoR2"
  
  return(list(best.mods, coef.mods, zs, mod.stats) )
  
} #end spatial analysis function

#=================================
#BOOTSTRAP SPATIAL MODEL

boot.spatlm<- function(dat, sites= dat$YrSite, yvar="Corr.Val", xvars=c("JJTave","doy","doy:JJTave"), lon, lat, Nruns,Nsamp){
  
  #set up data collection
  out.mods= array(data=NA, dim=c(5,length(xvars)+6,Nruns))
  out.coefs=array(data=NA, dim=c(length(xvars)+2,5,Nruns))
  out.zs=array(data=NA, dim=c(length(xvars)+1,4,Nruns))
  out.stats= matrix(NA, 3, Nruns)
  
  #bootstrap
  for(r in 1:Nruns){
    
    #sub sample
    z <- sapply(unique(sites), FUN= function(x){ 
      sample(which(sites==x), min(Nsamp, length(which(sites==x))), FALSE)
    })
    absM.boot<- dat[unlist(z),]
    
    #run spatial model
    out= spat.mod.var(absM.boot, yvar="Corr.Val", xvars=c("JJTave","doy","doy:JJTave"), absM.boot$lon, absM.boot$lat)
    
    #extract output
    bm=out[[1]]
    out.mods[,,r]=as.matrix(bm)
    out.coefs[,,r]=out[[2]]
    out.zs[,,r]=out[[3]]
    out.stats[,r]=out[[4]]
    
  }#end bootstrap
  
  #PROCESS OUTPUT
  #ADD NAMES
  dimnames(out.mods)[[2]]= colnames(out[[1]])
  dimnames(out.coefs)[[1]]= rownames(out[[2]])
  dimnames(out.coefs)[[2]]= colnames(out[[2]])
  dimnames(out.zs)[[1]]= rownames(out[[3]])
  dimnames(out.zs)[[2]]= colnames(out[[3]])
  rownames(out.stats)= names(out[[4]])
  
  #AVERAGE
  coefs= apply(out.coefs, MARGIN=c(1,2), FUN="mean") 
  zs= apply(out.zs, MARGIN=c(1,2), FUN="mean") 
  stats=  apply(out.stats, MARGIN=c(1), FUN="mean") 
  
  return(list(coefs, zs, stats) )
  
} #end bootstrap function

#=============================
my.prplot= function (g, i, xlabs)  #beautify plot
{
  xl <- xlabs[i]
  yl <- paste("")
  x <- model.matrix(g)[, i + 1]
  plot(x, g$coeff[i + 1] * x + g$res, xlab = xl, ylab = yl, col=rgb(0.2,0.2, 0.2, 0.5),pch=16)        
  abline(0, g$coeff[i + 1])
  invisible()
}
#--------------
