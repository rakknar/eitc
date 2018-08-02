# Run this after sim-1-fixed.py
# That file probably won't need changes; this one is meant to be fiddled with.

if True: # set some parameters
  if True: # parameters of the EITC
    corner_1 = 300e3 # income level where the first corner lies
    corner_2 = 600e3
    corner_3 = 1200e3
    max_payout = 300e3 # max payout

  if True: # 2016 poverty lines
    poverty =         241673
    extreme_poverty = 114692

if True: # manicure the data
  ppl = raw.copy()[['wage_g_m', 'profit_g_m', 'hh_id1', 'hh_id2']]
    # ppl drops from raw the hours variables, among others

  # "wage" and "profit" in this data are mutually exclusive.
  ppl["wage_g_m"].fillna(0, inplace=True)      # wage
  ppl["profit_g_m"].fillna(0, inplace=True)    # non-wage
  ppl["income_g_m"] = ppl["profit_g_m"] + ppl["wage_g_m"]

ppl,cost = add_eitc_columns( ppl, "income_g_m", corner_1, corner_2, corner_3, max_payout )

hhs = ( ppl.groupby(['hh_id1', 'hh_id2'])
        [["income_g_m", "income+eitc"]].agg('sum') )

hhs, drop, extreme_drop = compute_poverty_gap_change( hhs, "income_g_m", "income+eitc" )

pd.set_option('display.max_columns', 20)
x = hhs[ (hhs["extreme_poverty_0"] > 0) & (hhs["income_g_m"] > 0) ]
x[['income_g_m', 'income+eitc', 'poverty_0', 'poverty_1', 'poverty_drop']]
