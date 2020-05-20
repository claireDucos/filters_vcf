rule get_dp_file_only:
    input:
        "filter_vcf/filter_IC/{sample}.vcf"
    output:
        "filter_vcf/filter_cov/dp/{sample}.txt"
    message:
        "filter cov :  {wildcards.sample}"
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
        "logs/filter_cov/{sample}.log"

    shell :
        """
        grep -o 'DP=[0-9]*' {input} | grep -o '[0-9]*' > {output};
        """

rule get_dp_mean:
    input:
        "filter_vcf/filter_cov/dp/{sample}.txt"
    output:
        "filter_vcf/filter_cov/dp/{sample}_seuil.txt"
    message:
        "filter cov :  {wildcards.sample}"
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
        "logs/filter_cov/{sample}.log"

    shell :
        """
        tot=0;
        while read p; do
            ((tot+=p))
        done <{input}; line=$(wc -l {input} | cut -d" " -f1); mean=$(($tot/$line)) ; echo $(($mean/10)) > {output}
        """


rule filter_cov :
    input:
        dp_file="filter_vcf/filter_cov/dp/{sample}.txt",
        vcf="filter_vcf/filter_IC/{sample}.vcf",
        seuil="filter_vcf/filter_cov/dp/{sample}_seuil.txt"
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
        "logs/filter_cov/{sample}.log"

    shell :
          """
           seuil=$(cat {input.seuil})
           if [ $seuil -le 10 ]
           then
                grep  -E 'DP=[1-9][0-9]+' {input.vcf} > {output}
           else
               cat {input.dp_file} | awk -v seuil=$seuil '{{if($1>seuil)print $1}}' > {input.seuil};
               sed -i -e 's/^/DP=/' {input.seuil};
               grep -f {input.seuil} {input.vcf} > {output}
           fi"""


