import os
import pandas as pd

import python.datafiles as datafiles

data = pd.read_csv("data/workdata_2016.dta")
data = pd.read_csv("data/workdata_2016.dta", encoding="iso-8859-1",error_bad_lines=False)
data = pd.read_csv("data/workdata_2016.dta", encoding="utf-8")
data = pd.read_csv('file1.csv', 

data = pd.read_stata("data/workdata_2016.dta", encoding="ascii")
data = pd.read_stata("data/workdata_2016.dta", encoding="latin-1")
# data_recip_1.to_csv(   folder + "recip-1/"   + name + '.csv')
