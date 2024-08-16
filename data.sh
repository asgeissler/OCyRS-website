# copy data from pipeline over
p=~/remote-server/projects/rth/co2capture/subprojects/OCyRS/OCyRS-pipeline/data

mkdir data
# pathways and taxonomy associations
cp $p/K_* data/
# scores
cp $p/J_novel/potentially-novel-motifs.tsv data/potentially-novel-motifs.tsv
cp $p/K2_motifs.tsv data/K2_motifs.tsv
cp $p/I_fdr.tsv data/I_fdr.tsv
# info on redundancy (elements to ignore on the overview)
cp $p/L_redundant.tsv data/L_redundant.tsv

# due to redundancy removal, remove superseeded info
rm data/K_overview.tsv

# CMsearch results
cp $p/G_rfam-cmsearch.tsv.gz data/
cp $p/J_novel/references_inside-of_intergenic_regions.tsv.gz data/
cp $p/A_representatives/taxonomy.tsv data/
# for now, ignore: G2_terminators.tsv.gz

# Results from the expression analysis

cp ~/remote-server/projects/rth/co2capture/subprojects/OCyRS/OCyRS-companion/Public-RNAseq/5-expression-ratios.tsv data/
cp ~/remote-server/projects/rth/co2capture/subprojects/OCyRS/OCyRS-companion/Public-RNAseq/5-maybe-interest.tsv data/

# iterate over motifs
tail -n +2 data/K_motif-tax.tsv | cut -f 1 | sort | uniq > data/motifs.txt
# to load R2R figures
mkdir data/R2R

while read motif; do
  echo "${motif}"
  cp $p/H_scores/rscape/H_symlink_D_search-seqs/$motif/data_1.R2R.sto.svg data/R2R/$motif.svg
  # Remove the annoying data_1 label
  grep -v data_1 data/R2R/$motif.svg  > data/R2R/$motif.svg.new
  mv data/R2R/$motif.svg.new data/R2R/$motif.svg
done < "data/motifs.txt"

# load alignments
mkdir data/motifs
while read motif; do
  echo "${motif}"
  cp $p/F_cmfinder/D_search-seqs/${motif%%.fna.motif*}/$motif  data/motifs/$motif.sto
done < "data/motifs.txt"


# build JalView images
mkdir data/jalview data/motifs-fasta
jalview=/Applications/Jalview.app/Contents/MacOS/jalview
for i in data/motifs/*.sto ; do
    x=$(basename $i .sto)
    if [ ! -f "data/jalview/$x.svg" ] ; then
        $jalview --open="data/motifs/$x.sto" --colour=nucleotide --image="data/jalview/$x.svg" \
            --noshowssannotations --output="data/motifs-fasta/$x.fasta"
    fi
done



echo "Check if this is the expected number of motifs:"
ls -1 data/jalview | wc -l
