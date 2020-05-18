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
            lambda wildcars, attempt: min(30 * attempt, 90)
        ),
        mem_mb = (
            lambda wildcars, attempt: min(8 * attempt, 15)
        )
    log:
        "filter_vcf/filter_IC/log/{sample}.log"

    shell :
        "grep -E 'set=Intersection|set=..-' {input} > {output}"
