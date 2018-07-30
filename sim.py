import pandas as pd
import numpy as np
import math as math


if True: # The EITC parameters
  corner_1 = 300 # income level where the first corner lies
  corner_2 = 600
  corner_3 = 1200
  max_payout = 300 # max payout

if True: # The data
  data = pd.read_csv("data/workdata_2016_wages.csv")
  # The next two variables are mutually exclusive.
  data["w_m_gross"].fillna(0, inplace=True) # wage
  data["profit"].fillna(0, inplace=True)    # non-wage
  data["month_inc"] = data["profit"] + data["w_m_gross"]

if True: # The fraction of the data I need
  small = data[["month_inc"]]

fake = pd.DataFrame(
  columns = ["inc-0"], # pre-eitc income
  data = [[x*100] for x in range(math.floor(corner_3*1.5/100))] )

# example:
# df2,cost = computeEitc( data, "w_m_gross", 300e3, 600e3, 1200e3, 300e3 )
def computeEitc (df, income_colname, corner_1, corner_2, corner_3, max_payout):
  x = df[income_colname]
  df["seg-1"] = np.where((x > 0)          & (x < corner_1),
                         max_payout*(x/corner_1),
                         0)
  df["seg-2"] = np.where((x >= corner_1)  & (x < corner_2),
                         max_payout,
                         0)
  df["seg-3"] = np.where((x >= corner_2 ) & (x < corner_3),
                         (corner_3-x)/(corner_3-corner_2)*max_payout,
                         0)
  df["eitc"] = df["seg-1"] + df["seg-2"] + df["seg-3"]
  df["eitc+income"] = df[income_colname] + df["eitc"] # post-eitc income
  
  cost = df["eitc"].sum()

  return(df, cost)
