### Join PRScs output from across chrom files

echo "This script should be run in an interactive session using 30GB memory min"

datapath=$1
dataname=$2
outputpath=$3
targetname=$4

cd outputpath

echo "Combine PRScs results across chromosomes"

cat ${outputpath}${dataname}*.txt > ${outputpath}${dataname}_all.txt

# rm ${outputpath}*.txt

module load apps/plink/1.9.0b6.10

# ensure no duplicate variant IDs in bim

cut -f 2 ${datapath}${targetname}.bim | sort | uniq -d > ${datapath}/bim_tmp.dups

plink --bfile ${datapath}/${targetname} \
	--exclude ${datapath}bim_tmp.dups \
	--score ${outputpath}${dataname}_all.txt 2 4 6 sum \
	--out ${outputpath}all_prscs_score

echo "Score calculated!"
