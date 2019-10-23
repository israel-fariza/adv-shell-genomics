echo "Running cutadapt..."
cutadapt -m 20 -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT -o out/cutadapt/$1_1.trimmed.fastq.gz -p out/cutadapt/$1_2.trimmed.fastq.gz data/$1_1.fastq.gz data/$1_2.fastq.gz > log/cutadapt/$1.log
echo "Running STAR index..."
STAR --runThreadN 4 --runMode genomeGenerate --genomeDir res/genome/star_index/ --genomeFastaFiles res/genome/ecoli.fasta --genomeSAindexNbases 9
echo "Running STAR alignment..."
STAR --runThreadN 4 --genomeDir res/genome/star_index/ --readFilesIn out/cutadapt/$1_1.trimmed.fastq.gz out/cutadapt/$1_2.trimmed.fastq.gz --readFilesCommand zcat --outFileNamePrefix out/star/$1/
