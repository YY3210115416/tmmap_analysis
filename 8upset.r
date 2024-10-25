# Install necessary package if not already installed
# install.packages("UpSetR")

# Load the UpSetR package
#library(ComplexUpset)
#library(ggplot2)
library(UpSetR)
library(svglite)


file_path <- "count_results.txt"
# Read the data and skip the first line (header)
data_lines <- readLines(file_path)[-1]

# Create an empty list to store the row indices for each category
categories <- list()
# Parse each line, extract the category name and row indices
for (line in data_lines) {
  parts <- strsplit(line, "\t")[[1]]
  category <- parts[1]  # Extract category name
  indices <- strsplit(parts[3], ";")[[1]]  # Extract row indices
  indices <- as.numeric(indices[indices != ""])  # Convert to numeric and remove empty values
  if (category != "celltype_enhancer") {  # Exclude the "celltype_enhancer" category
    categories[[category]] <- indices
  }
}

# Step 2: Create a binary matrix (rows are indices, columns are categories)
# Get all unique row indices
all_indices <- sort(unique(unlist(categories)))

# Initialize a matrix, rows are all row indices, columns are categories, default values are 0
category_matrix <- matrix(0, nrow=length(all_indices), ncol=length(categories))
rownames(category_matrix) <- all_indices
colnames(category_matrix) <- names(categories)

# Populate the matrix with 1s where a row index belongs to a category
for (category in names(categories)) {
  category_matrix[as.character(categories[[category]]), category] <- 1}

# Convert the matrix to a data frame for use with UpSetR
category_df <- as.data.frame(category_matrix)


width_px <- 12 * 1000  # 12 inches at 1000 DPI
height_px <- 8 * 1000  # 8 inches at 1000 DPI

#png("upset_plot.png", width = width_px, height = height_px, res = 1000)  # Set high resolution and matching size
#upset(category_df,
#      sets = names(categories),       # Specify the categories to plot, excluding "celltype_enhancer"
 #     keep.order = TRUE,              # Keep the order of the categories as is
  #    main.bar.color = "lightcoral",  # Top bar color
   #   sets.bar.color = "lightblue",   # Left bar (set bar) color
    #  point.size = 3,                 # Point size
#      line.size = 1,                  # Line size between points
 #     matrix.color = "grey32",        # Color of the points in the matrix
  #    order.by = "freq",              # Order by frequency (number of rows in each combination)
   #   set_size.show = TRUE,           # Show set size numbers
    #  set_size.numbers_size = 4)      # Adjust the size of set size numbers as needed
#dev.off()  # Close the PNG device

svglite("upset_plot.svg", width = 12, height = 8)  # Set size in inches
upset(category_df, 
      sets = names(categories),       # Specify the categories to plot, excluding "celltype_enhancer"
      keep.order = TRUE,              # Keep the order of the categories as is
      main.bar.color = "lightcoral",  # Top bar color
      sets.bar.color = "lightblue",   # Left bar (set bar) color
      point.size = 3,                 # Point size
      line.size = 1,                  # Line size between points
      matrix.color = "grey32",        # Color of the points in the matrix
      order.by = "freq",              # Order by frequency (number of rows in each combination)
      text.scale = c(3, 2, 2, 2, 2, 1.5))  # Increase font sizes for various text elements
      
#upset <- upset(
#  category_df,                    
#  intersect = names(categories),  
#  base_annotations = list(
#    'Intersection size' = (
#      ggplot2::geom_bar(
#        aes(fill = "lightcoral"),  
#        position = 'stack'
#      )
#    )
#  ),
#  sets = names(categories),        
#  queries = list(
#    upset_query(set = names(categories), color = 'lightblue') 
#  ),
#  matrix = (
#    geom_point(shape = 16, size = 1, color = 'grey32') +        
#    geom_segment(size = 0.5)                                    
#  ),
#  sort_intersections_by = 'freq',   
#  themes = upset_modify_themes(
#    list(
#      intersection_size = theme(text = element_text(size = 12, family = "Arial")),
#      intersection_matrix = element_text(size = 15)
#    )
#  )
#)
            
dev.off()  # Close the SVG device