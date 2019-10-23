echo "Running cutadapt..."
cutadapt -m 20 -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT -o out/cutadapt/ERR2868172_1.trimmed.fastq.gz -p out/cutadapt/ERR2868172_2.trimmed.fastq.gz data/ERR2868173_1.fastq.gz data/ERR2868173_2.fastq.gz > log/cutadapt/ERR2868172.log
echo "Running STAR index..."
STAR --runThreadN 4 --runMode genomeGenerate --genomeDir res/genome/star_index/ --genomeFastaFiles res/genome/ecoli.fasta --genomeSAindexNbases 9
echo "Running STAR alignment..."
STAR --runThreadN 4 --genomeDir res/genome/star_index/ --readFilesIn out/cutadapt/ERR2868172_1.trimmed.fastq.gz out/cutadapt/ERR2868172_2.trimmed.fastq.gz --readFilesCommand zcat --outFileNamePrefix out/star/ERR2868172/
