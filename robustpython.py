#!/usr/bin/env python3
# -*- coding: utf-8 -*- 

# Copyright (C) 2017  Serge Sharoff
# This program is free software under GPL 3, see http://www.gnu.org/licenses/
# The tool computes frequency estimates from the document  frequency list
# correct	2	8796
# correct	1	21522

import sys
from astropy.stats import biweight_location, biweight_scale
import numpy as np

def robustassess(w,n,d,k=2.24): #raw frequency, doc length and threshold
    v=np.divide(n,d)

    rawcount=np.sum(n)

    mu=biweight_location(v)
    s=biweight_scale(v)
    mu2s=mu+k*s
    vcliph2s=np.minimum(v,mu2s); #Winsorising

    docsclipped=np.sum(np.greater(v, vcliph2s))

    adjustedcount=int(np.sum(vcliph2s*d))

    return [w, str(rawcount),str(adjustedcount),str(docsclipped),str(len(n))]

# min doc count for words
mincount=int(sys.argv[1]) if len(sys.argv)>1 else 5
f=open(sys.argv[2]) if len(sys.argv)>2 else sys.stdin

prev=''
n=[]
d=[]

for line in f:
    x=line.split();    
    if len(x)>2:
        if x[0] != prev and len(prev)>0:
            if len(n)>mincount:
                print('\t'.join(robustassess(prev,np.array(n), np.array(d))))
            n=[]
            d=[]
        prev=x[0]
        try:
            n.append(int(x[1]))
            d.append(int(x[2]))
        except:
            print('Error in line: '+line,file=sys.stderr)

if len(n)>mincount:
    print('\t'.join(robustassess(prev,np.array(n), np.array(d))))
