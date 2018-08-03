import pandas as pd


if True: # project-external (fixed) data
  if True: # 2016 poverty lines
    poverty =         241673
    extreme_poverty = 114692
    min_wage =        689454

  raw = pd.read_csv("data/2016-wages.csv").rename(columns = {"w_m_gross":"wage_g_m", "profit":"profit_g_m"} )

  scale_to_population = 49e6 / len(raw)
    # TODO ? This is a ratio of individuals. Could it be different for households?


if True: # project-internal (can vary) data
  if True: # the person-level data
    ppl = raw.copy()[['wage_g_m', 'profit_g_m', 'hh_id1', 'hh_id2']]
      # ppl drops from raw the hours variables, among others

    # "wage" and "profit" in this data are mutually exclusive.
    ppl["wage_g_m"]  .fillna(0, inplace=True)    # wage
    ppl["profit_g_m"].fillna(0, inplace=True)    # non-wage
    ppl["income_g_m"] = ppl["profit_g_m"] + ppl["wage_g_m"]
    ppl["persons"] = 1

  if True: # EITC parameters
    corner_1 = 200e3
    corner_2 = 300e3
    corner_3 = 1200e3
    max_payout = 300e3
#    corner_1 = 300e3
#    corner_2 = 600e3
#    corner_3 = 1200e3
#    max_payout = 300e3
