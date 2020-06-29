"""
This rule filter 10% DP
"""
rule filtre_DPmean:
    input:
        "filter_vcf/filter_IC/{sample}.vcf"
    output:
        "filter_vcf/filter_DP/{sample}.vcf"
    message:
        "Filter DP :  {wildcards.sample}"
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
        "logs/filter_DP/{sample}.log"

    shell :
        """
        python scripts/filtres_dp.py {input} | sed '/^[[:space:]]*$/d' > {output}
        """
