### Format summary statistics from GWAS to match PRScs requirements
### R Arathimos
### 19/04/21

# PRScs needs: SNP A1 A2 BETA P

print("Warning: this script must be run in a session with at least 8GB of RAM available")

require(data.table)
library(data.table)

# read in args

args <- commandArgs(trailingOnly = TRUE)

sst_file <- as.character(args[1])

outstring <- as.character(args[2])

data_dir <- as.character(args[3]) 

print(sst_file)
print(outstring)
print(data_dir)

# Examples
# sst_file <- "~/brc_scratch/data/50_raw.gwas.imputed_v3.both_sexes.tsv"
# outstring <- "_formatted"
# data_dir <- "~/brc_scratch/data"
# sst file is the full pth and name of file with summary statistics saved
# outstring in the file suffix for outputfile
# data_dir is the output directory

# read in hapmap snps to subset

# download.file("https://data.broadinstitute.org/alkesgroup/LDSCORE/w_hm3.snplist.bz2", paste0(data_dir, "/w_hm3.snplist.bz2"))

hapmap <- fread(paste0(data_dir, "/all_w_hm3.snplist.txt"))

print("Loaded HapMap SNPs for subsetting")

names(hapmap) <- c("chr","rsid","zero","pos","a1","a2")

hapmap$chrpos <- paste0(hapmap$chr, hapmap$pos)

# read sst

print("Reading sumstats file")

sst <- fread(sst_file)

print(head(sst))

sst2 <- sst[,c("variant","minor_allele","minor_AF","beta","pval")]

print("Attempting to split variant identifier in to CHROM - POSITION - MINOR ALLELE - MAJOR ALLELE")

splitvariant <- strsplit(sst2$variant, ":")

sst2$chrom <-  sapply(splitvariant, '[[', 1)

sst2$pos <-  sapply(splitvariant, '[[', 2)

sst2$major <-  sapply(splitvariant, '[[', 3)

sst2$minor <-  sapply(splitvariant, '[[', 4)

sst2$chrpos <- paste0(sst2$chr,sst2$pos)

sst3 <- merge(sst2, hapmap[,c("chrpos","rsid","a1","a2")], by="chrpos")

print(paste0("There are ", NROW(sst3), " variants in Hapmap3 merge"))

print("Merged Hapmap!")

# remove indels

before <- NROW(sst3)

sst3 <- sst3[which(sst3$major=="C" | sst3$major=="T" | sst3$major=="G" | sst3$major=="A"), ]

sst3 <- sst3[which(sst3$minor=="C" | sst3$minor=="T" | sst3$minor=="G" | sst3$minor=="A"), ]

print(paste0("Removed ", before - NROW(sst3), " variants that were indels"))

# drop MAF < 0.01

print(paste0("Removing ", NROW(sst3[which(sst3$minor_AF<0.01), ]), " variants with MAF<0.01"))

sst3 <- sst3[which(sst3$minor_AF>0.01), ]

# remove duplicated rsids

dups <- sst3[(duplicated(sst3$rsid, fromLast = FALSE) | duplicated(sst3$rsid, fromLast = TRUE)), ]

'%!in%' <- function(x,y)!('%in%'(x,y))

sst3 <- sst3[sst3$rsid %!in% dups$rsid,]

print(paste0("Removing ", NROW(dups), " variants duplicated across rows"))

print(head(sst3))

# check for out of bounds p-values - set to ceiling

sst3$pval[sst3$pval<1e-300] <- 1e-300

# check that there are no variants where either the major or minor allele dont agree with hapmap allele

errors <- sst3[which(sst3$major!=sst3$a1 & sst3$major!=sst3$a2),]

errors2 <- sst3[which(sst3$minor!=sst3$a1 & sst3$minor!=sst3$a2),]

# exclude 

sst3 <- sst3[sst3$rsid %!in% errors$rsid,]

sst3 <- sst3[sst3$rsid %!in% errors2$rsid,]

# rename and subset

sst3 <- sst3[,c("rsid","major","minor","minor_allele","beta","pval")]

# reconsitute the A2 reference allele from the variant identifier and the supplied effect allele by flipping

sst3$A1 <- sst3$minor_allele

sst3$A2 <- sst3$major

sst3$A2[sst3$A2==sst3$A1] <- sst3$minor[sst3$A2==sst3$A1]

sst3 <- sst3[,c("rsid","A1","A2","beta","pval")]

names(sst3) <- c("SNP","A1","A2","BETA","P")

# write to file

fwrite(sst3, file = paste0(sapply(strsplit(sst_file,"[.]tsv"),'[[',1),outstring ,".tsv" ) , sep="\t")

print("Written to formatted file")

print(head(sst3))

#
