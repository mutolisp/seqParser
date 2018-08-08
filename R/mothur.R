#' mothur nucleotide
#'
#'
#' @param binPath mothur binary directory
#' @param subfunc query sequences
#'
#' @examples
#' \dontrun{
#' mothurDir <- '~/Downloads/mothur/'
#' fastaFile <-  './1060501B_cut3_without_N.fas'
#'
#' phylipFile <-  paste(strsplit(fastaFile, '.fas')[1], '.phylip.dist', sep='')
#' listFile <- paste(strsplit(fastaFile, '.fas')[1], '.phylip.fn.list', sep='')
#'
#' mothur(mothurDir, subfunc='dist.seqs',
#'        fasta=fastaFile, calc='onegap', cutoff=0.03, countends=F, output='lt')
#' mothur(mothurDir, subfunc='cluster',
#'        phylip=phylipFile,
#'        method='furthest',cutoff=0.03)
#' mothur(mothurDir, subfunc='bin.seqs',
#'        list=listFile, fasta=fastaFile)
#' }


`mothur` <- function(binPath, subfunc, ...){
  sysinfo <- Sys.getenv('R_PLATFORM')
  binary <- paste(binPath, 'mothur', ' ', sep='')

  # check for arguments
  argsList <- list(...)
  argsName <- names(argsList)

  #
  #margs <- paste('-query', query)

  # optional arguments
  pasteAllArgs <- function(x){
    paste(x, '=', argsList[x], sep = '')
  }
  oargs <- paste(unlist(lapply(argsName,
                               FUN = pasteAllArgs)), collapse=',')
  subArgs <- paste(subfunc, "(", oargs, ')', sep='')
  writeLines(subArgs, 'execMothur')
  execBinary <- paste(binary, subArgs, sep=' ')
  print(execBinary)
  system(paste(binary, './execMothur', sep=''))
}

