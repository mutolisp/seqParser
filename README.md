# seqParser
DNA sequence parser

[![Build Status](https://travis-ci.org/mutolisp/seqParser.svg?branch=master)](https://travis-ci.org/mutolisp/seqParser)

[![DOI](https://zenodo.org/badge/82152043.svg)](https://zenodo.org/badge/latestdoi/82152043)

## What does seqParser do

* clip by primers

![seqParser](https://github.com/mutolisp/seqParser/raw/master/docs/seqParser1.png)

related function: ```getCuttedPrimer(primer, len, direction='forward'), grepSeqByPrimer(seq, fprimer, rprimer)```

* sort by groups

![seqParser](https://github.com/mutolisp/seqParser/raw/master/docs/seqParser2.png)

* [BLAST+](http://blast.ncbi.nlm.nih.gov) wrapper for R

## Installation

```R
# assume you have devtools installed
devtools::install_github(repo = 'mutolisp/seqParser')
```

Dependencies: [dplyr](https://cran.r-project.org/package=dplyr), [Biostrings](https://bioconductor.org/packages/release/bioc/html/Biostrings.html),
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

Blast+ (you need to install NCBI blast first)
```R
# make blast database
makeblastdb(input = 'example.fasta',
            dbtype='nucl', title='example', out='/tmp/out/ab')

# blast: blast(type='blastn', ...) or blast(type='blastx', ...)
blast(type='blastn', query='query.fasta',
      db = '/path/to/the/sdb', out = '/tmp/output.txt',
      task='megablast', evalue=1, max_target_seqs=20, num_threads=8,

```

## Citation

Cheng-Tao Lin (2018) seqParser: R package for DNA sequence parsing. URL: https://github.com/mutolisp/seqParser DOI: 10.5281/zenodo.1493692

