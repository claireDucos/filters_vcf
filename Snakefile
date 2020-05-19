import snakemake.utils  # Load snakemake API
import glob
import os


include: "rules/filter_gene.smk"
include: "rules/filter_IC.smk"
include :"rules/filter_cov.smk"


SAMPLES=[]

sample_id_list = glob.glob('vcf/*.vcf')
for name in sample_id_list:
    SAMPLES.append(name.split('.')[0].split('/')[1].split('_')[0])


rule all:
    input:
        vcf_filtre = expand(
                        "filter_vcf/filter_cov/{sample}.vcf",
                        sample = SAMPLES
                    )
    message:
        "Finishig filter pipeline"