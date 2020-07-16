> Nothing in Nature is random… A thing appears random only through the incompleteness of our knowledge. ---Spinoza, Ethics I

# Know thy corpus!

Frequency lists determine the probability estimates in language models.  They are also widely used in lexicography, corpus linguistics and language education studies. However, word frequency lists coming from different corpora differ considerably in spite of relatively small changes in their composition, because some words can become too frequent in a relatively small number of texts specific to this corpus, so their frequency counts provide unreliable information about their expected frequency. Adam Kilgarriff referred to them as *whelks*, a rare word, which can become topical. The whelks of the British National Corpus (BNC) are medical terms, as seen in the following two extracts from the BNC frequency list:

1.  *foods, lighting, sciences, anglo, emerge, contacts, **gastric**, desirable, 1950s, gender, poland, picking, suggestions, enjoying, laughter* 
2.  *incidentally, sticking, angrily, speeds, drum, spine, realm, **mucosa**, heather, allegedly, rested, builders, lid, invention, blowing*

where the frequency of *gastric* is ranked higher than *desirable* and *mucosa* is ranked higher than *builders*.  While texts taken from the Journal of Gastroentorology and Hepatology contribute less than 0.8% (713 thousand tokens) to the BNC, the frequency bursts of words from this domain propel them into the core lexicon. No corpus is immune to whelks. For example, the frequency of *Texas* in the LDC Gigaword corpus is greater than that of such common words as *long* or *car*.

