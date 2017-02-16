.onLoad <- function(libname, pkgname){
  dependencies <- c('dplyr', 'data.table', 'stringr', 'seqinr')
  installedList <- dependencies %in% installed.packages()
  if ( FALSE %in% installedList ) {
    install.packages(dependencies[which(installedList == FALSE)])
  }
  invisible()

}
