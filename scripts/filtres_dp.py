import pandas as pd
import argparse

parser=argparse.ArgumentParser()
parser.add_argument('infile')
args=parser.parse_args()

vcf_df=pd.read_csv(args.infile, sep='\t', names=['CHROM','POS','ID','REF','ALT','QUAL','FILTER','INFO','FORMAT','HC','PY','ST','UG'])

min_DP=[]

for line in vcf_df.itertuples():
    DP_list = []
    HC_split=line.HC.split(':')
    PY_split=line.PY.split(':')
    ST_split=line.ST.split(':')
    UG_split=line.UG.split(':')
    if (len(HC_split) > 1) :
        DP_list.append(HC_split[1])
    if (len(PY_split) > 1):
        DP_list.append(PY_split[1])
    if (len(ST_split) > 1) :
        DP_list.append(ST_split[1])
    if (len(UG_split) > 1) :
        DP_list.append(UG_split[1])
    DP_list = list(map(int, DP_list))
    min_DP.append(min(DP_list))

mean=sum(min_DP)/len(min_DP)
vcf_df['min_DP']=min_DP

if(mean/10 > 10):
    df_filter_dp = vcf_df[vcf_df.min_DP > mean/10]
else:
    df_filter_dp = vcf_df[vcf_df.min_DP > 10]

df_filter_dp=df_filter_dp.drop('min_DP',axis=1)
print(df_filter_dp.to_csv(sep='\t',header=False))