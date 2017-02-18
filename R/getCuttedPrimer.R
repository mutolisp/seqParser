#' getCuttedPrimer 
#'
#' @description
#' Cut primers by specific length
#'
#' @param primer input primer
#' @param len cutted length of primer
#' @param direction forward/reverse
#'
#' @return cutted primer (string)
#' @examples
#' fprimer <-  'AGATATTGGAAC[A|T]TTATATTTTATTT[A|T]TGG'
#' getCuttedPrimer(fprimer, len=11, direction='forward')
#'
getCuttedPrimer <- function(primer, len=11, direction='forward') {
  primer <- unlist(strsplit(primer, "(?=\\[)", perl=TRUE))
  primer <- unlist(strsplit(primer, "(?=\\])", perl=TRUE))
  for (i in which(primer == "[" )) {
    primer[i+1] <- paste(primer[i], primer[i+1], "]", sep="")
  }
  primer <- primer[-which(primer=="["| primer=="]")]
  # split DNA sequences
  # 把沒有 regular expression 表示的 bp,
  # 即沒有 "[" "]" 和 "|" 的找出來
  grepRegexp = function(x){
    res <- grep("\\[|\\]|\\|", x, useBytes = TRUE)
    return(res)
  }
  primerCont = list()
  for ( i in 1:length(primer) ) {
    if ( length(grepRegexp(primer[i])) == 0 ) {
      primerCont[[i]] <- strsplit(primer[i], '', perl=TRUE)
    } else {
      primerCont[[i]] <- primer[i]
    }
  }
  primerCont <- unlist(primerCont)
  lengthOfPrimer = length(primerCont)
  if ( len > lengthOfPrimer ){
    len = lengthOfPrimer
  } else {
    len
  }
  if ( direction == 'reverse' ){
    cutStart <- 1
    lenPrimer <- len
  } else {
    cutStart <- length(primerCont) - len + 1
    lenPrimer <- length(primerCont)
  }

  primerC <- paste(primerCont[cutStart:lenPrimer],
                   sep = '', collapse = '')
  return(primerC)
}
