qsub frq-split1.sh bnc 1000 # from bnc.ol.xz
cd bnc
qsub -t 1-100 ../frq.sh # -t is the number of x0000 files
qsub collect-numfiles.sh bnc
qsub splitt-frq.sh bnc 100 # the minimal word frqc
cd bnc-robust
qsub -t 1-1000 ../robust-frq.sh 4054 112189129 # -t is the number of .dat files / 1000
collect-frq-clean.sh bnc-robust
