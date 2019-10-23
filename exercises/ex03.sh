if [ "$#" -eq 1 ] #check if the number of arguments received equals 1
then
    sampleid=$1

    echo "Running cutadapt..."
    cutadapt -m 20 -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT -o out/cutadapt/${sampleid}_1.trimmed.fastq.gz -p out/cutadapt/${sampleid}_2.trimmed.fastq.gz data/${sampleid}_1.fastq.gz data/${sampleid}_2.fastq.gz > log/cutadapt/${sampleid}.log
    echo "Running STAR index..."
    STAR --runThreadN 4 --runMode genomeGenerate --genomeDir res/genome/star_index/ --genomeFastaFiles res/genome/ecoli.fasta --genomeSAindexNbases 9
    echo "Running STAR alignment..."
    STAR --runThreadN 4 --genomeDir res/genome/star_index/ --readFilesIn out/cutadapt/${sampleid}_1.trimmed.fastq.gz out/cutadapt/${sampleid}_2.trimmed.fastq.gz --readFilesCommand zcat --outFileNamePrefix out/star/${sampleid}/
else
    echo "Usage: $0 <sampleid>" #the special variable $0 contains the name of the script

    # In the next line, return an error signal instead of the default OK signal.
    # This allows us to run something like
    #       bash ex03.sh && bash nextscript.sh
    # where the second script will only run if the first one finishes OK, or
    #       bash ex03.sh || bash cleanup.sh
    # where the second script will only be run if the first one fails.
    exit 1
fi
