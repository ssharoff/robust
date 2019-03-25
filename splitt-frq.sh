#submission of R scripts.
#-t is for batches
# 1 - lg name
# 2 - mincount
#$ -cwd -V
#$ -m e
#$ -l h_rt=48:00:00
#$ -l h_vmem=4G

module add python
echo $*
mkdir -p $1-robust
cd $1-robust
xzcat ../$1-doc.num.xz | ~/robust-frq/splitnum.py $2 $3
find . -name '*.dat' | wc -l >../$1.files
