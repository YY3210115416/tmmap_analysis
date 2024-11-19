enrichment_high <- read.csv('enrichment_high_edit.csv')
diseases <- unique(enrichment_high$Disease)
total_SNP_num <- sum(enrichment_high$SNP_num)
#total_loop_num <- sum(enrichment_high$Loop_num)

pvalues1 <- c()
#pvalues2 <- c()
or1 <- c()
#or2 <- c()
orp1 <- c()
#orp2 <- c()

for (i in 1:nrow(enrichment_high)){
  m <- enrichment_high$SNP_num[i]
  M <- enrichment_high$Disease_snp_num[i]
  n <- enrichment_high$TT_snp_num[i]
  N <- total_SNP_num
  
  p <- phyper(m, M, N-M, n, lower.tail=F)
  pvalues1 <- c(pvalues1, p.adjust(p,method='fdr'))
  or1 <- c(or1, (m/M)/(n/N))
  fishmatrix <- matrix(c(m,n,M,N),ncol = 2)
  orp1 <- c(orp1, as.numeric(fisher.test(fishmatrix)[1]))
  
}