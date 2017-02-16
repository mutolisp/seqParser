# seqParser
DNA sequence parser

[![Build Status](https://travis-ci.org/mutolisp/seqParser.svg?branch=master)](https://travis-ci.org/mutolisp/seqParser)

## What does seqParser do

* clip by primers

![seqParser](https://github.com/mutolisp/seqParser/raw/master/docs/seqParser1.png)

related function: ```getCuttedPrimer(primer, len, direction='forward'), grepSeqByPrimer(seq, fprimer, rprimer)```

* sort by groups

![seqParser](https://github.com/mutolisp/seqParser/raw/master/docs/seqParser2.png)

## Installation

```R
# assume you have devtools installed
devtools::install_github(repo = 'mutolisp/seqParser')
```

## Use

1. Set up original primers
```R
##### set up primers #####
fprimer <-  'AGATATTGGAAC[A|T]TTATATTTTATTT[A|T]TGG'
rprimer <-  'GGAGGATT[C|T]GG[A|T]AATTGATTAGT'
```
2. Adjust the length of each primer
```R
##### grep by forward and reverse primers #####
fp <- getCuttedPrimer(fprimer, len=17, direction = 'forward')
rp <- getCuttedPrimer(rprimer, len=11, direction = 'reverse')
```
3. Grep sequences by given primers and export
```R
ex.fasta <- outputSeq(fastaFile = 'example.fasta', 
                 outputFasta = 'example.fasta', 
                 fprimer = fp, 
                 rprimer = rp, 
                 duplinum = 5, 
                 fill = TRUE)
```
