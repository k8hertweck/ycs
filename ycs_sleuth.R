# RNAseq analysis with sleuth
# data in folder called "Trinity" in working directory
# metadata in working directory

## To run model building on Stampede:
# module load Rstats

#source("http://bioconductor.org/biocLite.R")
#biocLite("rhdf5")
#install.packages("devtools", "~/Rlibs")
#devtools::install_github("pachterlab/sleuth")
library(sleuth)

# identify directory of kallisto results
base_dir <- "."
# list of sample IDs
sample_id <- dir(file.path(base_dir,"Trinity"))
# list of paths to kallisto results
ycs_dirs <- sapply(sample_id, function(id) file.path(base_dir, "Trinity", id))
ycs_dirs
# table with experimental design
meta <- read.table("ycs_info.txt", header = TRUE, stringsAsFactors=FALSE)
# enter directories into column 
meta <- dplyr::mutate(meta, path = ycs_dirs)

## model treatment + sample
so <- sleuth_prep(meta, ~ condition + stool + FV )
so <- sleuth_fit(so2)
so <- sleuth_wt(so, 'conditionY')
so <- sleuth_wt(so, 'stool')
so <- sleuth_wt(so, 'FV' )
models(so)
so_results <- sleuth_results(so, 'conditionY')
saveRDS(so, "so_object.rds")
so <- readRDS("so_object.rds")
sleuth_live(so)
