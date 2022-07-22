# -*- coding: utf-8 -*-
"""
MIT License

Copyright (c) 2021 Leonardo Eiji Tamayose, Guilherme Ferrari Fortino

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""

# from pytexit import py2tex
# from PyQt5.QtCore import QObject, pyqtSlot
# from io import BytesIO
# import matplotlib.pyplot as plt


# class PyLatex(QObject):
#     def __init__(self):
#         super().__init__()

#         self.fig = plt.figure(figsize=(0.03, 0.03))
#         self.fig.text(
#             x=0,
#             y=0,
#             s=f"INIT",
#             fontsize=15,
#             c="#FFF",
#         )
#         output = BytesIO()
#         self.fig.savefig(
#             output,
#             dpi=500,
#             transparent=True,
#             format="svg",
#             bbox_inches="tight",
#             pad_inches=1,
#         )

#     @pyqtSlot(str, result=str)
#     def py2svg(self, formula, fontsize=15, dpi=500):
#         """Render TeX formula to SVG.
#         Args:
#             formula (str): TeX formula.
#             fontsize (int, optional): Font size.
#             dpi (int, optional): DPI.
#         Returns:
#             str: SVG render.
#         """
#         try:
#             svg = py2tex(formula, print_formula=False, print_latex=False)[1:-1]
#         except:
#             return ""

#         self.fig.clear()
#         self.fig.text(
#             x=0,
#             y=0,
#             s=f"{svg}",
#             fontsize=fontsize,
#             c="#FFF",
#         )

#         output = BytesIO()
#         self.fig.savefig(
#             output,
#             dpi=dpi,
#             transparent=True,
#             format="svg",
#             bbox_inches="tight",
#             pad_inches=1,
#         )
#         plt.close(self.fig)

#         output.seek(0)
#         return output.read().decode("utf-8")
