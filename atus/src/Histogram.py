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
from matplotlib.ticker import MaxNLocator
import pandas as pd
import numpy as np
import platform
import json


class Histogram(QObject):
    """Backend for histogram page"""

    # Signals
    fillPage = pyqtSignal(QJsonValue)

    def __init__(self, canvas, messageHandler) -> None:
        super().__init__()
        self.messageHandler = messageHandler
        self.canvas = canvas
        self.path = ""
        self.histAlign = {"Centro": "mid", "Direita": "right", "Esquerda": "left"}
        self.histOrient = {"Vertical": "vertical", "Horizontal": "horizontal"}

    @pyqtSlot(QJsonValue)
    def plot(self, data):
        """TODO: Docstring for histogram plot."""
        data = QJsonValue.toVariant(data)
        self.canvas.set_tight_layout()
        self.canvas.clear_axis()
        self.canvas.switch_axes(hide_axes2=True)

        xdiv = data["props"]["xdiv"]
        xmin = data["props"]["xmin"]
        xmax = data["props"]["xmax"]
        ydiv = data["props"]["ydiv"]
        ymin = data["props"]["ymin"]
        ymax = data["props"]["ymax"]

        self.canvas.grid = data["props"]["grid"]

        self.canvas.axes1.yaxis.set_major_locator(MaxNLocator(integer=True))

        has_legend = False
        for arquivo in data["data"]:
            if arquivo["visible"]:
                if data["props"]["histMode"] == "Frequência absoluta":
                    has_legend = self.plot_freq_abs(arquivo, data, has_legend)
                elif data["props"]["histMode"] == "Frequência relativa":
                    has_legend = self.plot_freq_rel(arquivo, data, has_legend)
                else:
                    has_legend = self.plot_dens(arquivo, data, has_legend)
        self.canvas.axes1.set_title(
            data["props"]["title"], fontsize=self.canvas.font_sizes["titulo"]
        )
        self.canvas.axes1.set_xlabel(
            xlabel=data["props"]["xaxis"], fontsize=self.canvas.font_sizes["eixo_x"]
        )
        self.canvas.axes1.set_ylabel(
            ylabel=data["props"]["yaxis"], fontsize=self.canvas.font_sizes["eixo_y"]
        )
        self.canvas.set_axes_props_without_axes_2(
            xmin,
            xmax,
            xdiv,
            ymin,
            ymax,
            ydiv,
            data["props"]["grid"],
            data["props"]["logx"],
            data["props"]["logy"],
        )
        if has_legend:
            self.canvas.axes1.legend()
        self.canvas.canvas.draw_idle()

    def plot_freq_abs(self, arquivo, data, has_legend):
        df = pd.DataFrame.from_dict(json.loads(arquivo["data"]))
        alpha = self.make_float(arquivo["kargs"].pop("alpha"), 1.0)
        label = arquivo["kargs"].pop("label")
        left = self.make_float(arquivo["kargs"].pop("rangexmin", ""), df["x"].min())
        right = self.make_float(arquivo["kargs"].pop("rangexmax", ""), df["x"].max())
        if left >= right:
            self.messageHandler.raise_error(
                "Intervalo de bins inválido. Rever intervalo de bins."
            )
            return -1
        bins = np.linspace(
            left, right, self.make_int(arquivo["kargs"].pop("nbins", 10), 10) + 1
        )
        counts = None
        if arquivo["legend"] == "":
            counts, bins, _ = self.canvas.axes1.hist(
                x=df["x"],
                bins=bins,
                density=False,
                cumulative=False,
                bottom=0,
                histtype=data["props"]["histType"],
                align=self.histAlign[data["props"]["histAlign"]],
                orientation=self.histOrient[data["props"]["histOrientation"]],
                log=False,
                rwidth=1,
                capstyle="round",
                ls="-",
                aa=True,
                alpha=alpha,
                **arquivo["kargs"],
            )
        else:
            counts, bins, _ = self.canvas.axes1.hist(
                x=df["x"],
                bins=bins,
                density=False,
                cumulative=False,
                bottom=0,
                histtype=data["props"]["histType"],
                align=self.histAlign[data["props"]["histAlign"]],
                orientation=self.histOrient[data["props"]["histOrientation"]],
                log=False,
                rwidth=1,
                capstyle="round",
                ls="-",
                aa=True,
                alpha=alpha,
                label=arquivo["legend"],
                **arquivo["kargs"],
            )
            has_legend = True
        if label:
            if data["props"]["histOrientation"] == "Vertical":
                bottom, top = self.canvas.axes1.get_ylim()
                height = top - bottom
                c = (bins[1] - bins[0]) / 2
                for n, b in zip(counts, bins):
                    if n != 0:
                        self.canvas.axes1.text(
                            b + c, n + height * 0.02, str(n), ha="center"
                        )
            else:
                left, right = self.canvas.axes1.get_xlim()
                dif = right - left
                c = (bins[1] - bins[0]) / 2
                for n, b in zip(counts, bins):
                    if n != 0:
                        self.canvas.axes1.text(
                            n + dif * 0.02, b + c, str(n), ha="center"
                        )
        return has_legend

    def plot_freq_rel(self, arquivo, data, has_legend):
        df = pd.DataFrame.from_dict(json.loads(arquivo["data"]))
        alpha = self.make_float(arquivo["kargs"].pop("alpha"), 1.0)
        label = arquivo["kargs"].pop("label")
        left = self.make_float(arquivo["kargs"].pop("rangexmin", ""), df["x"].min())
        right = self.make_float(arquivo["kargs"].pop("rangexmax", ""), df["x"].max())
        if left >= right:
            self.messageHandler.raise_error(
                "Intervalo de bins inválido. Rever intervalo de bins."
            )
            return -1
        bins = np.linspace(
            left, right, self.make_int(arquivo["kargs"].pop("nbins", 10), 10) + 1
        )
        counts = None
        if arquivo["legend"] == "":
            counts, bins, _ = self.canvas.axes1.hist(
                x=df["x"],
                bins=bins,
                weights=np.ones_like(df["x"]) / len(df["x"]),
                density=False,
                cumulative=False,
                bottom=0,
                histtype=data["props"]["histType"],
                align=self.histAlign[data["props"]["histAlign"]],
                orientation=self.histOrient[data["props"]["histOrientation"]],
                log=False,
                rwidth=1,
                capstyle="round",
                ls="-",
                aa=True,
                alpha=alpha,
                **arquivo["kargs"],
            )
        else:
            counts, bins, _ = self.canvas.axes1.hist(
                x=df["x"],
                bins=bins,
                weights=np.ones_like(df["x"]) / len(df["x"]),
                density=False,
                cumulative=False,
                bottom=0,
                histtype=data["props"]["histType"],
                align=self.histAlign[data["props"]["histAlign"]],
                orientation=self.histOrient[data["props"]["histOrientation"]],
                log=False,
                rwidth=1,
                capstyle="round",
                ls="-",
                aa=True,
                alpha=alpha,
                label=arquivo["legend"],
                **arquivo["kargs"],
            )
            has_legend = True
        if label:
            if data["props"]["histOrientation"] == "Vertical":
                bottom, top = self.canvas.axes1.get_ylim()
                height = top - bottom
                c = (bins[1] - bins[0]) / 2
                for n, b in zip(counts, bins):
                    if n != 0:
                        self.canvas.axes1.text(
                            b + c, n + height * 0.02, f"{n:.3g}", ha="center"
                        )
            else:
                left, right = self.canvas.axes1.get_xlim()
                dif = right - left
                c = (bins[1] - bins[0]) / 2
                for n, b in zip(counts, bins):
                    if n != 0:
                        self.canvas.axes1.text(
                            n + dif * 0.02, b + c, f"{n:.3g}", ha="center"
                        )
        return has_legend

    def plot_dens(self, arquivo, data, has_legend):
        df = pd.DataFrame.from_dict(json.loads(arquivo["data"]))
        alpha = self.make_float(arquivo["kargs"].pop("alpha"), 1.0)
        label = arquivo["kargs"].pop("label")
        left = self.make_float(arquivo["kargs"].pop("rangexmin", ""), df["x"].min())
        right = self.make_float(arquivo["kargs"].pop("rangexmax", ""), df["x"].max())
        if left >= right:
            self.messageHandler.raise_error(
                "Intervalo de bins inválido. Rever intervalo de bins."
            )
            return -1
        bins = np.linspace(
            left, right, self.make_int(arquivo["kargs"].pop("nbins", 10), 10) + 1
        )
        counts = None
        if arquivo["legend"] == "":
            counts, bins, _ = self.canvas.axes1.hist(
                x=df["x"],
                bins=bins,
                density=True,
                cumulative=False,
                bottom=0,
                histtype=data["props"]["histType"],
                align=self.histAlign[data["props"]["histAlign"]],
                orientation=self.histOrient[data["props"]["histOrientation"]],
                log=False,
                rwidth=1,
                capstyle="round",
                ls="-",
                aa=True,
                alpha=alpha,
                **arquivo["kargs"],
            )
        else:
            counts, bins, _ = self.canvas.axes1.hist(
                x=df["x"],
                bins=bins,
                density=True,
                cumulative=False,
                bottom=0,
                histtype=data["props"]["histType"],
                align=self.histAlign[data["props"]["histAlign"]],
                orientation=self.histOrient[data["props"]["histOrientation"]],
                log=False,
                rwidth=1,
                capstyle="round",
                ls="-",
                aa=True,
                alpha=alpha,
                label=arquivo["legend"],
                **arquivo["kargs"],
            )
            has_legend = True
        if label:
            if data["props"]["histOrientation"] == "Vertical":
                bottom, top = self.canvas.axes1.get_ylim()
                height = top - bottom
                c = (bins[1] - bins[0]) / 2
                for n, b in zip(counts, bins):
                    if n != 0:
                        self.canvas.axes1.text(
                            b + c, n + height * 0.02, f"{n:.3g}", ha="center"
                        )
            else:
                left, right = self.canvas.axes1.get_xlim()
                dif = right - left
                c = (bins[1] - bins[0]) / 2
                for n, b in zip(counts, bins):
                    if n != 0:
                        self.canvas.axes1.text(
                            n + dif * 0.02, b + c, f"{n:.3g}", ha="center"
                        )
        return has_legend

    @pyqtSlot()
    def new(self):
        self.path = ""
        self.fillPage.emit(None)
        self.canvas.clear_axis()
        self.canvas.switch_axes(True)

    @pyqtSlot(QJsonValue, result=bool)
    def save(self, data):
        # If there's no path for saving, save_as()
        if self.path == "":
            return False

        # Getting properties
        data = data.toVariant()

        if platform.system() == "Linux":
            if self.path[-5:] == ".json":
                with open(self.path, "w", encoding="utf-8") as file:
                    json.dump(data, file, ensure_ascii=False, indent=4)
            else:
                with open(self.path + ".json", "w", encoding="utf-8") as file:
                    json.dump(data, file, ensure_ascii=False, indent=4)
        else:
            with open(self.path, "w", encoding="utf-8") as file:
                json.dump(data, file, ensure_ascii=False, indent=4)

        return True

    @pyqtSlot(str, QJsonValue)
    def save_as(self, path, data):
        # Getting path
        self.path = QUrl(path).toLocalFile()
        self.save(data)

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
            if props["key"].split("-")[-1] != "hist":
                self.messageHandler.raise_error(
                    "Este projeto pertence à outra aba do ATUS."
                )
                return 0
            if props["key"][0] == "2":
                self.messageHandler.raise_warn(
                    "Arquivo da versão anterior. Procure salvar o arquivo nesta versão para evitar problemas."
                )
        else:
            self.messageHandler.raise_error(
                "O arquivo carregado é incompatível com o ATUS."
            )
            return 0

        self.fillPage.emit(QJsonValue.fromVariant(props))

    @pyqtSlot(str, result=QJsonValue)
    def check_data(self, filePath):
        """
        Check if data is valid
        Returns: True + Data if valid data, False otherwise
        """
        package = {"isValid": False, "data": None}
        # Loading from .csv or (.txt and .tsv)
        filePath = QUrl(filePath).toLocalFile()
        if filePath[-3:] == "csv":
            try:
                df = pd.read_csv(filePath, sep=",", header=None, dtype=str).replace(
                    np.nan, "0"
                )
            except pd.errors.ParserError:
                self.messageHandler.raise_error(
                    "Separação de colunas de arquivos csv são com vírgula (",
                    "). Rever dados de entrada.",
                )
                # Separação de colunas de arquivos csv são com vírgula (","). Rever dados de entrada.
                return QJsonValue.fromVariant(package)
        elif filePath[-3:] == "tsv" or filePath[-3:] == "txt":
            try:
                df = pd.read_csv(filePath, sep="\t", header=None, dtype=str).replace(
                    np.nan, "0"
                )
            except pd.errors.ParserError:
                self.messageHandler.raise_error(
                    "Separação de colunas de arquivos txt e tsv são com tab. Rever dados de entrada."
                )
                # Separação de colunas de arquivos txt e tsv são com tab. Rever dados de entrada.
                return QJsonValue.fromVariant(package)
        else:
            self.messageHandler.raise_error(
                "Apenas arquivos .txt, .csv, .tsv são suportados."
            )
            return QJsonValue.fromVariant(package)

        if len(df.columns) == 1:
            df.columns = ["x"]
        else:
            self.messageHandler.raise_error(
                "A tabela de histogramas deve conter no máximo 1 coluna."
            )
            return QJsonValue.fromVariant(package)

        for i in df.columns:
            # Replacing comma for dots
            df[i] = [x.replace(",", ".") for x in df[i]]
            # Converting everything to float
            try:
                df[i] = df[i].astype(float)
            except:
                self.messageHandler.raise_error(
                    "A entrada de dados só permite entrada de números. Rever arquivo de entrada."
                )
                # Há células não numéricas. A entrada de dados só permite entrada de números. Rever arquivo de entrada.
                return QJsonValue.fromVariant(package)

        package["data"] = df.to_json()
        package["isValid"] = True
        return package

    def make_float(self, var, value):
        try:
            return float(var)
        except:
            return value

    def make_int(self, var, value):
        try:
            return int(var)
        except:
            return value
