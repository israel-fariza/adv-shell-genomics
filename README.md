# Advanced Linux shell

## Preparing the workspace

```shell
export WD=$(pwd)
mkdir data log out res
tree
```

## Obtaining the genome
```shell
mkdir res/genome
cd $_
wget -O ecoli.fasta.gz ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz
gunzip ecoli.fasta.gz
```

## Obtaining sequencing reads
    - describe the dataset
    https://www.ebi.ac.uk/arrayexpress/experiments/E-MTAB-7361/samples/?
    https://www.ebi.ac.uk/ena/data/view/ERR2868172

## Exploring the reads
    - gunzip
    - more
    - gunzip -c | more
    - zcat | more

    - wc -l \*.fastq
    - grep "^+$" algo.fastq | wc -l
    - grep -c "^+$"

## Subsampling the reads
```shell
conda install seqtk
cd $WD
mkdir original
mv *.fastq.gz original 
seqtk sample -s100 original/ERR2868172_1.fastq.gz 300000 > ERR2868172_1.fastq.gz
seqtk sample -s100 original/ERR2868172_2.fastq.gz 300000 > ERR2868172_2.fastq.gz

seqtk sample -s7 original/ERR2868172_1.fastq.gz 300000 > ERR2868173_1.fastq.gz
seqtk sample -s7 original/ERR2868172_2.fastq.gz 300000 > ERR2868173_2.fastq.gz
seqtk sample -s56 original/ERR2868172_1.fastq.gz 300000 > ERR2868174_1.fastq.gz
seqtk sample -s56 original/ERR2868172_2.fastq.gz 300000 > ERR2868174_2.fastq.gz
```

## Quality control

```shell
conda install fastqc
cd $WD
mkdir out/fastqc
fastqc -o out/fastqc data/original/*.fastq.gz 
```

## Stripping the adapters

```shell
conda install cutadapt

cutadapt -m 20 -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT -o out/cutadapt/ERR2868172_1.sample.trimmed.fastq.gz -p out/cutadapt/ERR2868172_2.sample.trimmed.fastq.gz data/ERR2868172_1.sample.fastq.gz data/ERR2868172_2.sample.fastq.gz
```

## Indexing the genome
```shell
conda install star

STAR --runThreadN 4 --runMode genomeGenerate --genomeDir res/genome/star_index/ --genomeFastaFiles res/genome/ecoli.fasta --genomeSAindexNbases 9
```

## Aligning the reads
```shell
STAR --runThreadN 4 --genomeDir res/genome/star_index/ --readFilesIn out/cutadapt/ERR2868172_1.sample.trimmed.fastq.gz out/cutadapt/ERR2868172_2.sample.trimmed.fastq.gz --readFilesCommand zcat --outFileNamePrefix out/star/ERR2868172/
```

## Generating a report
```shell
conda install multiqc
cd $WD
multiqc .
```

## Exercise
Create a shell script that executes all the steps starting from the adapter removal.

## Arguments
How to grab arguments inside a shell script

## Exercise
Modify the shell script so that it takes the sequencing file names as input

## Variables
Assign values and the result of a command

## Control structures: if
if [ "$#" -ne 1 ]; then
if [ -s /tmp/myfile.txt ]

## Exercise
Modify the script so that it shows an error message and exits if you don't input the two files, or if a file is empty

## Control structures: for

## cool commands
    - basename
    - dirname
    - cut
    - sed

## Exercise
Write a for loop that calls your script for every pair of files in the data directory
