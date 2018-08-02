import pandas as pd
import numpy as np
import math as math


if True: # set some parameters
  if True: # parameters of the EITC
    corner_1 = 300 # income level where the first corner lies
    corner_2 = 600
    corner_3 = 1200
    max_payout = 300 # max payout

  if True: # 2016 poverty lines
    poverty =         241673
    extreme_poverty = 114692

if True: # The data
  raw = pd.read_csv("data/2016-wages.csv").rename(columns = {"w_m_gross":"wage_g_m", "profit":"profit_g_m"} )
  ppl = raw.copy()[['wage_g_m', 'profit_g_m', 'hh_id1', 'hh_id2']]
    # ppl drops from raw the hours variables, among others

  # "wage" and "profit" in this data are mutually exclusive.
  ppl["wage_g_m"].fillna(0, inplace=True)      # wage
  ppl["profit_g_m"].fillna(0, inplace=True)    # non-wage
  ppl["income_g_m"] = ppl["profit_g_m"] + ppl["wage_g_m"]

def add_eitc_columns (df, income_colname, corner_1, corner_2, corner_3, max_payout):
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
  df["income+eitc"] = df[income_colname] + df["eitc"] # post-eitc income

  cost_in_trillions = ( df["eitc"].sum()           # scale to actual population size, 49 million
                        * (49e6 / len(df["eitc"])) # add every eitc expenditure
                        / 1e12 )                   # express in trillions of pesos

  return(df, cost_in_trillions)

ppl,cost = add_eitc_columns( ppl, "income_g_m", corner_1, corner_2, corner_3, max_payout )

hhs = ( ppl.groupby(['hh_id1', 'hh_id2'])
        [["income_g_m", "income+eitc"]].agg('sum') )

def compute_poverty_gap_change (df, income_0_colname, income_1_colname):
  x = df[income_0_colname]
  df["poverty_0"]         = np.where( x < poverty        , poverty - x        , 0 )
  df["extreme_poverty_0"] = np.where( x < extreme_poverty, extreme_poverty - x, 0 )

  x = df[income_1_colname]
  df["poverty_1"]         = np.where( x < poverty        , poverty - x        , 0 )
  df["extreme_poverty_1"] = np.where( x < extreme_poverty, extreme_poverty - x, 0 )

  df["poverty_drop"]         = df["poverty_0"]         - df["poverty_1"]
  df["extreme_poverty_drop"] = df["extreme_poverty_0"] - df["extreme_poverty_1"]

  return ( df, df["poverty_drop"].sum(), df["extreme_poverty_drop"].sum() )

hhs, drop, extreme_drop = compute_poverty_gap_change( hhs, "income_g_m", "income+eitc" )

pd.set_option('display.max_columns', 20)
x = hhs[ (hhs["extreme_poverty_0"] > 0) & (hhs["income_g_m"] > 0) ]
x[['income_g_m', 'income+eitc', 'poverty_0', 'poverty_1', 'poverty_drop']]
