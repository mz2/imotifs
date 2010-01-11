\name{parse_xms}
\alias{parse_xms}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
parse_xms(filename, index_by_name = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{filename}{ ~~Describe \code{filename} here~~ }
  \item{index_by_name}{ ~~Describe \code{index_by_name} here~~ }
}
\details{
  ~~ If necessary, more details than the description above ~~
}
\value{
  ~Describe the value returned
  If it is a LIST, use
  \item{comp1 }{Description of 'comp1'}
  \item{comp2 }{Description of 'comp2'}
  ...
}
\references{ ~put references to the literature/web site here ~ }
\author{ ~~who you are~~ }
\note{ ~~further notes~~ 

 ~Make other sections like Warning with \section{Warning }{....} ~
}
\seealso{ ~~objects to See Also as \code{\link{help}}, ~~~ }
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function(filename,index_by_name=TRUE) {
	xms.tree = xmlTreeParse(filename)
	motifs = list()
	
	motifset_node = xms.tree$doc$children$motifset
	motifIndex = 1
	
	for (i in 1:length(motifset_node)) {
		msetchild = motifset_node[i]
		if (names(msetchild) == "motif") {
			motif = list()
			motifName = xmlValue(msetchild$motif[1]$name)
			motif$name = motifName
			#print(motif$name)
			wm = xmlChildren(msetchild$motif)$weightmatrix
			wmattrs = as.list(xmlAttrs(wm))
			alphabet = wmattrs$alphabet
			motif$alphabet = alphabet
			colcount = as.numeric(wmattrs$columns)
			motif$columns = colcount
			wmchildren = xmlChildren(wm)
			
			#if (alphabet == "DNA") {
			alphas = c("adenine","cytosine","guanine","thymine")
			#} #TODO: Support protein/RNA here
			#print(length(alphas))
			#print(motif$columns)
			wmweights=matrix(NA,nrow=length(alphas),ncol=motif$columns)
			motif$weightmatrix = wmweights
			
			if (length(wmchildren) != motif$columns) {
				warning(
					paste(
						"Column count discrepency:",
						length(colchildren),colcount)
					)
			}
			for (j in 1:length(wmchildren)) {
				wmchild = wmchildren[j]
				if (names(wmchild) == "column") {
					colchildren = xmlChildren(wmchild$column)
					
					for (k in 1:length(colchildren)) {
						col = colchildren[k]
						colattrs = as.list(xmlAttrs(col$weight))
						sym = colattrs$symbol
										
						weightnode = col[1]$weight
						w = as.numeric(xmlValue(weightnode))
						wmweights[which(alphas == sym),j] = w
						motif$weightmatrix = wmweights
						
						rownames(motif$weightmatrix) = alphas
						colnames(motif$weightmatrix) = 1:ncol(motif$weightmatrix)
					}
				} else {
					warning(paste("Unexpected node type:",names(mchild)))
				}
			}
			
			if (index_by_name) {
				if (length(motifs[[motif$name]]) > 0) {
					warning(paste("Motif with name",motif$name,"already exists"))
				}
				motifs[[motif$name]] = motif
			} else {
				motifs[[motifIndex]] = motif
			}
		} else if (names(msetchild) == "prop") {
			#TODO: Parse metadata out
		}
	}
	return(motifs)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
