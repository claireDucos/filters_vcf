rule decompress_vcf:
    input:
        "vcf/{sample}.vcf.gz"
    output:
        temp("vcf/{sample}.vcf")
    message:
        "Decompressing {wildcards.sample}"
    threads:
        4
    resources:
        time_min = (
            lambda wildcars, attempt: min(60 * attempt, 120)
        ),
        mem_mb = (
            lambda wildcars, attempt: min(1024 * attempt, 8192)
        )
    log:
        "logs/decompress/{sample}.vcf.log"
    shell:
        "pbgzip -c -d {input} -f > {output}"

rule compress_vcf:
    input:
        "results/{sample}.vcf"
    output:
        "results/{sample}.vcf.gz"
    message:
        "Compressing {wildcards.sample}"
    threads:
        2
    resources:
        time_min = (
            lambda wildcars, attempt: min(60 * attempt, 120)
        ),
        mem_mb = (
            lambda wildcars, attempt: min(1024 * attempt, 8192)
        )
    conda:
        "../envs/pbgzip.yaml"
    log:
        "logs/compress/{sample}.vcf.log"
    shell:
        "pbgzip {input} -n {threads} -f> {output} 2> {log}"

"""
This rule indexes a compressed VCF file
"""
rule vcf_tabix:
    input:
         "results/{sample}.vcf.gz"
    output:
         "results/{sample}.vcf.gz.tbi"
    message:
        "Indexing  {wildcards.sample}"
    threads:
        1
    resources:
        mem_mb = (
            lambda wildcards, attempt: min(attempt *1024 , 8192)
        ),
        time_min = (
            lambda wildcards, attempt: min(attempt * 60, 120)
        )
    log:
        "logs/tabix/{sample}.log"
    shell:
        "tabix -p vcf {input} -f > {output}"
