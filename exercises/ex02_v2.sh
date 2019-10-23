# In this case, instead of directly using the "$1" special variable in every line of code, we first assign it
# to a new variable "sampleid". This will help make our code clearer.

# The problem is that we sometimes insert our variable before characters that could also be part of a valid
# variable name. In the case of "$sampleid_1.trimmed.fastq.gz" and "$sampleid_2.trimmed.fastq.gz", the shell
# would think that the variables we are asking for are "sampleid_1" and "sampleid_2". The dot (.) is not allowed
# in variable names, so the rest of the string would not be considered.

# To prevent this from happening, we simply surround our variable name with curly braces when inserting it into
# the strings, as you can see below.

sampleid=$1

echo "Running cutadapt..."
cutadapt -m 20 -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT -o out/cutadapt/${sampleid}_1.trimmed.fastq.gz -p out/cutadapt/${sampleid}_2.trimmed.fastq.gz data/${sampleid}_1.fastq.gz data/${sampleid}_2.fastq.gz #> log/cutadapt/${sampleid}.log
echo "Running STAR index..."
STAR --runThreadN 4 --runMode genomeGenerate --genomeDir res/genome/star_index/ --genomeFastaFiles res/genome/ecoli.fasta --genomeSAindexNbases 9
echo "Running STAR alignment..."
STAR --runThreadN 4 --genomeDir res/genome/star_index/ --readFilesIn out/cutadapt/${sampleid}_1.trimmed.fastq.gz out/cutadapt/${sampleid}_2.trimmed.fastq.gz --readFilesCommand zcat --outFileNamePrefix out/star/${sampleid}/
