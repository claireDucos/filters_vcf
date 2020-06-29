"""
This rule get the vcf header
"""
rule header :
    input:
        vcf="vcf/{sample}.vcf",
    output:
        "filter_vcf/tmp/{sample}_header.vcf"
    message:
        "Get the VCF header :  {wildcards.sample}"
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
        "logs/header/{sample}.log"

    shell :
        "grep '#' {input} > {output}"


rule concatenate_vcf_header:
    input:
        head="filter_vcf/tmp/{sample}_header.vcf",
        vcf="filter_vcf/filter_DP/{sample}.vcf"
    output:
        "results/{sample}.vcf"
    message:
        "Concatenate vcf header :  {wildcards.sample}"
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
        "logs/header/{sample}.log"

    shell :
        "cat {input.head} {input.vcf} > {output}"
