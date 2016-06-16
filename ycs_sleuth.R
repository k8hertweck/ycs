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
meta <- read.table("ycsFV6H_info.txt", header = TRUE, stringsAsFactors=FALSE)
# enter directories into column 
meta <- dplyr::mutate(meta, path = ycs_dirs)

## model only treatment
# construct sleuth object
so <- sleuth_prep(meta, ~ condition)
so <- sleuth_fit(so)
so <- sleuth_wt(so, 'conditionY')
models(so)
so_results <- sleuth_results(so, 'condition')
write.table(so_results, "so_results.csv")
saveRDS(so, "so_object.rds")
so <- readRDS("so_object.rds")
sleuth_live(so)
## model treatment + sample
so2 <- sleuth_prep(meta, ~ condition + stool)
so2 <- sleuth_fit(so2)
so2 <- sleuth_wt(so2, 'conditionY')
so2 <- sleuth_wt(so2, 'stool')
models(so2)
so2_results <- sleuth_results(so2, 'conditionY')
saveRDS(so2, "so2_object.rds")
so2 <- readRDS("so2_object.rds")
sleuth_live(so2)
