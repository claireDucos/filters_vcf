rule decompress_vcf:
    input:
        "vcf/{sample}.vcf.gz"
    output:
        temp("vcf/{sample}.vcf")
    message:
        "decompressing {wildcards.sample}"
    threads:
        4
    resources:
        time_min = (
            lambda wildcars, attempt: min(30 * attempt, 90)
        ),
        mem_mb = (
            lambda wildcars, attempt: min(128 * attempt, 512)
        )
    log:
        "logs/compress/{sample}.vcf.log"
    shell:
        "gzip -d {input} -f > {output}"

rule compress_vcf:
    input:
        "results/{sample}.vcf"
    output:
        "results/{sample}.vcf.gz"
    message:
        "Compressing and indexing {wildcards.sample}"
    threads:
        2
    resources:
        time_min = (
            lambda wildcars, attempt: min(30 * attempt, 90)
        ),
        mem_mb = (
            lambda wildcars, attempt: min(128 * attempt, 512)
        )
    conda:
        "../envs/pbgzip.yaml"
    log:
        "logs/compress/{sample}.vcf.log"
    shell:
        "pbgzip -c {input} -n {threads} > {output} 2> {log}"

"""
This rule indexes a compressed VCF file
"""
rule vcf_tabix:
    input:
         "results/{sample}.vcf.gz"
    output:
         "results/{sample}.vcf.gz.tbi"
    message:
        "Indexing annotated vcf for {wildcards.sample}"
    threads:
        1
    resources:
        mem_mb = (
            lambda wildcards, attempt: min(attempt * 512, 10240)
        ),
        time_min = (
            lambda wildcards, attempt: min(attempt * 20, 200)
        )
    log:
        "logs/tabix/{sample}.log"
    shell:
        "tabix -p vcf {input} -f > {output}"
