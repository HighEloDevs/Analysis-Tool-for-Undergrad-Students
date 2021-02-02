# -*- coding: utf-8 -*-
"""
Created on Sat Jan 30 20:17:54 2021

@author: guilh

Testes

"""

import numpy as np
import matplotlib.pyplot as plt
from lmfit.models import ExpressionModel
from lmfit import Parameters
import pandas as pd

x = [19, 63, 110, 150, 199, 243]
y = [17.6, 18.7, 19.8, 20.5, 21.7, 22.8]
sig = [0.1, 0.1, 0.1, 0.1, 0.1, 0.1]

x = np.array(x)
#x = np.deg2rad(x)
y = np.array(y)
sig = np.array(sig)
#sig = np.deg2rad(sig)

gmod = ExpressionModel('a*x + b')

p = Parameters()
for i in gmod.param_names:
    p.add(i, value=1)

result = gmod.fit(data=y, x=x, params=p, scale_covar = False, weights = 1/sig) #, fit_kws = {absolute_sigma : True})
#result.plot_fit()

print(result.fit_report())

# df = pd.read_csv(r"C:\Users\guilh\Documents\GitHub\Analysis-Tool-for-Undergrad-Students---ATUS/dale.txt",
#                  sep='\t', header=None, dtype=str).dropna()

# for i in df.columns:
#     df[i] = [x.replace(',', '.') for x in df[i]]
#     df[i] = df[i].astype(float)
        
    

#df = pd.DataFrame.astype(df, dtype = float, copy=True, errors='raise')
#df = df.applymap(lambda x: x.replace(',', '.')).astype(float)













