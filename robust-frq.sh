#submission of R scripts.
#-t is for batches
# 1 total num of docs
# 2 total num of words
#$ -cwd -V
#$ -l h_rt=8:00:00
#$ -l h_vmem=20G
#x$ -t 1-23412

module add R
if [[ ${SGE_TASK_ID} =~ ^[0-9]+$ ]]; then
  echo "Batch ${SGE_TASK_ID}"
  s=${SGE_TASK_ID}
else
  s=$5
fi
echo $* $s 
Rscript ~/robust-frq/robust-final-1000a.R $s $*
