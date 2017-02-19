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



