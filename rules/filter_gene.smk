"""
This rule is the first filter : selection of genes of interest only (list)
"""
rule seletc_id:
    input:
        "gene_list/genes_list_FILIPPO.csv"
    output:
        "gene_list/id.txt"
    message:
        "get id gene from the list"
    threads:
        1
    resources:
        time_min = (
            lambda wildcars, attempt: min(60 * attempt, 120)
        ),
        mem_mb = (
            lambda wildcars, attempt: min(1024 * attempt, 8192)
        )
    log:
        "logs/gene_list/id.log"

    shell:
         "sed '1d' {input} | cut -f4 -d',' | grep -v -w NA > {output} "

#sed '1d' : remove the first line
# cut to retrieve the ENSEMBLE ID
# grep to remove NA

rule filter_id :
    input:
        vcf="vcf/{sample}.vcf",
        id="gene_list/id.txt"
    output:
        "filter_vcf/filter_gene/{sample}.vcf"
    message:
        "filter gene :  {wildcards.sample}"
    threads:
        1
    resources:
        time_min = (
            lambda wildcars, attempt: min(60 * attempt, 120)
        ),
        mem_mb = (
            lambda wildcars, attempt: min(1024 * attempt, 8192)
        )
    log:
        "logs/filter_gene/{sample}.log"

    shell :
        "grep -f {input.id} {input.vcf} > {output}"
