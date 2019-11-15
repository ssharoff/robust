#!/usr/bin/env python3
# -*- coding: utf-8 -*- 

import sys
from astropy.stats import biweight_location, biweight_scale
import numpy as np

def robustassess(n,d): #raw frequency and document length
    v=np.divide(n,d)

    rawcount=np.sum(n)

    mu=biweight_location(v)
    s=biweight_scale(v)
    mu2s=mu+2.24*s
    vcliph2s=np.minimum(v,mu2s); #Winsorising by huber+2.24S_n

    docsclipped=np.sum(np.greater(v, vcliph2s))

    adjustedcount=int(np.sum(vcliph2s*d))

    return [rawcount,adjustedcount,docsclipped]
    

n=[]
d=[]
for l in open(sys.argv[1]):
    x=l.split()
    n.append(int(x[1]))
    d.append(int(x[2]))

robustassess(np.array(n), np.array(d))
