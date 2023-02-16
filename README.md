# oligostan
nextflow pipeline to run oligostan on uoe cluster eddie


## run via nextflow pipeline

* log into eddie
~~~
ssh <username>@eddie.ecdf.ed.ac.uk
~~~
* log into wildwest or qlogin node
~~~
ssh node2c15
cd /exports/igmm/eddie/gilbert-analysis/rafal/
~~~
* load nextflow and java modules
~~~
module load roslin/java/18.0.2
module load igmm/bac/nextflow/22.04.0.5697
export NXF_SINGULARITY_CACHEDIR=/exports/igmm/eddie/BioinformaticsResources/nfcore/singularity-images
~~~

* Run pipeline
~~~
nextflow run ggrimes/oligostan --fasta <myfastafile.fasta> --outdir results -profile eddie
~~~
