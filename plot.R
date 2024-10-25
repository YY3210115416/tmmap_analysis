library(ggplot2)
library(data.table)
# Load data
data <- fread("/data/slurm/tmmap/genecount.txt", header = FALSE)
colnames(data) <- c("Egene", "QTLgene")

max_egene <- max(data$Egene, na.rm = TRUE)
max_qtlgene <- max(data$QTLgene, na.rm = TRUE)

max_egene_adjusted <- ceiling(max_egene / 5) * 5
max_qtlgene_adjusted <- ceiling(max_qtlgene / 2) * 2

# Replace NA values with 0 for Egene and QTLgene columns
data$Egene <- ifelse(is.na(data$Egene), 0, data$Egene)
data$QTLgene <- ifelse(is.na(data$QTLgene), 0, data$QTLgene)

# Plot g1: Histogram of Egene
g1 <- ggplot(data, aes(x = Egene)) +
  geom_histogram(binwidth=5, fill="lightblue", boundary = 0) +
  labs(x = "Egene Value", y = "Frequency", title = "Histogram of Egene") +
  xlim(c(0, max_egene_adjusted)) +
  scale_x_continuous(breaks = seq(0, max_egene_adjusted, by = 5)) +
  stat_bin(binwidth=5, geom="text", aes(label=after_stat(count)), vjust=-0.5, size=3)  # size=3 for text size adjustment

# Save g1 as PNG and SVG
ggsave(filename = "/data/slurm/tmmap/Egene_histogram.png", plot = g1, device = "png", width = 10, height = 5)
ggsave(filename = "/data/slurm/tmmap/Egene_histogram.svg", plot = g1, device = "svg", width = 10, height = 5)

# Plot g2: Histogram of QTLgene
g2 <- ggplot(data, aes(x = QTLgene)) +
  geom_histogram(binwidth=2, fill="lightblue", boundary = 0) +
  labs(x = "QTLgene Value", y = "Frequency", title = "Histogram of QTLgene") +
  xlim(c(0, max_qtlgene_adjusted)) +
  scale_x_continuous(breaks = seq(0, max_qtlgene_adjusted, by = 2)) +
  stat_bin(binwidth=2, geom="text", aes(label=after_stat(count)), vjust=-0.5, size=3)  # size=3 for text size adjustment

# Save g2 as PNG and SVG
ggsave(filename = "/data/slurm/tmmap/QTLgene_histogram.png", plot = g2, device = "png", width = 10, height = 5)
ggsave(filename = "/data/slurm/tmmap/QTLgene_histogram.svg", plot = g2, device = "svg", width = 10, height = 5)



data1 <- fread("/data/slurm/tmmap/allloop.txt", header = FALSE)
# Plot g1: Make it narrower and add numbers on top of bars
g1 <- ggplot(data1, aes(x = as.factor(V16))) +
  geom_bar(fill = "skyblue") +
  geom_text(stat='count', aes(label=..count..), vjust=-0.5) +  # Add numbers on bars
  facet_wrap(~ V14) + 
  labs(x = "", y = "Frequency", title = "")

# Save g1 as PNG and SVG
ggsave(filename = "/data/slurm/tmmap/rsep.png", plot = g1, device = "png", width = 5, height = 10)
ggsave(filename = "/data/slurm/tmmap/rsep.svg", plot = g1, device = "svg", width = 5, height = 10)

# Plot g2: Add numbers on top of bars
g2 <- ggplot(data1, aes(x = as.factor(V19))) +
  geom_bar(fill = "lightblue") +
  facet_wrap(~ V14) +
  labs(x = "", y = "Frequency", title = "")

# Save g2 as PNG and SVG
ggsave(filename = "/data/slurm/tmmap/score.png", plot = g2, device = "png")
ggsave(filename = "/data/slurm/tmmap/score.svg", plot = g2, device = "svg")