import pandas as pd
import numpy as np
import math as math

x
if True: # The EITC parameters
  corner_1 = 300 # income level where the first corner lies
  corner_2 = 600
  corner_3 = 1200
  eitc_max = 300 # max payout

df = pd.DataFrame(
  columns = ["inc-0"], # pre-eitc income
  data = [[x*100] for x in range(math.floor(corner_3*1.5/100))] )

if True:
  x = df["inc-0"]
  df["seg-1"] = np.where((x > 0)          & (x < corner_1),
                         eitc_max*(x/corner_1),
                         0)
  df["seg-2"] = np.where((x >= corner_1)  & (x < corner_2),
                         eitc_max,
                         0)
  df["seg-3"] = np.where((x >= corner_2 ) & (x < corner_3),
                         (corner_3-x)/(corner_3-corner_2)*eitc_max,
                         0)
  del(x)

df["eitc"] = df["seg-1"] + df["seg-2"] + df["seg-3"]
df["inc-1"] = df["inc-0"] + df["eitc"] # post-eitc income

cost = df["eitc"].sum()
