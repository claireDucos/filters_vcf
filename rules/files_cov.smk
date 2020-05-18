rule get_dp_mean:
    input:
        "filter_vcf/filter_IC/{sample}.vcf"
    output:
        temp("filter_vcf/filter_cov/{sample}_mean.txt")
    message:
        "filter cov :  {wildcards.sample}"
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
        "filter_vcf/filter_cov/log/{sample}.log"

    shell :
        """
        grep -o 'DP=[0-9]*' {input} | grep -o '[0-9]*' > {output}; tot=0;
        while read p; do
            ((tot+=p))
        done <{output}; line=$(wc -l {output} | cut -d" " -f1); echo $(($tot/$line)) > {output}
        """

rule filter_cov :
    input:
        mean="filter_vcf/filter_cov/{sample}_mean.txt",
        vcf="filter_vcf/filter_IC/{sample}.vcf"
    output:
        "filter_vcf/filter_cov/{sample}.vcf"
    message:
        "filter cov :  {wildcards.sample}"
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
        "filter_vcf/filter_cov/log/{sample}.log"

    shell :