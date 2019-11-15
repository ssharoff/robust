> Nothing in Nature is random… A thing appears random only through the incompleteness of our knowledge. ---Spinoza, Ethics I

Know thy corpus!
================

Frequency lists are widely used in lexicography, computational linguistics and language education studies. However, word frequency lists coming from different corpora differ considerably in spite of relatively small changes in their composition, because some words can become too frequent in a relatively small number of texts specific to this corpus, so their frequency counts provide unreliable information about their expected frequency. Adam Kilgarriff referred to them as *whelks*, a rare word, which can become topical. The whelks of the British National Corpus (BNC) are medical terms, as seen in the following two extracts from the BNC frequency list:

1.  *moon, assert, crown, \*gastric\*<sub>3763</sub>, correct, lock, mutual, thoroughly*
2.  *planner, evil, cage, \*pylorus\*<sub>5955</sub>, disguise, sunlight, repay*

While texts taken from the Journal of Gastroentorology and Hepatology contribute less than 0.8% (713 thousand tokens) to the BNC, the frequency bursts of words from this domain propel them into the core lexicon (the numbers in the subscript refer to their rank in the BNC frequency list). No corpus is immune to whelks. For example, the frequency of *Texas* in the LDC Gigaword corpus is greater than that of such common words as *long* or *car*.

The tools listed here produce frequency lists by using document-level measures to filter out frequency bursts using methods from robust statistics. The method which this study found to be more useful is based on *h**u**b**e**r**M* and *S*<sub>*n*</sub> estimators of expected values and the percentile bootstrap for the confidence intervals. <https://cran.r-project.org/package=robustbase>

In short, we determine robust estimates of how many times a word **can** occur in a document of this corpus. With this value we clip (Winsorise) its frequency to our predicted robust estimate if the frequency exceeds the estimate. This helps in describing the frequency distributions from different corpora by making more reliable estimates how common the words and their constructions are, and in inferring the significant differences in the lexicons of different text collections, e.g., detecting problems in a given corpus, how a Web crawl is different from the BNC, etc. For the rationale and the methodology, see a forthcoming chapter:

``` example
@InCollection{sharoff2017knowthy,
  author =   {Serge Sharoff},
  title =    {Know thy corpus! {Exploring} frequency distributions in large corpora},
  booktitle =    {Essays in Honor of Adam Kilgarriff},
  publisher = {Springer},
  year =     2017,
  editor =   {Mona Diab and Aline Villavicencio},
  series =   {Text, Speech and Language Technology}}
```

Scripts
=======

The starting point for building a robust frequency list is a document level frequency list, e.g.,

``` example
correct 1 8309
correct 1 20116
gastric 1 62338
gastric 17 59681
```

In this example, *correct* occurs once in two documents (with the length of 8309 and 20116 words). 

A list of this kind is produced by taking a corpus in the form of one document per line and running:

`docfrq-list.sh`

If a computer cluster with many computing nodes is available, this list can be produced for a large corpus much faster by running ~frq-split.sh~ to split the corpus into fixed-size chunks and to compute the document level frequency lists in parallel.  After that the separate frequency lists can be combined by running

`collect-numfiles.sh`

Finally `robustpython.py` can be used to compute the robust frequency list:

`xzcat bnc-doc.num.xz | python3 robustpython.py 5 | sort -nsrk3,3 >bnc-clean.num`

The parameter is the document level frequency threshold, i.e., the words for the frequency list need to occur in at least 5 documents in this example.

For each object of counting, `robust-1000.R` outputs (1) the raw frequency,  (2) the adjusted robust frequency value counted for all documents with Winsorisation, (3) the number of documents subject to Winsorisation, and (4) the document frequency.
