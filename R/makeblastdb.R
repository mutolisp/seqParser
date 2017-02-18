#' make blastdb
#'
#' @param input input file
#' @param input_type Type of the data specified in input_file. Available types are
#'                   `asn1_bin', `asn1_txt', `blastdb', `fasta'. Default is 'fasta'
#' @param dbtype database type, "nucl": nucleotide
#' @param parse_seqids  Option to parse seqid for FASTA input if set,
#'                      for all other input types seqids are parsed automatically,
#'                      default is TRUE
#' @param hash_index Create index of sequence hash values, default is FALSE
#' @param ... makeblastdb arguments, available arguments are:
#'            'gi_mask','gi_mask_name','h','help',
#'            'input_type','logfile','mask_data','mask_desc',
#'            'mask_id','max_file_sz','out','taxid','taxid_map',
#'            'title','version'
#'
#' @return None
`makeblastdb` <- function(input, dbtype, parse_seqids=TRUE, hash_index=FALSE, ...){
  # command from tutorial
  # makeblastdb -in $input.fasta -parse_seqids -title $dbtitle -dbtype nucl
  binary = Sys.which('makeblastdb')
  if ( binary == "" ){
    return('`makeblastdb` is not found. Please check it again.')
  }

  # check for arguments
  argsList <- list(...)
  argsName <- names(argsList)
  # makeblastdb argument list
  makeblastdbArgs <- c('gi_mask','gi_mask_name','h','help',
                       'input_type','logfile','mask_data','mask_desc',
                       'mask_id','max_file_sz','out','taxid','taxid_map',
                       'title','version')
  argsNotExist <- which(argsName %in% makeblastdbArgs==FALSE)
  if ( length(argsNotExist) > 0){
    argsNotExistName <- argsName[argsNotExist]
    sprintf('Arguments %s does not exist!', argsNotExistName)
    return('Exit: arguments error!')
  }
  pasteAllArgs <- function(x){
    paste('-', x, ' ', argsList[x], sep = '')
  }
  oargs <- paste(unlist(lapply(argsName,
                  FUN = pasteAllArgs)), collapse=' ')

  margs = paste('-in', input, '-dbtype', dbtype, sep = ' ')
  # combine mandatory arguments
  if ( parse_seqids == TRUE ) {
    margs <- paste(margs, '-parse_seqids', sep = ' ')
  }
  if ( hash_index == TRUE ){
    margs <- paste(margs, '-hash_index', sep = ' ')
  }

  execMakeblastdb <- paste(binary, margs, oargs, sep=' ')
  system(execMakeblastdb)
}

