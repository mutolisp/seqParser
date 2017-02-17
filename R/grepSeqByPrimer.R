#' Grep core sequences by specific primer
#'
#' @description
#'
#' @param seq a sequence
#' @param fprimer forward primer
#' @param rprimer reverse primer
#'
#' @return a sequence with primers 
grepSeqByPrimer <- function(seq, fprimer, rprimer) {
  # if the fprimer is
  fprimer <- str_match(seq, fprimer)[1]
  rprimer <- str_match(seq, rprimer)[1]
  if ( is.na(fprimer) == TRUE | is.na(rprimer) == TRUE ){
    return("")
  }

  fSide <- unlist(strsplit(seq, fprimer))
  if ( length(fSide) > 2 ){
    # s --> splitPartNumber
    ## [sequence part][fprimer][sequence part][rprimer][sequence part]
    s <- length(fSide)
  } else {
    s <- 2
  }
  coreSeq <- unlist(strsplit(fSide[s], rprimer))[1]

  # check for length of coreSeq
  if ( is.na(coreSeq) == TRUE | nchar(coreSeq) == 0 ){
    return("")
  } else {
    # paste together with primers
    seqWithPrimers <- paste(fprimer, coreSeq, rprimer, sep="")
    return(seqWithPrimers)
  }

}
