> Nothing in Nature is random… A thing appears random only through the incompleteness of our knowledge. ---Spinoza, Ethics I

Know thy corpus!
================

Frequency lists are widely used in lexicography, computational linguistics and language education studies. However, word frequency lists coming from different corpora differ considerably in spite of relatively small changes in their composition, because some words can become too frequent in a relatively small number of texts specific to this corpus, so their frequency counts provide unreliable information about their expected frequency. Adam Kilgarriff referred to them as *whelks*, a rare word, which can become topical. The whelks of the British National Corpus (BNC) are medical terms, as seen in the following two extracts from the BNC frequency list:

1.  *foods, lighting, sciences, anglo, emerge, contacts, **gastric**, desirable, 1950s, gender, poland, picking, suggestions, enjoying, laughter* 
2.  *incidentally, sticking, angrily, speeds, drum, spine, realm, **mucosa**, heather, allegedly, rested, builders, lid, invention, blowing*

where the frequency of *gastric* is ranked higher than *desirable* and *mucosa* is ranked hight than *builders*.  While texts taken from the Journal of Gastroentorology and Hepatology contribute less than 0.8% (713 thousand tokens) to the BNC, the frequency bursts of words from this domain propel them into the core lexicon (the numbers in the subscript refer to their rank in the BNC frequency list). No corpus is immune to whelks. For example, the frequency of *Texas* in the LDC Gigaword corpus is greater than that of such common words as *long* or *car*.

The tools listed here produce frequency lists by using document-level measures to filter out frequency bursts using methods from robust statistics. The method which this study found to be more useful is based on *huberM* and *S*<sub>*n*</sub> estimators of expected values.

In short, we determine robust estimates of how many times a word **is likely** to occur in a document of this corpus.  With this value we clip (Winsorise) its frequency to our predicted robust estimate if the frequency exceeds the estimate in the case of a frequency burst in this document.  This helps in describing the frequency distributions from different corpora by making more reliable predictions of how common the words and their constructions are, and in inferring the significant differences in the lexicons of different text collections, e.g., detecting problems in a given corpus, how a Web crawl is different from the BNC, etc. For the rationale and the methodology, see:

``` example
@InProceedings{sharoff20,
  author = 	 {Serge Sharoff},
  title = 	 {Know thy corpus! Robust methods for digital curation of Web corpora},
  booktitle = {Proc LREC},
  year = 	 2020,
  month = 	 {May},
  address = 	 {Marseilles}}
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

In this (artifiial) example, *correct* occurs once in two documents (with the length of 8309 and 20116 words), while *gastric* occurs once in one document and 17 times in another one. This is an outlying observation which can be detected using methods from robust statistics. 

A list of this kind is produced by taking a corpus in the form of one document per line and running:

`docfrq-list.sh`

If a computer cluster with many computing nodes is available, this list can be produced for a large corpus much faster by running `frq-split.sh` to split the corpus into fixed-size chunks and to compute the document level frequency lists in parallel.  After that the separate frequency lists can be combined by running `collect-numfiles.sh`

Finally `robustpython.py` can be used to compute the robust frequency list:

`xzcat bnc-doc.num.xz | python3 robustpython.py 5 | sort -nsrk3,3 >bnc-clean.num`

The parameter is the document level frequency threshold, i.e., the words for the frequency list need to occur in at least 5 documents in this example.

For each word (or another object of counting, such as lemma or n-gram), `robustpython.py` outputs: 
1. the raw frequency, 
2. the adjusted robust frequency value counted for all documents with Winsorisation, 
3. the number of documents subject to Winsorisation, and 
4. the document frequency.

The `diff` file shows the most significant changes in the frequency list before and after robust estimation (produced by the Perl script `compare_fq_lists.pl` in the repository):

| Word          | Raw   | Robust | LL-score |
|---------------|-------|--------|----------|
| hon           | 10709 | 378    | 2890     |
| lifespan      | 3854  | 110    | 1139     |
| darlington    | 5606  | 426    | 875      |
| inc           | 6584  | 794    | 527      |
| taped         | 4151  | 460    | 389      |
| athelstan     | 1061  | 15     | 385      |
| gastric       | 2085  | 154    | 335      |
| theda         | 838   | 9      | 320      |
| robyn         | 1206  | 46     | 313      |
| middlesbrough | 3620  | 488    | 227      |
| infinitive    | 721   | 22     | 208      |
| jenna         | 668   | 19     | 198      |
| minton        | 760   | 29     | 197      |
| ronni         | 538   | 8      | 193      |
| corbett       | 1541  | 144    | 188      |
| colonic       | 830   | 42     | 183      |

*Athelstan* and *Darlington* are person names in some of the BNC texts, while *Middlesbrough* (along with *Darlington*) experiences frequency bursts in sport results.

For information about the log-likelihood score see  <http://ucrel.lancs.ac.uk/llwizard.html>
