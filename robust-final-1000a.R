#the script does the final run to compute reduced frequency for:
#Winsorisation of document frequencies by $\mu+2\sigma, median+2.24MAD, huber+2.24S_n$
library(robustbase);
#dir='/nobackup/smlss/ukwac-frq/';
args=commandArgs(trailingOnly=T); #args=c('4276','4054','112000000','1')
print(paste(args));
file=as.numeric(args[1]);
doccount=as.numeric(args[2]); # corpus size in docs
wcount=as.numeric(args[3]);   # corpus size in words
rangesize=1000;  #as.numeric(args[4]);   # range size

mureliable = function(x,bend=1.28) {
    v=x[x>0];
    hm=huberM(v,bend)$mu;
    s=Sn(v);
    hm2s=hm+2.24*s;
    vfcliph2m=pmin(x,hm2s); #Winsorising x
    return(mean(vfcliph2m))
}

outmeasures = function (docsize,n) { #docsize and real counts
   lv=length(docsize); # tobeadded=doccount-lv;
#   vf=c(v,rep(0,times=tobeadded));  # we need to make full vectors with zeros
#   nf=c(n,rep(0,times=tobeadded));
   # docsize=1e6*n/v; #an approximation of doc sizes for c>0
   #sfreal=c(s,rep((wcount-sum(s))/tobeadded,tobeadded));

   rawcount=sum(n) # nf
   
   alpha=lv/doccount;  #pars from Katz 1995

   ## sigma=sd(v);
   ## mu=mean(v);
   ## mu2s=mu+2*sd(v);
   ## med=median(v);
   ## mad=mad(v);
   ## m2m=med+2.24*mad;
   ipm=1e6*n/docsize;
   hm=huberM(ipm)$mu;
   s=Sn(ipm);
   hm2s=hm+2.24*s;
#print(sum(v>mu2s));
#print(sum(v>m2m));
#print(sum(v>hm2s));
#    vfclipm2s=vf[vf<mu2s];
#    vfcliph2m=vf[vf<hm2m];
    ## vfclipmu2s=pmin(vf,mu2s); #Winsorising by \mu+2\sigma, 
    ## vfclipm2m=pmin(vf,m2m); #Winsorising by median+2.24MAD, 
    vcliph2s=pmin(ipm,hm2s); #Winsorising by huber+2.24S_n

    ## ln1=length(n[n==1]);
    ## gamma=1-(ln1/lv);
    ## b=(sum(n)-ln1)/(lv-ln1);
# returning: raw, raw*alpha, mean ipm, mean vclip, number of v>hm2s, adjusted natural frequency
   return(c(rawcount,rawcount*alpha,1e-6*rawcount/doccount,sum(vcliph2s)/doccount,sum(ipm>hm2s),sum(as.integer(vcliph2s*1e-6*docsize)))); 
}

startrange=rangesize*(file-1)+1;
endrange=startrange+rangesize-1;
options(digits=4);

for (file1 in startrange:endrange) {

    pfile=paste(file1,'.dat',sep='');


    v.all <- tryCatch({
    	      read.table(pfile); 
	      }, error = function(err) {
	      print(paste('Error reading',pfile));
	      data.frame(x=character());
   });

   if (length(v.all[1,])>2) {
      out=outmeasures(v.all[,3],v.all[,2]);
      res=c(as.character(v.all[1,1]),out);

      outfile=paste(v.all[1,1],'-',file1,'.out',sep='');
      print(outfile);

      write.table(res,file=outfile );
   }

};

