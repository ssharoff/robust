#!/usr/bin/env python3
# -*- coding: utf-8 -*- 

# Copyright (C) 2019  Serge Sharoff
# This program is free software under GPL 3, see http://www.gnu.org/licenses/
# The tool analyses the output of the gensim topic distribution over docts
# [(13, 0.11671868), (19, 0.38746485), (32, 0.104120485), (78, 0.28481057)]

import sys
import ast
f=open(sys.argv[1]) if len(sys.argv)>1 else sys.stdin
topics={}
for l in f:
    if l.startswith('[('):
        for topic in ast.literal_eval(l):
            if topic[0] in topics:
                topics[topic[0]] += topic[1]
            else:
                topics[topic[0]] = topic[1]

for t in topics:
    print('%d\t%.2f' % (t,topics[t]))
    
