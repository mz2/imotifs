`parse_xms` <-
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

