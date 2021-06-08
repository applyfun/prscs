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

**3) Target genotypes files**

Genotype files in plink bed-bim-fam format for the target sample in which PRS for the trait of interest will be calculated.

## Running PRScs

The below process assumes PRScs has been installed using the above installation script and that the required files have been downloaded.

* **Step 1**

#### Format GWAS summary statistics

If summary statistics from UK Biobank have been downloaded using the above reference list, then run the format_gwas.r script below

```
module load apps/R/3.6.0

Rscript format_gwas.r /path/to/gwas/file/raw_gwas_summary_statistics.tsv formatted_outfile /path/to/output/directory/
```

If summary statistics have been downloaded from a consortium website, the GWAS catalog or are from any other source, they will need to formatted accordingly, to contain 5 columns of data: SNP A1 A2 BETA P

* **Step 2**



