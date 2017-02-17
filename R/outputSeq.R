#' Clean up sequence with primers
#'
#' @param fastaFile a fasta file path, ex: /path/to/example.fasta
#' @param outputFasta output fasta file path, ex: /path/to/export.fasta
#' @param fprimer forward primer
#' @param rprimer reverse primer
#' @param duplinum only select the sequences which duplicate 
#'        number is greater and equal than `duplinum`
#' @param fill fill the gap bp with N
#'
#' @return data.table format sequence set

outputSeq <- function(fastaFile, outputFasta,
                      fprimer, rprimer, duplinum, fill = TRUE){
  #####
  # output sequence
  # fprimer: forward primer
  # rprimer: reverse primer
  # duplinum: only select duplicate number greater
  #           and equal than n
  ####
  print("Processing, please wait for a while ...")
  myFasta <- read.myfasta(fastaFile)
  withPrimer <- myFasta[grep(fprimer, seq)][grep(rprimer, seq)]

  # prune sequence by primers (forward and backward primer included)
  withPrimer[, seqPruned := grepSeqByPrimer(seq, fprimer, rprimer), by=desc]
  withPrimer[, seqPrunedLength := nchar(seqPruned)]
  withPrimer <- withPrimer[, .(desc, seq, seqPruned,seqPrunedLength)]
  withPrimer <- withPrimer[order(-rank(seqPrunedLength), seqPruned, desc)]
  # find duplicates
  data.table::setkeyv(withPrimer, c('seqPruned'))
  withPrimer[, duplicates := .N, by=list(seqPruned)]
  withPrimerNoDesc <- withPrimer[, .(seqPruned, duplicates, seqPrunedLength)][seqPrunedLength>0]
  withPrimerNoDesc <- unique(withPrimerNoDesc)
  withPrimerNoDesc <- withPrimerNoDesc[order(-rank(duplicates), -rank(seqPrunedLength), seqPruned)]
  withPrimerNoDesc <- withPrimerNoDesc[duplicates >= duplinum]
  # append duplicate numbers
  withPrimerNoDesc[, id:= paste(.I, duplicates, sep = "_")]

  if ( file.exists(outputFasta) == TRUE ) {
    origFasta <- paste(outputFasta, 'bak', sep=".")
    file.rename(outputFasta, origFasta)
  }
  if ( fill == TRUE ){
    maxLength <- max(withPrimerNoDesc[, seqPrunedLength])
    withPrimerNoDesc[, fn := paste(rep("N", maxLength-seqPrunedLength),
                                   sep="", collapse=""), by=id]
    withPrimerNoDesc[, seqPruned := paste(seqPruned, fn, sep="", collapse=""), by=id]
  }
  for ( i in 1:dim(withPrimerNoDesc)[1] ){
    seqinr::write.fasta(DNAString(withPrimerNoDesc[i, seqPruned]),
                names = withPrimerNoDesc[i, id], file.out = outputFasta,
                open = 'a', nbchar = max(withPrimerNoDesc[, seqPrunedLength]))
  }
  return(withPrimerNoDesc[,.(id, seqPruned, duplicates, seqPrunedLength)])
}
