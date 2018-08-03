import pandas as pd
import numpy as np
import math as math


if True: # some data
  if True: # 2016 poverty lines
    poverty =         241673
    extreme_poverty = 114692
    min_wage =        689454

  raw = pd.read_csv("data/2016-wages.csv").rename(columns = {"w_m_gross":"wage_g_m", "profit":"profit_g_m"} )
  
  scale_to_population = 49e6 / len(raw)
    # TODO ? This is a ratio of individuals. Could it be different for households?


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

  cost_in_trillions = ( df["eitc"].sum()           # add every eitc expenditure
                        * scale_to_population      # scale to actual population size
                        / 1e12 )                   # express in trillions of pesos

  return(df, cost_in_trillions)


def add_poverty_gap_change (df, income_0_colname, income_1_colname, household_size_column):
  size = df[household_size_column]

  x = df[income_0_colname]
  df[        "poverty_0"] = np.where( x <         poverty * size,         poverty * size - x, 0 )
  df["extreme_poverty_0"] = np.where( x < extreme_poverty * size, extreme_poverty * size - x, 0 )

  x = df[income_1_colname]
  df[        "poverty_1"] = np.where( x <         poverty * size,         poverty * size - x, 0 )
  df["extreme_poverty_1"] = np.where( x < extreme_poverty * size, extreme_poverty * size - x, 0 )

  df[        "poverty_drop"] = df[        "poverty_0"] - df[        "poverty_1"]
  df["extreme_poverty_drop"] = df["extreme_poverty_0"] - df["extreme_poverty_1"]

  poverty_drop         = (scale_to_population / 1e9) * df[        "poverty_drop"].sum()
  extreme_poverty_drop = (scale_to_population / 1e9) * df["extreme_poverty_drop"].sum()

  return ( df, poverty_drop, extreme_poverty_drop )


def add_poverty_exits (df, income_0_colname, income_1_colname, household_size_colname):
  inc0, inc1, size = df[income_0_colname], df[income_1_colname], df[household_size_colname]
  df[        "poverty_exit"] = (inc0 <         poverty * size) & (inc1 >         poverty * size)
  df["extreme_poverty_exit"] = (inc0 < extreme_poverty * size) & (inc1 > extreme_poverty * size)
  df[       "min_wage_exit"] = (inc0 <        min_wage * size) & (inc1 >        min_wage * size)
  poverty_exits         = scale_to_population * df[        "poverty_exit"].sum()
  extreme_poverty_exits = scale_to_population * df["extreme_poverty_exit"].sum()
  min_wage_exits        = scale_to_population * df[       "min_wage_exit"].sum()
  return ( df, poverty_exits, extreme_poverty_exits, min_wage_exits )
