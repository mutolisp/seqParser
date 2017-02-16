# data input
`read.myfasta` <- function(fastaFile){
  library(data.table)
  raw.fasta <- seqinr::read.fasta(fastaFile, forceDNAtolower = FALSE,
                                  as.string = TRUE, set.attributes = FALSE)
  raw.fasta.names <- names(raw.fasta)
  raw_seq <- as.data.table(raw.fasta)
  raw_seq <- t(raw_seq)
  raw_seq <- data.table::as.data.table(cbind(raw.fasta.names, raw_seq))
  colnames(raw_seq) <- c('desc', 'seq')
  # add sequence length
  raw_seq[, seqlength:= nchar(seq)]
  data.table::setkey(raw_seq, desc)
  #findex <- data.table::data.table(Biostrings::fasta.index(fastaFile))
  #data.table::setkey(findex, desc)
  #finalFasta <- base::merge(findex, raw_seq)
  #return(finalFasta)
  return(raw_seq)
}
