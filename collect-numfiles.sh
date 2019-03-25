#$ -cwd -V
#$ -l h_rt=48:00:00
#$ -l h_vmem=41G
#$ -m e

# to be followed by
# qsub split-frq.sh $1-robust
echo $1
find  $1 -name '????.num' | wc -l
export LC_ALL=C
find  $1 -name '????.num' | xargs sort -S 40G -T . | xz -8 >$1-doc.num.xz

