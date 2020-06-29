rule filter_IC:
    input:
        "filter_vcf/filter_gene/{sample}.vcf"
    output:
        "filter_vcf/filter_IC/{sample}.vcf"
    message:
        "filter IC :  {wildcards.sample}"
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
        "logs/filter_IC/{sample}.log"

    shell :
        "grep -E 'set=Intersection|set=..-' {input} > {output}"
