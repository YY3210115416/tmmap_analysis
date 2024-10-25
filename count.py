import pandas as pd

df = pd.read_csv('allloop.txt',sep='\t') 
count_high_enhancer = df[(df.iloc[:, 13] == 'high') & (df.iloc[:, 15] == 'enhancer')].shape[0]
count_high_promoter = df[(df.iloc[:, 13] == 'high') & (df.iloc[:, 15] == 'promoter')].shape[0]
count_low_enhancer = df[(df.iloc[:, 13] == 'low') & (df.iloc[:, 15] == 'enhancer')].shape[0]
count_low_promoter = df[(df.iloc[:, 13] == 'low') & (df.iloc[:, 15] == 'promoter')].shape[0]

print(f'High and Enhancer count: {count_high_enhancer}')
print(f'High and Promoter count: {count_high_promoter}')
print(f'Low and Enhancer count: {count_low_enhancer}')
print(f'Low and Promoter count: {count_low_promoter}')