#' blast nucleotide
#'
#'
#' @param type blast type, available programs are blastn, blastp, blastx,
#'             psiblast, tblastn, tblastx
#' @param query query sequences
#'
#'
#'
# references: https://www.ncbi.nlm.nih.gov/books/NBK279675/

`blast` <- function(type, query, ...){
  typeList <- c('blastn', 'blastp', 'blastx', 'psiblast', 'tblastn', 'tblastx')
  if ( type %in% typeList ){
    binary = Sys.which(type)
  } else {
    return(sprintf('%s does not exist. Available types are blastn, blastp and blastx', type))
  }

  if ( binary == "" ){
    return(sprintf('%s is not found. Please check it again.', type))
  }

  # check for arguments
  argsList <- list(...)
  argsName <- names(argsList)

  #
  margs <- paste('-query', query)

  # optional arguments
  pasteAllArgs <- function(x){
    paste('-', x, ' ', argsList[x], sep = '')
  }
  oargs <- paste(unlist(lapply(argsName,
                FUN = pasteAllArgs)), collapse=' ')
  execBlast <- paste(binary, margs, oargs, sep=' ')
  system(execBlast)
}