Robust lists for a number of languages and corpora are listed in the [Frequency lists](#frequency-lists) section below. 

# Robust methods

The tools in this repository can produce robust frequency lists by using document-level measures to filter out frequency bursts using methods from robust statistics. The method which this study found to be more useful is based on *huberM* and *S*<sub>*n*</sub> estimators of expected values.

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
[https://arxiv.org/abs/2003.06389](https://arxiv.org/abs/2003.06389)

# Scripts

The starting point for building a robust frequency list is a document level frequency list, e.g.,

``` example
correct 1 8309
correct 1 20116
gastric 1 62338
gastric 17 59681
```

In this example, *correct* occurs once in two documents (with the lengths of 8309 and 20116 words), while *gastric* occurs once in one document and 17 times in another one. This is an outlying observation which can be detected using methods from robust statistics. 

A list of this kind is produced by taking a corpus in the form of a single file with one document per line, e.g.
``` example
... invariably , even when we have needed to correct or update details in our reports ,
... diffuse into the gastric lumen , so the presence of any iron in fasting gastric juice
```

and running:

`frq-line.py corpus.ol >corpus-doc.num`

If a computer cluster with many computing nodes is available, this list can be produced for a large corpus much faster by running `split -l XX corpus.ol` to split the corpus into chunks with a fixed number of documents (XX), so that the document level frequency lists can be computed in parallel.  After that the separate frequency lists can be combined by running `sort x*.num >corpus-doc.num`

Finally `robustpython.py` can be used to compute the robust frequency list:

`xzcat bnc-doc.num.xz | python3 robustpython.py 5 | sort -nsrk3,3 >bnc-clean.num`

The parameter is the document level frequency threshold, i.e., the words for the frequency list need to occur in at least 5 documents in this example.

For each word (or another object of counting, such as lemma or n-gram), `robustpython.py` outputs in tab-separated format: 
1. the word itself,
1. the raw frequency, 
2. the adjusted robust frequency value counted for all documents with Winsorisation, 
3. the number of documents subject to Winsorisation, and 
4. the document frequency.

The most significant changes in the frequency list before and after robust estimation (produced by the Perl script `compare_fq_lists.pl` in the repository) from the BNC are as follows:

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
| ...           |       |        |          |
| mucosa        | 1041  | 133    | 74       |

For example, *Athelstan, Darlington* or *[Theda](http://corpus.leeds.ac.uk/cgi-bin/cqp.pl?q=Theda&c=BNC&t=150)* are person names in some of the BNC texts (e.g., "The remains of the day" for *Darlington*), while the frequency busts of *Hon* (which takes it to the top 1000 most frequent words) is down to long lists like: *The Princess Margaret, Countess of Snowdon was represented by the **Hon** Mrs Wills at the Memorial Service for Colonel the **Hon** Sir Gordon Palmer.*

For information about the log-likelihood score see  <http://ucrel.lancs.ac.uk/llwizard.html>

# Frequency lists
## English
### Lists of word forms:
1.  [BNC.](http://corpus.leeds.ac.uk/frqc/robust/bnc-clean2.num) This is from the classic [British National Corpus.](http://www.natcorp.ox.ac.uk/)
2.  [ukWac.](http://corpus.leeds.ac.uk/frqc/robust/ukwac-clean2.num) A corpus from the [Wacky family.](https://wacky.sslmit.unibo.it/doku.php)
3.  [Wikipedia.](http://corpus.leeds.ac.uk/frqc/robust/wiki-en-clean2.num)
4.  [OpenWebText.](http://corpus.leeds.ac.uk/frqc/robust/openwebtext-clean2.num) This is a clone of OpenAI's corpus collected from upvoted links [OpenWebText.](https://github.com/jcpeterson/openwebtext)
5.  [CCNET.](http://corpus.leeds.ac.uk/frqc/robust/ccnet-en-200-clean2-biwt.num.xz) This is the English corpus from the Common Crawl cleaned for XLM-R, see [the paper.](http://www.lrec-conf.org/proceedings/lrec2020/pdf/2020.lrec-1.494.pdf)

## Russian
Lists of lemmas with POS codes:
1.  [Russian National Corpus.](http://corpus.leeds.ac.uk/frqc/robust/rnc-orig.out.lpos-clean2-biwt.num.xz)
 You can compare this to the raw RNC frequencies in the classic list of [Lyashevskaya and Sharoff, 2009.](http://dict.ruslang.ru/freq.php)
2.  [ruTenTen.](http://corpus.leeds.ac.uk/frqc/robust/ruTenTen.vert.xz.lpos-clean2-biwt.num.xz) A popular corpus from the [SketchEngine.](https://www.sketchengine.eu/rutenten-russian-corpus/)
3.  [ruWac.](http://corpus.leeds.ac.uk/frqc/robust/ruwac.out.gz.lpos-clean2-biwt.num.xz) A corpus from the [Wacky family.](https://wacky.sslmit.unibo.it/doku.php)
4.  [GICR.](http://corpus.leeds.ac.uk/frqc/robust/news.out.xz.lpos-clean2-biwt.num.xz) This is the news component of the [General Internet Corpus of Russian.](http://www.webcorpora.ru/en/)
5.  [Aranea Maximus.](http://corpus.leeds.ac.uk/frqc/robust/ru-maximus.xz.lpos-clean2-biwt.num.xz) A large Aranea Web crawl for Russian, see [the paper.](https://link.springer.com/article/10.1007/s10579-020-09487-4)

The POS codes have not been unified. They follow the conventions in each respective corpus, e.g., *_s* for nouns in the RNC vs *_n* in other corpora.

## Wikipedia lists
Robust frequency filtering helps in removing various artifacts of Wikipedia processing, e.g., unreasonably frequent *pomeranian, montane, spurred, substrates, encompassed, italianate, prelate, attaining* in the BERT BPE lexicon.

  * [Arabic](http://corpus.leeds.ac.uk/frqc/robust/wikipedia-ar-robust.tsv)
  * [Czech](http://corpus.leeds.ac.uk/frqc/robust/wikipedia-cs-robust.tsv)
  * [English](http://corpus.leeds.ac.uk/frqc/robust/wiki-en-clean2.num)
  * [Italian](http://corpus.leeds.ac.uk/frqc/robust/wikipedia-it.tsv)
  * [Polish](http://corpus.leeds.ac.uk/frqc/robust/wikipedia-pl.tsv)
  * [Russian](http://corpus.leeds.ac.uk/frqc/robust/wikipedia-ru-robust.tsv)
  * [Ukrainian](http://corpus.leeds.ac.uk/frqc/robust/wikipedia-uk-robust.tsv)
