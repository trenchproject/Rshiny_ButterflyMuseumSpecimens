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

# areg= na.omit(areg)
# y= areg$Corr.Val
# x1= areg$Tpupal
# x2= areg$Year
# lon= areg$lon
# lat= areg$lat
# sites= areg$YrSite

set.ZeroPolicyOption<-TRUE

#FUNCTION TO RUN SPATIAL ANALYIS, error model, 40km neighborhood
spat.mod.mult= function(y, x1,x2, lon, lat){
  
  #define spatial neighborhood
  coords= as.matrix(cbind(lon,lat))
  ## Build neighborhood
  m.nb40 <- dnearneigh(coords,0,40,longlat=TRUE)
  # establish weights for the given list of neighbors, "B" = binary (all equal), "W" = row standardized
  m.sw40 <-nb2listw(m.nb40, glist=NULL, style="W", zero.policy=TRUE)
  
  #--------
  #MODELS
 m_SAR40<-  try(spautolm(y~x1*x2, listw= print(m.sw40, zero.policy=TRUE), family = "SAR", method="eigen", na.action='na.pass'), silent=TRUE)
  ret= rep(NA,15)
  
  if(class(m_SAR40) != "try-error") ret=c(summary(m_SAR40)$Coef[1,1], summary(m_SAR40)$Coef[2,],summary(m_SAR40)$Coef[3,],summary(m_SAR40)$Coef[4,], summary(m_SAR40)$LR1$statistic,  summary(m_SAR40)$LR1$p.value )
  
  return(ret )
  
} #end spatial analysis function
 
#--------------
#bootstrap

boot.sar.mult<- function(y,x1,x2,lon,lat, sites, Nruns,Nsamp){
   
  out<- matrix(NA, nrow=Nruns, ncol=15)
    
       for(r in 1:Nruns){
           
            #sub sample
             z <- sapply(unique(sites), FUN= function(x){ 
                sample(which(sites==x), min(Nsamp, length(which(sites==x))), FALSE)
               })
             x1.boot<- x1[unlist(z)]
             x2.boot<- x2[unlist(z)]
             y.boot<- y[unlist(z)]
             lon.boot<- lon[unlist(z)]
            lat.boot<- lat[unlist(z)]
            
             #run model
             out[r,]=spat.mod.mult(y=y.boot, x1=x1.boot,x2=x2.boot, lon=lon.boot, lat=lat.boot)
             
              }# end loop
  
  #change NaN to NA
  out[is.nan(out)] <- NA
  
  #average
  colnames(out)= c("Intercept","Estimate.x1","SE.x1","z.x1","P.x1","Estimate.x2","SE.x2","z.x2","P.x2","Estimate.x1:x2","SE.x1:x2","z.x1:x2","P.x1:x2","LR","LR_P")
  out.r= colMeans(out, na.rm = TRUE)
  
  return(out.r)
}
 