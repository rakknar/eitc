exec(open("sim.py").read())


# latest|most relevant question
hhs_max = ( ppl.groupby(['hh_id1', 'hh_id2'])
            [["month_inc"]].agg('max')
            .rename( columns = {"month_inc":"max_inc"} ) )
x = hhs_max["max_inc"]
x[ x >= 3e6 ].count() / x.count()
x[ x > 3e6 ].count() / x.count()


# more
indiv = ppl["month_inc"]
hhs = hhs.join(hhs_max) # a wider data set of the same height
hh = hhs["month_inc"]

indiv[ indiv>3e6 ].count() / indiv.count()
indiv[ indiv>=3e6 ].count() / indiv.count()

hh[ hh>3e6 ].count() / hh.count()
hh[ hh>=3e6 ].count() / hh.count()

