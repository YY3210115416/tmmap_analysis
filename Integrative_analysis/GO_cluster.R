library(readr)
library(dplyr)
library(GOSemSim)
library(clusterProfiler)
library(ggplot2)
library(Rtsne)
library(ggrepel)
library(pheatmap)


file_list <- list.files(path = "GO_q", pattern = "*.csv", full.names = TRUE)
go_data <- lapply(file_list, read_csv)
names(go_data) <- gsub(".csv", "", basename(file_list))

#Use BP as an example, can change to "MF"/"CC"
#Filter
filter_data <- function(data) {
  data <- data %>%
    filter(ONTOLOGY == "BP") %>%
    filter(p.adjust < 0.01) %>%
    mutate(GeneRatio = as.numeric(sub("/.*", "", GeneRatio)) / as.numeric(sub(".*/", "", GeneRatio)),
           BgRatio = as.numeric(sub("/.*", "", BgRatio)) / as.numeric(sub(".*/", "", BgRatio))) %>%
    filter(GeneRatio / BgRatio >= 2)
  return(data)
}

go_data <- lapply(go_data, filter_data)
go_data <- go_data[sapply(go_data, nrow) >= 1]


extract_go_terms <- function(data) {
  return(data$ID)
}

go_terms_list <- lapply(go_data, extract_go_terms)
n <- length(go_terms_list)
sim_matrix <- matrix(0, nrow = n, ncol = n, dimnames = list(names(go_terms_list), names(go_terms_list)))


hsGO <- godata('org.Hs.eg.db', ont="BP")

for (i in 1:n) {
  for (j in i:n) {
    sim <- mgoSim(go_terms_list[[i]], go_terms_list[[j]], semData = hsGO, measure = "Wang", combine = "BMA")
    sim_matrix[i, j] <- sim
    sim_matrix[j, i] <- sim 
  }
}



png("heatmap_qtl_YES_BP.png", width = 15000, height = 13000, res = 1000)  

pheatmap(sim_matrix, 
         display_numbers = TRUE, 
         color = colorRampPalette(c("white", "red"))(50),
         angle_col = "45",
         border_color = NA,
         show_rownames = TRUE,  
         show_colnames = TRUE,  
         fontsize_row = 10,     
         fontsize_col = 10,    
         cellwidth = 15,        
         cellheight = 15,       
         width = 15,            
         height = 12            
)

dev.off()  

#Cluster
dist_matrix <- as.dist(1 - sim_matrix)
hc <- hclust(dist_matrix, method = "ward.D2")


plot(hc, main = "Hierarchical Clustering", xlab = "", sub = "", cex = 0.9, labels = labels)

cluster_assignments <- cutree(hc, k = 4) 
clustering_results <- data.frame(File = labels, Cluster = cluster_assignments)

write.csv(clustering_results, "hierarchical_clustering_results.csv", row.names = FALSE)





