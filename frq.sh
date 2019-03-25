#$ -cwd -V
#$ -l h_rt=48:00:00
#x$ -m be
#$ -l h_vmem=2G
#$ -pe smp 2

# produces doc.num files for each document
# it is run after 
# qsub frq-split1.sh corpus[ol.xz] 1000

# the only parameter is coming from the SGE run -t 1-fnum

# this to be followed with
# qsub collect-num.sh corpus/

if [[ ${SGE_TASK_ID} =~ ^[0-9]+$ ]]; then
  echo "Batch ${SGE_TASK_ID}"
  s=${SGE_TASK_ID}
else
  s=$1
fi
echo $s
NUM=$(printf "%04d" "$s")
echo "$NUM.num"
rm $NUM.num
while IFS= read -r line; do
  echo "$line" | frq-line.sh >>$NUM.num
done < "x$NUM"
