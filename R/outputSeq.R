#' Clean up sequence with primers
#'
#' @param fastaFile a fasta file path
#' @param outputFasta output fasta file path
#'
#' @param fprimer forward primer
#' @param rprimer reverse primer
#' @param duplinum only select the sequences which duplicate
#'        number is greater and equal than `duplinum`
#' @param srange minimum and maximum values of prunned sequence length, ex:
#'        c(20, 150) means the minimum number is 20 and maximum number is 150
#' @param sort sort output table by id (1), pruned sequence (2),
#'        duplicates (3) or pruned sequence length (4)
#'
#' @return data.table format sequence set

outputSeq <- function(fastaFile, outputFasta,
                      fprimer, rprimer, duplinum, srange, sort = 4){
  library(Biostrings)
  #####
  # output sequence
  # fprimer: forward primer
  # rprimer: reverse primer
  # duplinum: only select duplicate number greater
  #           and equal than n
  ####

  # variables
  sortMatrix <-  c('id', 'seqPruned', 'duplicates', 'seqPrunedLength')

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

  # select specific range of sequence length
  maxPrunedLength <- max(withPrimerNoDesc$seqPrunedLength)
  minPrunedLength <- min(withPrimerNoDesc$seqPrunedLength)

  reqMin <- as.integer(srange[1])
  reqMax <- as.integer(srange[2])
  if ( reqMin < minPrunedLength | reqMax > maxPrunedLength) {
    sprintf("Invalid range of prunned sequences")
    break()
  } else {
    givenPrimerNoDesc <- withPrimerNoDesc[withPrimerNoDesc[, seqPrunedLength >= reqMin & seqPrunedLength <= reqMax],]
    # excluded sequences
    excludedWithPrimerNoDesc <- withPrimerNoDesc[withPrimerNoDesc[, (seqPrunedLength < reqMin | seqPrunedLength > reqMax)],]
  }
  # sort sequences
  givenPrimerNoDesc <- setkeyv(givenPrimerNoDesc, sortMatrix[sort])
  excludedWithPrimerNoDesc <- setkeyv(excludedWithPrimerNoDesc, sortMatrix[sort])

  if ( file.exists(outputFasta) == TRUE ) {
    origFasta <- paste(outputFasta, 'bak', sep=".")
    file.rename(outputFasta, origFasta)
    origFasta_d <- paste('deleted_', outputFasta, '.bak', sep="")
    file.rename(paste('deleted_', outputFasta, sep=""), origFasta_d)
  }

  for ( i in 1:dim(givenPrimerNoDesc)[1] ){
    seqinr::write.fasta(Biostrings::DNAString(givenPrimerNoDesc[i, seqPruned]),
                names = givenPrimerNoDesc[i, id], file.out = outputFasta,
                open = 'a', nbchar = max(givenPrimerNoDesc[, seqPrunedLength]))
  }
  for ( i in 1:dim(excludedWithPrimerNoDesc)[1] ){
    seqinr::write.fasta(Biostrings::DNAString(excludedWithPrimerNoDesc[i, seqPruned]),
                        names = excludedWithPrimerNoDesc[i, id], file.out = paste('deleted', outputFasta, sep="_"),
                        open = 'a', nbchar = max(excludedWithPrimerNoDesc[, seqPrunedLength]))
  }

  target <- givenPrimerNoDesc[,.(id, seqPruned, duplicates, seqPrunedLength)]
  excluded <- excludedWithPrimerNoDesc[,.(id, seqPruned, duplicates, seqPrunedLength)]
  resList <- list(target, excluded)

  return(resList)
}
