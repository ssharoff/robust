#!/usr/bin/env python3
# -*- coding: utf-8 -*- 

# Copyright (C) 2019  Serge Sharoff
# This program is free software under GPL 3, see http://www.gnu.org/licenses/
# The tool produces document level frequency lists for each line in the input stream

import sys, string
from collections import defaultdict

f=sys.stdin if len(sys.argv)<2 else open(sys.argv[1])
for text in f:
    l=text.strip().split()
    d=defaultdict(int)
    for w in l:
        if (not w[0] in string.punctuation) and (not w[-1] in string.punctuation) and (not w.isnumeric()):
            d[w.lower()] +=1 
    for w in d:
        print('%s %d %s' % (w, d[w], len(l)))
