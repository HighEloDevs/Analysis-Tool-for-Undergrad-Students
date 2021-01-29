# -*- coding: utf-8 -*-
"""
Created on Fri Jan 29 11:59:27 2021

@author: LeoEiji
"""

import numpy as np
import matplotlib.pyplot as plt
from lmfit.models import ExpressionModel
from lmfit import Parameters

f = lambda x: x**3 + x**2 + x + 10
x = np.linspace(0, 10, 20)
z = f(x) + np.random.randn(20)*5

gmod = ExpressionModel('a*x**3 + b*x**2 + c*x + d')

p = Parameters()
for i in gmod.param_names:
    p.add(i, value=1)

result = gmod.fit(data=z, x=x, params=p)
result.plot_fit()

print(result.fit_report())