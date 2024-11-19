library(tidyverse)
library(GOSemSim)
library(clusterProfiler)
library(ggplot2)
library(org.Hs.eg.db)

# folder_A -> GO of promoter target gene  folder_B -> GO of eQTL gene
folder_A <- "GO"
folder_B <- "GO_q"
files_A <- list.files(folder_A, full.names = TRUE)
files_B <- list.files(folder_B, full.names = TRUE)
sample_names_A <- basename(files_A) %>% tools::file_path_sans_ext()
sample_names_B <- basename(files_B) %>% tools::file_path_sans_ext()

common_samples <- intersect(sample_names_A, sample_names_B)

#Filter
files_A_common <- files_A[basename(files_A) %>% tools::file_path_sans_ext() %in% common_samples]
files_B_common <- files_B[basename(files_B) %>% tools::file_path_sans_ext() %in% common_samples]

#Use BP as an example, can change to "MF"/"CC"
read_go_data <- function(file) {
  read.csv(file, header = TRUE) %>%
    filter(ONTOLOGY == "BP") %>%
    dplyr::select(ID, Description, p.adjust)
}


data_A <- map(files_A_common, read_go_data)
data_B <- map(files_B_common, read_go_data)

hsGO <- godata('org.Hs.eg.db', ont="BP")
calculate_similarity <- function(df1, df2) {
  go_ids1 <- df1$ID
  go_ids2 <- df2$ID
  mgoSim(go_ids1, go_ids2, semData = hsGO, measure = "Wang", combine = "BMA")
}



similarity_scores <- map2_dbl(data_A, data_B, function(df1, df2) {
  similarity <- calculate_similarity(df1, df2)
  similarity
})


similarity_df <- data.frame(
  Sample = seq_along(common_samples),
  Similarity = similarity_scores,
  SampleName = common_samples
)

write.csv(similarity_df, "similarity_scores.csv", row.names = FALSE)

# Plot
ggplot(similarity_df, aes(x = Sample, y = Similarity)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  labs(title = "GO Enrichment Similarity (BP)",
       x = "Sample",
       y = "Similarity (Wang Similarity)") +
  scale_x_continuous(breaks = similarity_df$Sample, labels = similarity_df$Sample)

similarity_df <- data.frame(
  Sample = seq_along(common_samples),
  Similarity = similarity_scores
)

plot <- similarity_df %>%
  ggplot(aes(x = SampleName, y = Similarity)) +
  geom_bar(stat = "identity", fill = "#ADD8E6") + 
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title = "GO Enrichment Similarity (BP)",
       x = "Sample",
       y = "Similarity (Wang Similarity)")

ggsave("similarity_plot.svg", plot = plot, device = "svg", width = 10, height = 6)



