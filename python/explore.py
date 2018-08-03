import pandas as pd

df = pd.read_csv("data/2016-wages.csv")

print("About 80% of these values are missing.")
for x in df.columns:
  print( x )
  print( df[x].count() )
  print( len(df[x]) )
  print("")
