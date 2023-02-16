# oligostan
nextflow pipeline to run oligostan on uoe cluster eddie


## run via nextflow pipeline

* log into eddie
~~~
ssh <username>@eddie.ecdf.ed.ac.uk
~~~
* log into wildwest or qlogin node
~~~
qlogin -l h_vmem=8G
~~~
* load nextflow and java modules
~~~
module load roslin/java/18.0.2
module load igmm/bac/nextflow/22.04.0.5697
~~~

* Run pipeline
~~~
export NXF_SINGULARITY_CACHEDIR=/exports/igmm/eddie/BioinformaticsResources/nfcore/singularity-images
$ nextflow run ggrimes/oligostan --fasta test.fasta --outdir results -profile eddie
~~~
