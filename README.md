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

Dependencies: [dplyr](https://cran.r-project.org/package=dplyr), 
[data.table](https://cran.r-project.org/package=data.table), 
[stringr](https://cran.r-project.org/package=stringr), 
[seqinr](https://cran.r-project.org/package=seqinr)

## Use

Set up original primers
```R
library(seqParser)
##### set up primers #####
fprimer <-  'AGATATTGGAAC[A|T]TTATATTTTATTT[A|T]TGG'
rprimer <-  'GGAGGATT[C|T]GG[A|T]AATTGATTAGT'
```

Adjust the length of each primer
```R
##### grep by forward and reverse primers #####
fp <- getCuttedPrimer(fprimer, len=17, direction = 'forward')
rp <- getCuttedPrimer(rprimer, len=11, direction = 'reverse')
```

Grep sequences by given primers and export
```R
ex.fasta <- outputSeq(fastaFile = 'example.fasta', 
                 outputFasta = 'example.fasta', 
                 fprimer = fp, 
                 rprimer = rp, 
                 duplinum = 5, 
                 fill = TRUE)
```
