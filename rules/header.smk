rule header :
    input:
        vcf="vcf/{sample}.vcf",
    output:
        "filter_vcf/tmp/{sample}_header.vcf"
    message:
        "filter gene :  {wildcards.sample}"
    threads:
        1
    resources:
        time_min = (
            lambda wildcars, attempt: min(30 * attempt, 90)
        ),
        mem_mb = (
            lambda wildcars, attempt: min(128 * attempt, 512)
        )
    log:
        "logs/header/{sample}.log"

    shell :
        "grep '#' {input} > {output}"


rule concatenate_vcf_header:
    input:
        head="filter_vcf/tmp/{sample}_header.vcf",
        vcf="filter_vcf/filter_cov/{sample}.vcf"
    output:
        temp("results/{sample}.vcf")
    message:
        "filter gene :  {wildcards.sample}"
    threads:
        1
    resources:
       time_min = (
            lambda wildcars, attempt: min(30 * attempt, 90)
        ),
        mem_mb = (
            lambda wildcars, attempt: min(128 * attempt, 512)
        )
    log:
        "logs/concatenate/{sample}.log"

    shell :
        "cat {input.head} {input.vcf} > {output}"