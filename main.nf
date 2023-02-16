// enable dsl2
nextflow.enable.dsl = 2

//params
params.fasta = 'test.fasta' //path to fasta file
params.outdir = 'results' //path to output directory



//help message
def helpMessage = """\
    Usage:
    The typical command for running the pipeline is as follows:
    nextflow run oligostan.nf --fasta test.fasta --outdir results -profile eddie

    Mandatory arguments:
      --fasta                     Path to fasta file
      --outdir                    Path to output directory

    Optional arguments:
      --help                      Shows help message
"""

// show help message
if (params.help) {
    log.info helpMessage
    exit 0
}

    fasta_count = file(params.fasta,   checkIfExists: true).countFasta()
log.info """\
    ========================================
    Oligostan
    ========================================
    Input Fasta: ${params.fasta} with ${fasta_count} sequences
    Output directory: ${params.outdir}
    ========================================
""".stripIndent()

// design oligos using inout fasta file
process oligostan {
    tag "Design_OligoPools_RNAprobes"
    publishDir "${params.outdir}/${simpleName}", mode: 'copy'
    container 'docker://oligostan/oligostan_ht_rna:2.3'
    cpus 2
    memory '16 GB'
    input:
        path fasta
    output:
        path 'Design*', emit: design                            
  
    script:
    simpleName = fasta.simpleName
    """
    # This will copy some files to the local folder you selected when starting the container
    cp -r /lib/Oligostan/export/Design_OligoPools_RNAprobes .
    # This will copy the fasta file to the design folder
    cp ${fasta} Design_OligoPools_RNAprobes/intron.fasta
    # move to the design folder
    cd Design_OligoPools_RNAprobes
    # This will change the name of the fasta file to intron.fasta
    sed -i 's/TestEB.fa/intron.fasta/' Launch_Design_SingleSet_RNAProbes_with_merge.R
    #sed -i 's/\\/export\\/Design_OligoPools_RNAprobes\\///g' Launch_Design_SingleSet_RNAProbes_with_merge.R
    #sed -i 's/\\/export\\/Design_OligoPools_RNAprobes//g' Launch_Design_SingleSet_RNAProbes_with_merge.R
    # This will run the oligostan pipeline
    Rscript Launch_Design_SingleSet_RNAProbes_with_merge.R
    """
}

// main
workflow {
    fasta_ch = channel.fromPath(params.fasta,   checkIfExists: true)
    oligostan(fasta_ch)
}

//workflow on complete print message and print if there are any errors
workflow.onComplete {
    log.info "Pipeline completed at: $workflow.complete"
    if (workflow.success) {
        log.info "Pipeline completed successfully"
    } else {
        log.info "Pipeline completed with errors"
    }
}
