# Run this after sim-1-fixed.py
# That file probably won't need changes; this one is meant to be fiddled with.


if True: # set some parameters
  if True: # parameters of the EITC
    corner_1 = 300e3 # income level where the first corner lies
    corner_2 = 600e3
    corner_3 = 1200e3
    max_payout = 300e3 # max payout


if True: # manicure the data
  ppl = raw.copy()[['wage_g_m', 'profit_g_m', 'hh_id1', 'hh_id2']]
    # ppl drops from raw the hours variables, among others

  # "wage" and "profit" in this data are mutually exclusive.
  ppl["wage_g_m"]  .fillna(0, inplace=True)    # wage
  ppl["profit_g_m"].fillna(0, inplace=True)    # non-wage
  ppl["income_g_m"] = ppl["profit_g_m"] + ppl["wage_g_m"]
  ppl["persons"] = 1


if True: # results
  ppl,cost_in_trillions = add_eitc_columns( ppl, "income_g_m", corner_1, corner_2, corner_3, max_payout )

  hh_groups = ppl.groupby(['hh_id1', 'hh_id2'])
  hhs = (        hh_groups[[ "income_g_m", "income+eitc", "persons"              ]].agg('sum')
          .join( hh_groups[[ col for col in ppl.columns if col.startswith('seg') ]].agg('max') )
  )

  hhs, drop_in_billions, extreme_drop_in_billions = add_poverty_gap_change(
    hhs, "income_g_m", "income+eitc", "persons" )

  hhs, poverty_exits, extreme_poverty_exits, min_wage_exits = add_poverty_exits(
    hhs, "income_g_m", "income+eitc", "persons" )

  print( " cost_in_trillions: " + str( cost_in_trillions ) + '\n',
         "drop_in_billions: " + str( drop_in_billions ) + '\n',
         "extreme_drop_in_billions: " + str( extreme_drop_in_billions ) + '\n',
         "poverty_exits: " + str( poverty_exits ) + '\n',
         "extreme_poverty_exits: " + str( extreme_poverty_exits ) + '\n',
         "min_wage_exits: " + str( min_wage_exits )
  )


if False: # some data checks.  I eyeballed these and similar ones; they look good.
  if True: # Display options: These are clearly wrong, but they seem to work.
    pd.set_option('display.max_columns', 40)
    pd.set_option('display.width', 1000)

  x = hhs[ (hhs["extreme_poverty_0"] > 0) & (hhs["income_g_m"] > 0) ]
  ( x[ x["poverty_0"] > 0]
    [['income_g_m', 'income+eitc', 'poverty_0', 'poverty_1', 'poverty_drop']] )

  x = hhs[ hhs["seg-2"] > 0 ].rename( columns = {"extreme_poverty_drop":"extreme_drop",
                                                 "extreme_poverty_0":"extreme_0",
                                                 "extreme_poverty_1":"extreme_1"
                                     } )
  x[['income_g_m', 'income+eitc', 'poverty_0', 'poverty_1', 'poverty_drop', 'persons']]
  x[['income_g_m', 'income+eitc', 'extreme_0', 'extreme_1', 'extreme_drop', 'persons']]

  x = hhs[ hhs["seg-1"] > 0 ].rename( columns = {"extreme_poverty_exit":"extreme_exit"} )
  x[['income_g_m', 'income+eitc', 'poverty_exit', 'extreme_exit', 'persons']]
