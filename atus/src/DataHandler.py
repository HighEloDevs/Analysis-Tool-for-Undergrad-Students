import numpy as np
import pandas as pd
from PyQt5.QtCore import (
    QObject,
    QJsonValue,
    QUrl,
    QVariant,
    pyqtSignal,
    pyqtSlot,
)
from copy import deepcopy
from .MessageHandler import MessageHandler
from PyQt5.QtGui import QGuiApplication
from io import StringIO


# data_handler
class DataHandler(QObject):
    # Signals
    uploadData = pyqtSignal(QVariant, str, arguments=["data", "fileName"])

    def __init__(self):
        super().__init__()
        self._msg_handler: MessageHandler = MessageHandler()
        self._df = None
        self._data_json = None
        self._has_sx = True
        self._has_sy = True
        self._has_data = False
        self._data = None

    def _is_number(self, s):
        try:
            float(s)
            return True
        except ValueError:
            return False

    def _read_csv(self, data_path):
        try:
            self._df = (
                pd.read_csv(data_path, sep=",", header=None, dtype=str)
                .dropna(how="all")
                .replace(np.nan, "0")
            )

        except pd.errors.ParserError:
            self._msg_handler.raise_error(
                "Separação de colunas de arquivos csv são com vírgula (','). Rever dados de entrada."
            )
            return None

        except UnicodeDecodeError:
            self._msg_handler.raise_error(
                "O encoding do arquivo é inválido. Use o utf-8."
            )
            return None

    def _read_tsv_txt(self, data_path):
        try:
            self._df = (
                pd.read_csv(data_path, sep="\t|s", header=None, dtype=str)
                .dropna(how="all")
                .replace(np.nan, "0")
            )
        except pd.errors.ParserError:

            self._msg_handler.raise_error(
                "Separação de colunas de arquivos txt e tsv são com tab. Rever dados de entrada."
            )
            return None

    def _fill_df_with_array(self, df_array):
        self._df = pd.DataFrame.from_records(
            df_array, columns=["x", "y", "sy", "sx", "bool"]
        )
        del self._df["bool"]
        uniqueSi = self._df["sy"].unique().astype(float)
        if 0.0 in uniqueSi:
            if len(uniqueSi) > 1:
                self._msg_handler.raise_warn(
                    "Um valor nulo foi encontrado nas incertezas em y, removendo coluna de sy."
                )
            self._has_sy = False
        uniqueSi = self._df["sx"].unique().astype(float)
        if 0.0 in uniqueSi:
            if len(uniqueSi) > 1:
                self._msg_handler.raise_warn(
                    "Um valor nulo foi encontrado nas incertezas em x, removendo coluna de sx."
                )
            self._has_sx = False

    def _df_filters(self):
        self._data_json = deepcopy(self._df)
        # Applying some filters over the df
        for i in self._df.columns:
            # Replacing comma for dots
            self._df[i] = [x.replace(",", ".") for x in self._df[i]]
            self._data_json[i] = [x.replace(",", ".") for x in self._data_json[i]]

            if self._is_number(self._df[i].iloc[0]) is False:
                self._df.drop(0, inplace=True)
                self._data_json.drop(0, inplace=True)
                self._df.index = range(len(self._df))
                self._data_json.index = range(len(self._data_json))
            try:
                self._df[i] = self._df[i].astype(float)
            except ValueError:
                self._msg_handler.raise_error(
                    "A entrada de dados só permite entrada de números. Rever arquivo de entrada."
                )
                return None

    def _to_name_columns(self):
        number_of_cols = len(self._df.columns)
        if number_of_cols == 1:
            self._has_sy = not self._has_sy
            self._has_sx = not self._has_sx
            self._df["x"] = np.arange(len(self._df), dtype=float)
            self._data_json = deepcopy(self._df.astype(str))
            self._data_json.columns = ["y", "x"]
            self._df["sy"] = 0.0
            self._df["sx"] = 0.0
        elif number_of_cols == 2:
            self._has_sy = not self._has_sy
            self._has_sx = not self._has_sx
            self._data_json.columns = ["x", "y"]
            self._df["sy"] = 0.0
            self._df["sx"] = 0.0
        elif number_of_cols == 3:
            self._has_sx = not self._has_sx
            self._data_json.columns = ["x", "y", "sy"]
            self._df["sx"] = 0.0

        else:  # number of cols == 4
            try:
                self._data_json.columns = ["x", "y", "sy", "sx"]

                unique_sy = self._data_json["sy"].unique().astype(float)
                if 0.0 in unique_sy:
                    if len(unique_sy) > 1:
                        self._msg_handler.raise_warn(
                            "Um valor nulo foi encontrado nas incertezas em y, removendo coluna de sy."
                        )
                    self._has_sy = False
                unique_sx = self._data_json["sx"].unique().astype(float)
                if 0.0 in unique_sx:
                    if len(unique_sx) > 1:
                        self._msg_handler.raise_warn(
                            "Um valor nulo foi encontrado nas incertezas em x, removendo coluna de sx."
                        )
                    self._has_sx = False

            except ValueError:
                self._msg_handler.raise_error(
                    "Há mais do que 4 colunas. Rever entrada de dados."
                )
                return None

    def _load_by_data_path(self, data_path):
        if data_path[-3:] == "csv":
            self._read_csv(data_path)
        else:
            self._read_tsv_txt(data_path)

    @pyqtSlot(str)
    def load_data(self, data_path="", df_array=None):
        fileName = "Dados Carregados do Projeto"
        if len(data_path) > 0:
            # Loading from .csv or (.txt and .tsv)
            data_path = QUrl(data_path).toLocalFile()
            self._load_by_data_path(data_path)
            fileName = data_path.split("/")[-1]

        elif df_array is not None:
            self._fill_df_with_array(df_array)

        self._df_filters()
        self._to_name_columns()
        self._data = deepcopy(self._df)
        self._has_data = True
        self.uploadData.emit(self._data_json.to_dict(orient="list"), fileName)

    @pyqtSlot(QJsonValue)
    def loadDataTable(self, data=None):
        """Getting data from table."""
        self._df = pd.DataFrame.from_records(
            data, columns=["x", "y", "sy", "sx", "bool"]
        )

        # Removing not chosen rows
        self._df = self._df[self._df["bool"] == 1]
        del self._df["bool"]
        uniqueSi = self._df["sy"].unique().astype(float)
        if 0.0 in uniqueSi:
            if len(uniqueSi) > 1:
                self._msg_handler.raise_warn(
                    "Um valor nulo foi encontrado nas incertezas em y, removendo coluna de sy."
                )
            self._has_sy = False
        uniqueSi = self._df["sx"].unique().astype(float)
        if 0.0 in uniqueSi:
            if len(uniqueSi) > 1:
                self._msg_handler.raise_warn(
                    "Um valor nulo foi encontrado nas incertezas em x, removendo coluna de sx."
                )
            self._has_sx = False

        self._data_json = deepcopy(self._df)

        # Turn everything into number (str -> number)
        self._df = self._df.astype(float)
        self._data = deepcopy(self._df)
        self._has_data = True

    @pyqtSlot()
    def loadDataClipboard(self):
        """Pega a tabela de dados do Clipboard."""
        # Instantiating clipboard
        clipboard = QGuiApplication.clipboard()
        clipboardText = clipboard.mimeData().text()
        # try:
        # Creating a dataframe from the string
        df = (
            pd.read_csv(StringIO(clipboardText), sep="\t", header=None, dtype=str)
            .dropna(how="all")
            .replace(np.nan, "0")
        )
        # Replacing all commas for dots
        for i in df.columns:
            df[i] = [x.replace(",", ".") for x in df[i]]
            df[i] = df[i].astype(str)
        self._df = df
        self.load_data()

    @property
    def data(self): #só data
        return self._data

    @property
    def separated_data(self):
        """Retorna x, y, sx e sy."""
        return (
            self._data["x"],
            self._data["y"],
            self._data["sy"],
            self._data["sx"],
        )

    @property
    def has_sx(self):
        return self._has_sx

    @property
    def has_sy(self):
        return self._has_sy