#$ -cwd -V
#$ -l h_rt=48:00:00
#$ -m be
#$ -l h_vmem=2G
#$ -pe smp 2

# 1 $1.ol.xz
# 2 documents per split

# to be followed by making the frq lists
# qsub -t 1-100 frq.sh

mkdir -p $1
cd $1
xzcat ../$1.ol.xz | cut -f 2 | tokenise.sh | gawk '{print(tolower($0))}' | split --numeric-suffixes=1 -l $2 -a 4
find . -name 'x*' | wc -l
