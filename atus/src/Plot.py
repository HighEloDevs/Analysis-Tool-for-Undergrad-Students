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

from PyQt5.QtCore import QObject, QJsonValue, QUrl, pyqtSignal, pyqtSlot
from src.Calculators import interpreter_calculator, plot
from matplotlib import colors

# from matplotlib import colors
import numpy as np
import pandas as pd
import json
import platform
from .MatPlotLib import Canvas
from .Model import Model
from .DataHandler import DataHandler


class SinglePlot(QObject):
    """Class that controls the single-plot page."""

    # Signal to write infos
    write_calculator = pyqtSignal(str, arguments="expr")
    fill_plot_page_signal = pyqtSignal(QJsonValue, arguments="props")
    plot_signal = pyqtSignal()

    def __init__(self, canvas, model, datahandler, messageHandler):
        super().__init__()
        self.canvas: Canvas = canvas
        self.model: Model = model
        self.datahandler: DataHandler = datahandler
        self.path = ""
        self.msg = messageHandler

        # Default properties for the singlePlot page
        self.props = {
            "id": "",
            "dataProps": {
                "marker_color": "#000",
                "marker_size": 3,
                "marker": "o",
                "curve_color": "#000",
                "curve_thickness": 3,
                "curve_style": "-",
            },
            "canvasProps": {
                "xaxis": "",
                "yaxis": "",
                "title": "",
                "log_x": False,
                "log_y": False,
                "legend": False,
                "grid": False,
                "residuals": False,
                "xmin": "",
                "xmax": "",
                "xdiv": "",
                "ymin": "",
                "ymax": "",
                "ydiv": "",
                "resmin": "",
                "resmax": "",
            },
            "fitProps": {
                "expr": "",
                "p0": "",
                "wsx": True,
                "wsy": True,
                "xmin": "",
                "xmax": "",
                "parameters": {},
                "adjust": True,
            },
            "data": [],
        }

    @pyqtSlot(QJsonValue)
    def get_plot_data(self, plot_data):
        self.model.reset()
        self.datahandler.reset()
        plot_data: dict = plot_data.toVariant()
        canvas_props = plot_data["canvasProps"]
        dataProps = plot_data["dataProps"]
        fit_props = plot_data["fitProps"]

        # Loading data from the table
        self.datahandler.loadDataTable(plot_data["data"])
        self.model.data = self.datahandler.data
        self.model._has_sx = self.datahandler.has_sx
        self.model._has_sy = self.datahandler.has_sy

        # Getting function to fit
        # Anti-dummies system
        fit_props["expr"] = (
            fit_props["expr"]
            .replace("^", "**")
            .replace("arctan", "atan")
            .replace("arcsin", "asin")
        )
        fit_props["expr"] = (
            fit_props["expr"]
            .replace("arccos", "acos")
            .replace("sen", "sin")
            .replace("raiz", "sqrt")
        )
        expIndVar = fit_props["expr"].split(";")
        # Setting expression
        if len(expIndVar) == 2:
            if self.model.exp_model != expIndVar[0]:
                self.model.set_expression(expIndVar[0].strip(), expIndVar[1].strip())
        elif len(expIndVar) == 1:
            if self.model.exp_model != expIndVar[0]:
                self.model.set_expression(expIndVar[0])

        # Getting initial parameters
        if fit_props["p0"].strip() != "":
            p0 = fit_props["p0"]
            # p0 = p0.replace(";", ",")
            p0 = p0.replace("/", ",")
            self.model.set_p0(p0)

        self.model.xmin = self.make_float(fit_props["xmin"], value=-np.inf)
        self.model.xmax = self.make_float(fit_props["xmax"], value=np.inf)

        if self.model.xmin >= self.model.xmax:
            self.msg.raise_error(
                "Intervalo de ajuste inválido. Rever intervalo de ajuste."
            )
            return None

        # Setting style of the plot
        self.plot(self.model, canvas_props, fit_props, dataProps)

    def plot_in_out(
        self,
        x_i,
        y_i,
        x_o,
        y_o,
        kargs_errorbar,
        y_ri=None,
        y_ro=None,
        sy_i=None,
        sy_o=None,
        sx_i=None,
        sx_o=None,
        ssy_i=None,
        ssy_o=None,
    ):
        """Macro para o plot dos ditos inliers e outliers de um ajuste.
        Deprecada."""
        self.canvas.plot_error_bar(
            x_i,
            y_i,
            kargs_errorbar,
            alpha=1,
            sy=sy_i,
            sx=sx_i,
            y_r=y_ri,
            ssy=ssy_i,
        )
        if self.canvas.user_color_outliers is not None:
            kargs_errorbar["ecolor"] = self.canvas.user_color_outliers
            kargs_errorbar["c"] = self.canvas.user_color_outliers
        self.canvas.plot_error_bar(
            x_o,
            y_o,
            kargs_errorbar,
            alpha=self.canvas.user_alpha_outliers,
            sy=sy_o,
            y_r=y_ro,
            sx=sx_o,
            ssy=ssy_o,
        )

    def plot_data(
        self, x, y, sy, sx, kargs_errorbar, kargs_scatter, y_r=None, ssy=None
    ):
        """Macro para o plot dos dados."""
        self.canvas.plot_error_bar_new(x, y, sy, sx, kargs_errorbar, y_r=y_r, ssy=ssy)
        self.canvas.plot_scatter(x, y, kargs_scatter, y_r)

    def plot(self, model: Model, canvas_props, fit_props, data_props):
        self.canvas.set_tight_layout()
        sigma_x = not not fit_props["wsx"]
        sigma_y = not not fit_props["wsy"]
        grid = not not canvas_props["grid"]
        log_x = not not canvas_props["log_x"]
        log_y = not not canvas_props["log_y"]
        legend = not not canvas_props["legend"]
        residuals = not not canvas_props["residuals"]
        xmin = canvas_props["xmin"]
        xmax = canvas_props["xmax"]
        xdiv = canvas_props["xdiv"]
        ymin = canvas_props["ymin"]
        ymax = canvas_props["ymax"]
        ydiv = canvas_props["ydiv"]
        resmin = canvas_props["resmin"]
        resmax = canvas_props["resmax"]
        partial_titles = canvas_props["title"].split(";")
        symbol_color = data_props["marker_color"]
        symbol_size = data_props["marker_size"]
        symbol = data_props["marker"]
        curve_color = data_props["curve_color"]
        curve_thickness = data_props["curve_thickness"]
        curve_style = data_props["curve_style"]
        px, py, y_r = None, None, None
        self.canvas.grid = grid
        axis_titles = []
        if len(partial_titles) == 1:
            axis_titles = [
                canvas_props["title"].strip(),
                canvas_props["xaxis"].strip(),
                canvas_props["yaxis"].strip(),
                "",
            ]
        else:
            axis_titles = [
                partial_titles[0].strip(),
                canvas_props["xaxis"].strip(),
                canvas_props["yaxis"].strip(),
                partial_titles[1].strip(),
            ]
        if self.datahandler._has_data:
            # Fitting expression to data, if there"s any expression
            if fit_props["adjust"]:
                if model.exp_model != "":
                    model.fit(wsx=not sigma_x, wsy=not sigma_y)
                else:
                    model.isvalid = False
            else:
                if model.exp_model != "":
                    model.createDummyModel()
                else:
                    model.isvalid = False

            kargs_errorbar = {
                # "ecolor": symbol_color,
                "capsize": 0,
                "elinewidth": 1,
                # "ms": symbol_size,
                "marker": None,
                "ls": "none",
            }

            kargs_scatter = {
                # "c": symbol_color,
                "s": symbol_size**2,
                "marker": symbol,
            }

            # Plotting if the model is valid
            if model.isvalid:
                # Clearing the current plot
                self.canvas.clear_axis()
                # Getting data
                x, y, sy, sx = model.data
                _, outliers = model.inliers, model.outliers
                c = np.array([list(colors.to_rgba(symbol_color))] * len(x))
                try:
                    c[outliers.astype(int), 3] = self.canvas.user_alpha_outliers
                except IndexError:
                    pass
                kargs_errorbar["ecolor"] = c
                kargs_scatter["c"] = c
                y_r = None
                if fit_props["adjust"]:
                    y_r = model.residuo
                else:
                    y_r = model.residuo_dummy
                    # y_ri, y_ro = np.copy(y_r), np.array([])
                if residuals:
                    self.canvas.switch_axes(hide_axes2=False)
                    if sigma_x and sigma_y:  # Caso considerar as duas incertezas
                        ssy = model.predictInc(not sigma_x)
                        self.plot_data(
                            x,
                            y,
                            sy,
                            sx,
                            kargs_errorbar,
                            kargs_scatter,
                            y_r,
                            ssy,
                        )
                    elif (
                        sigma_x is False and sigma_y is False
                    ):  # Caso desconsiderar as duas
                        self.canvas.plot_scatter(x, y, kargs_scatter, y_r)
                    elif sigma_x is False and sigma_y is True:  # Caso considerar só sy
                        ssy = model.predictInc(not sigma_x)
                        sx = np.array([0] * len(x))
                        self.plot_data(
                            x,
                            y,
                            sy,
                            sx,
                            kargs_errorbar,
                            kargs_scatter,
                            y_r,
                            ssy,
                        )
                    else:  # Caso considerar só sx
                        ssy = model.predictInc(not sigma_x, not sigma_y)
                        sy = np.array([0] * len(x))
                        self.plot_data(
                            x,
                            y,
                            sy,
                            sx,
                            kargs_errorbar,
                            kargs_scatter,
                            y_r,
                            ssy,
                        )
                    self.canvas.set_axes_props_with_axes_2(
                        xmin,
                        xmax,
                        xdiv,
                        ymin,
                        ymax,
                        ydiv,
                        resmin,
                        resmax,
                        grid,
                        log_x,
                        log_y,
                    )
                    left, right = self.canvas.axes1.get_xlim()
                    px, py = 0.0, 0.0
                    if log_x:
                        px, py = model.get_predict_log(
                            self.canvas.axes1.figure, left, right
                        )
                    else:
                        px, py = model.get_predict(
                            self.canvas.axes1.figure, left, right
                        )

                    self.canvas.axes2.axline(
                        xy1=(left, 0.0),
                        xy2=(right, 0.0),
                        color=curve_color,
                        alpha=0.65,
                        zorder=0,
                    )

                    # Making Plots
                    (line_func,) = self.canvas.axes1.plot(
                        px,
                        py,
                        lw=curve_thickness,
                        color=curve_color,
                        ls=curve_style,
                        label=f"${model.exp_model}$",
                    )

                    # Setting titles
                    self.canvas.axes1.set_title(
                        axis_titles[0],
                        fontsize=self.canvas.font_sizes["titulo"],
                    )
                    self.canvas.axes2.set_xlabel(
                        xlabel=axis_titles[1],
                        fontsize=self.canvas.font_sizes["eixo_x"],
                    )
                    self.canvas.axes1.set_ylabel(
                        ylabel=axis_titles[2],
                        fontsize=self.canvas.font_sizes["eixo_y"],
                    )
                    self.canvas.axes2.set_ylabel(
                        ylabel=axis_titles[3],
                        fontsize=self.canvas.font_sizes["residuos"],
                    )
                    if legend:
                        self.canvas.axes1.legend(
                            frameon=False,
                            fontsize=self.canvas.font_sizes["legenda"],
                            loc=self.canvas.legend_loc,
                        )

                    def update(evt):
                        left, right = self.canvas.axes1.get_xlim()
                        ppx, ppy = model.get_predict(
                            self.canvas.axes1.figure, left, right
                        )
                        line_func.set_data(ppx, ppy)
                        self.canvas.axes1.figure.canvas.draw_idle()

                    if log_x:

                        def update(evt):
                            left, right = self.canvas.axes1.get_xlim()
                            ppx, ppy = model.get_predict_log(
                                self.canvas.axes1.figure, left, right
                            )
                            line_func.set_data(ppx, ppy)
                            self.canvas.axes1.figure.canvas.draw_idle()

                    self.canvas.axes1.remove_callback(self.canvas.oid)
                    self.canvas.axes1.figure.canvas.mpl_disconnect(self.canvas.cid)
                    self.canvas.oid = self.canvas.axes1.callbacks.connect(
                        "xlim_changed", update
                    )
                    self.canvas.cid = self.canvas.axes1.figure.canvas.mpl_connect(
                        "resize_event", update
                    )
                else:
                    self.canvas.clear_axis()
                    self.canvas.switch_axes(hide_axes2=True)

                    # Making Plots
                    if sigma_x and sigma_y:  # Caso considerar as duas incertezas
                        self.plot_data(x, y, sy, sx, kargs_errorbar, kargs_scatter)
                    elif (
                        sigma_x is False and sigma_y is False
                    ):  # Caso desconsiderar as duas
                        self.canvas.plot_scatter(x, y, kargs_scatter)
                    elif sigma_x is False and sigma_y is True:  # Caso considerar só sy
                        sx = np.array([0] * len(x))
                        self.plot_data(x, y, sy, sx, kargs_errorbar, kargs_scatter)
                    else:  # Caso considerar só sx
                        sy = np.array([0] * len(x))
                        self.plot_data(x, y, sy, sx, kargs_errorbar, kargs_scatter)

                    self.canvas.set_axes_props_without_axes_2(
                        xmin, xmax, xdiv, ymin, ymax, ydiv, grid, log_x, log_y
                    )
                    left, right = self.canvas.axes1.get_xlim()
                    px, py = 0.0, 0.0
                    if log_x:
                        px, py = model.get_predict_log(
                            self.canvas.axes1.figure, left, right
                        )
                    else:
                        px, py = model.get_predict(
                            self.canvas.axes1.figure, left, right
                        )

                    (line_func,) = self.canvas.axes1.plot(
                        px,
                        py,
                        lw=curve_thickness,
                        color=curve_color,
                        ls=curve_style,
                        label=f"${model.exp_model}$",
                        picker=True,
                    )
                    if legend:
                        self.canvas.axes1.legend(
                            frameon=False,
                            fontsize=self.canvas.font_sizes["legenda"],
                            loc=self.canvas.legend_loc,
                        )

                    # Setting titles
                    self.canvas.axes1.set_title(
                        str(axis_titles[0]),
                        fontsize=self.canvas.font_sizes["titulo"],
                    )
                    self.canvas.axes1.set_xlabel(
                        xlabel=str(axis_titles[1]),
                        fontsize=self.canvas.font_sizes["eixo_x"],
                    )
                    self.canvas.axes1.set_ylabel(
                        ylabel=str(axis_titles[2]),
                        fontsize=self.canvas.font_sizes["eixo_y"],
                    )

                    # One piece
                    def update(evt):
                        left, right = self.canvas.axes1.get_xlim()
                        ppx, ppy = model.get_predict(
                            self.canvas.axes1.figure, left, right
                        )
                        line_func.set_data(ppx, ppy)
                        self.canvas.axes1.figure.canvas.draw_idle()

                    if log_x:

                        def update(evt):
                            left, right = self.canvas.axes1.get_xlim()
                            ppx, ppy = model.get_predict_log(
                                self.canvas.axes1.figure, left, right
                            )
                            line_func.set_data(ppx, ppy)
                            self.canvas.axes1.figure.canvas.draw_idle()

                    self.canvas.axes1.remove_callback(self.canvas.oid)
                    self.canvas.axes1.figure.canvas.mpl_disconnect(self.canvas.cid)
                    self.canvas.oid = self.canvas.axes1.callbacks.connect(
                        "xlim_changed", update
                    )
                    self.canvas.cid = self.canvas.figure.canvas.mpl_connect(
                        "resize_event", update
                    )

            else:
                self.canvas.clear_axis()
                self.canvas.switch_axes(hide_axes2=True)

                x, y, sy, sx = self.datahandler.separated_data
                kargs_errorbar["ecolor"] = symbol_color
                kargs_scatter["c"] = symbol_color
                # Making Plots
                if sigma_x and sigma_y:  # Caso considerar as duas incertezas
                    self.plot_data(x, y, sy, sx, kargs_errorbar, kargs_scatter)
                elif (
                    sigma_x is False and sigma_y is False
                ):  # Caso desconsiderar as duas
                    self.canvas.plot_scatter(x, y, kargs_scatter)
                elif sigma_x is False and sigma_y is True:  # Caso considerar só sy
                    sx = np.array([0] * len(x))
                    self.plot_data(x, y, sy, sx, kargs_errorbar, kargs_scatter)
                else:  # Caso considerar só sx
                    sy = np.array([0] * len(x))
                    self.plot_data(x, y, sy, sx, kargs_errorbar, kargs_scatter)

                # Setting titles
                self.canvas.axes1.set_title(
                    str(axis_titles[0]),
                    fontsize=self.canvas.font_sizes["titulo"],
                )
                self.canvas.axes1.set_xlabel(
                    xlabel=str(axis_titles[1]),
                    fontsize=self.canvas.font_sizes["eixo_x"],
                )
                self.canvas.axes1.set_ylabel(
                    ylabel=str(axis_titles[2]),
                    fontsize=self.canvas.font_sizes["eixo_y"],
                )
                self.canvas.set_axes_props_without_axes_2(
                    xmin, xmax, xdiv, ymin, ymax, ydiv, grid, log_x, log_y
                )

        # Reseting parameters
        model.isvalid = False
        self.canvas.canvas.draw_idle()

    def fill_plot_page(self, props=None):
        # If no properties passed, emit the default values
        if props is None:
            self.fill_plot_page_signal.emit(QJsonValue.fromVariant(self.props))
        else:
            self.fill_plot_page_signal.emit(QJsonValue.fromVariant(props))

    @pyqtSlot()
    def new(self):
        # Reseting canvas and model
        self.model.reset()
        self.datahandler.reset()
        # self.canvas.reset()
        self.canvas.clear_axis()
        self.canvas.switch_axes(True)

        # Fill singlePlot page with default values
        self.fill_plot_page()

        # Reseting path
        self.path = ""

    @pyqtSlot(str)
    def load(self, path):
        # Reseting frontend
        self.new()

        # Getting path
        self.path = QUrl(path).toLocalFile()

        # Getting props
        with open(self.path, encoding="utf-8") as file:
            props = json.load(file)

        if "key" in props:
            if props["key"] != "2-b":
                self.msg.raise_warn(
                    "O carregamento de arquivos antigos está limitado à uma versão anterior. Adaptação feita automaticamente."
                )
            if props["key"].split("-")[-1] == "multiplot":
                self.msg.raise_error(
                    "O projeto carregado pertence ao multiplot, esse arquivo é incompatível."
                )
                return 0
            elif props["key"].split("-")[-1] == "hist":
                self.msg.raise_error(
                    "O projeto carregado pertence ao histograma, esse arquivo é incompatível."
                )
                return 0
            # Loading data from the project
            self.datahandler.load_data(df_array=props["data"])
            self.model.data = self.datahandler.data
            self.model._has_sx = self.datahandler.has_sx
            self.model._has_sy = self.datahandler.has_sy

        else:
            try:
                self.msg.raise_warn(
                    "O carregamento de arquivos antigos está limitado à uma versão anterior. Adaptação feita automaticamente."
                )
                props = self.load_old_json(props)
            except Exception as error:
                self.msg.raise_error(
                    f"O arquivo carregado é incompatível com o ATUS.\n{error}"
                )
                return 0
            self.datahandler.load_data(df_array=props["data"])
            self.model.data = self.datahandler.data
            self.model._has_sx = self.datahandler.has_sx
            self.model._has_sy = self.datahandler.has_sy

        self.fill_plot_page(props)

    def load_old_json(self, props):
        props_tmp = self.props.copy()

        # Shaping old json into the new one
        props_tmp["id"] = props["projectName"]
        props_tmp["dataProps"]["marker_color"] = props["symbol_color"]
        props_tmp["dataProps"]["marker_size"] = props["symbol_size"]
        props_tmp["dataProps"]["marker"] = props["symbol"]
        props_tmp["dataProps"]["curve_color"] = props["curve_color"]
        props_tmp["dataProps"]["curve_thickness"] = props["curve_thickness"]
        props_tmp["dataProps"]["curve_style"] = props["curve_style"]
        props_tmp["canvasProps"]["xaxis"] = props["xaxis"]
        props_tmp["canvasProps"]["yaxis"] = props["yaxis"]
        props_tmp["canvasProps"]["title"] = props["title"]
        props_tmp["canvasProps"]["log_x"] = props["log_x"]
        props_tmp["canvasProps"]["log_y"] = props["log_y"]
        props_tmp["canvasProps"]["legend"] = props["legend"]
        props_tmp["canvasProps"]["grid"] = props["grid"]
        props_tmp["canvasProps"]["residuals"] = props["residuals"]
        props_tmp["canvasProps"]["xmin"] = props["xmin"]
        props_tmp["canvasProps"]["xmax"] = props["xmax"]
        props_tmp["canvasProps"]["xdiv"] = props["xdiv"]
        props_tmp["canvasProps"]["ymin"] = props["ymin"]
        props_tmp["canvasProps"]["ymax"] = props["ymax"]
        props_tmp["canvasProps"]["ydiv"] = props["ydiv"]
        props_tmp["canvasProps"]["resmin"] = props["resmin"]
        props_tmp["canvasProps"]["resmax"] = props["resmax"]
        props_tmp["fitProps"]["expr"] = props["expr"]
        props_tmp["fitProps"]["p0"] = props["p0"]
        props_tmp["fitProps"]["wsx"] = props["wsx"]
        props_tmp["fitProps"]["wsy"] = props["wsy"]
        props_tmp["fitProps"]["parameters"] = props["parameters"]
        props_tmp["data"] = pd.read_json(props["data"], dtype=str)

        return props_tmp

    def make_float(self, var, value=0.0):
        try:
            return float(var)
        except Exception:
            return value

    def make_int(self, var, value=0):
        try:
            return int(var)
        except Exception:
            return value

    @pyqtSlot(QJsonValue, result=int)
    def save(self, props):
        # If there"s no path for saving, save_as()
        if self.path == "":
            return 1

        # Getting properties
        props = props.toVariant()
        props["fitProps"]["parameters"] = self.model.params.valuesdict()

        if platform.system() == "Linux":
            if self.path[-5:] == ".json":
                with open(self.path, "w", encoding="utf-8") as file:
                    json.dump(props, file, ensure_ascii=False, indent=4)
            else:
                with open(self.path + ".json", "w", encoding="utf-8") as file:
                    json.dump(props, file, ensure_ascii=False, indent=4)
        else:
            with open(self.path, "w", encoding="utf-8") as file:
                json.dump(props, file, ensure_ascii=False, indent=4)

        return 0

    @pyqtSlot(str, QJsonValue)
    def save_as(self, path, props):
        # Getting path
        self.path = QUrl(path).toLocalFile()

        # Getting properties
        props = props.toVariant()
        props["fitProps"]["parameters"] = self.model.params.valuesdict()

        if platform.system() == "Linux":
            if self.path[-5:] == ".json":
                with open(self.path, "w", encoding="utf-8") as file:
                    json.dump(props, file, ensure_ascii=False, indent=4)
            else:
                with open(self.path + ".json", "w", encoding="utf-8") as file:
                    json.dump(props, file, ensure_ascii=False, indent=4)
        else:
            with open(self.path, "w", encoding="utf-8") as file:
                json.dump(props, file, ensure_ascii=False, indent=4)

    @pyqtSlot(str, str, str, str, str, str)
    def calculator(self, function, opt1, nc, ngl, mean, std):
        function_dict = {
            "Chi²": 0,
            "Chi² Reduzido": 1,
            "Gaussiana": 2,
            "Student": 3,
        }
        method_dict = {
            "Simétrico de Dois Lados": 0,
            "Apenas Limite Inferior": 1,
            "Apenas Limite Superior": 2,
        }
        try:
            nc = nc.replace(",", ".")
            nc = float(nc)
            if nc == 0 or nc >= 1:
                self.msg.raise_error(
                    "Nível de confiança deve ser sempre maior que zero e menor que 1. Rever nível de confiança."
                )
                return None
        except ValueError:
            pass
        try:
            ngl = ngl.replace(",", ".")
            ngl = float(ngl)
        except ValueError:
            pass
        try:
            mean = mean.replace(",", ".")
            mean = float(mean)
        except ValueError:
            pass
        try:
            std = std.replace(",", ".")
            std = float(std)
            if std <= 0:
                self.msg.raise_error(
                    "Desvio padrão deve ser sempre maior que zero. Rever desvio padrão."
                )
                return None
        except ValueError:
            pass

        s, x, y, x_area, y_area, title, xlabel, ylabel = interpreter_calculator(
            function_dict[function], method_dict[opt1], nc, ngl, mean, std
        )
        plot(self.canvas, x, y, x_area, y_area, title, xlabel, ylabel)
        self.write_calculator.emit(s)

    @pyqtSlot(QJsonValue)
    def export_data_clipboard(self, data):
        df = pd.DataFrame.from_records(data.toVariant())

        if df.empty:
            self.msg.raise_warn("Nenhum dado para exportar.")
            return

        df.columns = ["x", "y", "sy", "sx", "bool"]
        del df["bool"]
        df.to_clipboard(index=False)

        self.msg.raise_success("Dados copiados para área de transferência.")
