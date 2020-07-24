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

def robustassess(n,d,k=2.24): #raw frequency, doc length and threshold
    v=np.divide(n,d)

    rawcount=np.sum(n)
    
    mu=biweight_location(v)
    s=biweight_scale(v)
    mu2s=mu+k*s
    vcliph2s=np.minimum(v,mu2s); #Winsorising

    docsclipped=np.sum(np.greater(v, vcliph2s))

    adjustedcount=int(np.sum(vcliph2s*d))

    proportionv=n/rawcount # proportion of word frequency per document
    proportiond=d/N        # document size proportion
    kld=np.sum(np.multiply(proportionv,np.log2(np.divide(proportionv,proportiond))))

    return [rawcount, adjustedcount,docsclipped,len(n),'%.3f' % kld]

def formatout(w,nlist):
    return '\t'.join([w] + [str(n) for n in nlist])

#corpus size
N=int(sys.argv[1])
# min doc count for words
mincount=int(sys.argv[2]) if len(sys.argv)>2 else 5
f=open(sys.argv[3]) if len(sys.argv)>3 else sys.stdin

prev=''
n=[]
d=[]

for line in f:
    x=line.split();    
    if len(x)>2:
        if x[0] != prev and len(prev)>0:
            if len(n)>mincount:
                print(formatout(prev,robustassess(np.array(n),np.array(d))))
            n=[]
            d=[]
        prev=x[0]
        try:
            n.append(int(x[1]))
            d.append(int(x[2]))
        except:
            print('Error in line: '+line,file=sys.stderr)

if len(n)>mincount:
    print(formatout(prev,robustassess(np.array(n),np.array(d))))
