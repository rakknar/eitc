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

  # The next two variables are mutually exclusive.
  ppl["wage_g_m"].fillna(0, inplace=True) # wage
  ppl["profit_g_m"].fillna(0, inplace=True)    # non-wage
  ppl["income_g_m"] = ppl["profit_g_m"] + ppl["wage_g_m"]
  # ppl["hh"] = ppl["hh_id1"].astype(str) + "-" + ppl["hh_id2"].astype(str)
    # maybe not needed, since we can group (see definition of the frame "hhs") on two columns

  hhs = ( ppl.groupby(['hh_id1', 'hh_id2'])
          [["income_g_m"]].agg('sum') )
  
  ppl_brief = ppl.copy()[["income_g_m"]]

  fake_data = pd.DataFrame(
    columns = ["inc-0"], # pre-eitc income
    data = [[x*100] for x in range(math.floor(corner_3*1.5/100))] )

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
  
  cost_in_trillions = ( df["eitc"].sum()           # scale to actual population size, 49 million
                        * (49e6 / len(df["eitc"])) # add every eitc expenditure
                        / 1e12 )                   # put it in trillions

  return(df, cost_in_trillions)

df2,cost = computeEitc( ppl_brief, "income_g_m", 300e3, 600e3, 1200e3, 300e3 )
