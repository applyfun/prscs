# Run PRScs

## Getting started

### Installation

Install PRScs by following the commands interactively in the install script: 

```
install_prscs.script
```

Installation involves downloading PRScs from the web and setting up a conda environment with the required packages that will be activated when running PRScs.

### Input files required

PRScs requires three different input files

**1) GWAS summary statistics file for the trait of interest**

Summary statistics from a GWAS of trait for which PRS will be calculated.

A list of GWAS summary statistics from traits in UK Biobank are available here:
https://docs.google.com/spreadsheets/d/1kvPoupSzsSFBNSztMzl04xMoSC3Kcx3CrjVf4yBmESU/edit?ts=5b5f17db#gid=178908679

**2) LD matrix file**

LD matrix to be used as a reference, calculated in a sample such as UK Biobank. 

UK Biobank or 1000 Genomes LD reference panels can be downloaded from the PRScs github page https://github.com/getian107/PRScs

For the UK Biobank European subset LD reference panel:

```
# download

wget https://www.dropbox.com/s/t9opx2ty6ucrpib/ldblk_ukbb_eur.tar.gz

# unpack files

tar -zxvf ldblk_ukbb_eur.tar.gz
```

**3) Target sample genotype files**

Imputed genotype files in plink bed-bim-fam format for the target sample in which PRS for the trait of interest will be calculated.

Ensure that basic QC has been applied to genotypes already, i.e.

* Subset to individuals of EUR ancestry
* Subset to SNPs with INFO>0.9 and MAF>1%
* Remove SNPs with duplicates rs numbers
* Remove indels

## Running PRScs

The below process assumes PRScs has been installed using the above installation script and that the required files have been downloaded.

* **Step 1 -  Format GWAS summary statistics**

If summary statistics from UK Biobank have been downloaded using the above reference list, then run the format_gwas.r script on an interactive node as below

```
module load apps/R/3.6.0

Rscript format_gwas.r /path/to/gwas/raw_gwas_summary_stats.tsv formatted_outfile /path/to/output/

```

The R script requires three arguments; first the path to the GWAS summary statistics with file name, second the suffix of the output file to be saved after formatting, third the path to the output directory where the output will be written.

If summary statistics have been downloaded from a consortium website, the GWAS catalog or are from any other source, they will need to formatted accordingly, to contain 5 columns of data: SNP A1 A2 BETA P

* **Step 2 - Run PRScs**

Run PRScs by submitting it as a job array to the cluster (one job will be created per chromosome)

```
sbatch submit_prscs_array.sh "PGC3_SCZ_wave3_public.v2" 
```

The job script requires five arguments, in order:
* the path to the GWAS summary statistics, 
* the name of GWAS summary statistics file in the directory, 
* the path to the directory containing the PRScs software previously downloaded, 
* the full path to the LD reference file
* the full path to the target sample .bim file

* **Step 2 - Create PRS**

Using the output of PRScs that contains posterior SNP effect size estimates (a type of SNP weight) create a score using plink

```
bash make_prscs_score.bash
```







