#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
# Copyright (C) 2017  Serge Sharoff
# This program is free software under GPL 3, see http://www.gnu.org/licenses/
'''
A script for inferring topics for documents with an existing model
'''
import sys
from gensim.models.ldamulticore import LdaMulticore
from gensim.corpora import Dictionary, TextCorpus

mname=sys.argv[1]
cname=sys.argv[2]

lda=LdaMulticore.load(mname)
dictionary = Dictionary.load_from_text(cname + '_wordids.txt.bz2')
wiki=TextCorpus.load(cname + '_corpus.pkl.bz2')

for d in wiki.get_texts():
    #bow = dictionary.doc2bow(d.split())
    t = lda.get_document_topics(dictionary.doc2bow(d))
    print(t)
