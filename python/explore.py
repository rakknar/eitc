# First run main.py

if True: # Why are most nonpositive values missing, but a few are zero?
  len( raw[ raw['wage_g_m']   ==0      ] )
  len( raw[ raw['wage_g_m'].isnull()   ] )
  len( raw[ raw["profit_g_m"] ==0      ] )
  len( raw[ raw["profit_g_m"].isnull() ] )

print( "missing data fractions: " )
for (name,df) in [("ppl", ppl), ("hhs",hhs)]:
  print( name + ":")
  print( df["income_g_m"].count() / len( df["income_g_m"] ) )
  print()
