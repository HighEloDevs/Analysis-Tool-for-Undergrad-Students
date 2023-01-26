from atus.src.DataHandler import DataHandler
import pytest
from unittest.mock import patch, MagicMock
import pandas as pd
from pandas.testing import assert_frame_equal
from copy import deepcopy
from io import StringIO
from PyQt5.QtCore import QUrl
import os
import tempfile
from atus.src.MessageHandler import MessageHandler

# import codecs


@pytest.mark.data_handler
class TestDataHandler:
    @pytest.fixture
    def data_handler(self):
        messageHandler = MessageHandler()
        return DataHandler(messageHandler)

    def test_reset(self, data_handler: DataHandler):
        data_handler._data = pd.DataFrame([1])
        data_handler._data_json = pd.DataFrame(["1"])
        data_handler._has_data = True
        data_handler._has_sx = False
        data_handler._has_sy = False
        data_handler.reset()
        assert data_handler._data == None
        assert data_handler._data_json == None
        assert data_handler._has_data == False
        assert data_handler._has_sx == True
        assert data_handler._has_sy == True

    @pytest.mark.parametrize(
        "test_input, expected", [(1, True), (1.0, True), ("1", True), ("a", False)]
    )
    def test_is_number(self, test_input, expected, data_handler: DataHandler):
        assert data_handler._is_number(test_input) == expected

    def test_read_csv(self, data_handler: DataHandler):

        with tempfile.TemporaryDirectory() as tmpdir:
            data_path = os.path.join(tmpdir, "test.csv")
            with open(data_path, "w") as f:
                f.write("1,2,3,4\n5,6,7,8\n9,10,11,12")
            data_handler._read_csv(data_path)
        df = pd.DataFrame(
            [["1", "2", "3", "4"], ["5", "6", "7", "8"], ["9", "10", "11", "12"]],
            columns=["x", "y", "sy", "sx"],
        )
        pd.testing.assert_frame_equal(data_handler._df, df)

        data_handler._msg_handler.raise_error = MagicMock()
        with tempfile.TemporaryDirectory() as tmpdir:
            data_path = os.path.join(tmpdir, "test.csv")
            test_data = "1,2,3\n4,5,6,7\n8,9,1"
            message = "Separação de colunas de arquivos csv são com vírgula (','). Rever dados de entrada."
            with open(data_path, "w") as f:
                f.write(test_data)
            data_handler._read_csv(data_path)
        data_handler._msg_handler.raise_error.assert_called_once_with(message)

        # with tempfile.TemporaryDirectory() as tmpdir:
        #     data_path = os.path.join(tmpdir, "test.csv")
        #     test_data = test_data.encode("utf-8").decode("ISO-8859-1", "ignore")
        #     message = "O encoding do arquivo é inválido. Use o utf-8."
        #     with open(data_path, "w") as f:
        #         f.write(test_data)
        #     data_handler._read_csv(data_path)
        # data_handler._msg_handler.raise_error.assert_called_with(message)

    def test_read_tsv(self, data_handler: DataHandler):
        with tempfile.TemporaryDirectory() as tmpdir:
            data_path = os.path.join(tmpdir, "test.tsv")
            with open(data_path, "w") as f:
                f.write("1\t2\t3\t4\n5\t6\t7\t8\n9\t10\t11\t12")
            data_handler._read_tsv_txt(data_path)
        df = pd.DataFrame(
            [["1", "2", "3", "4"], ["5", "6", "7", "8"], ["9", "10", "11", "12"]],
            columns=["x", "y", "sy", "sx"],
        )
        pd.testing.assert_frame_equal(data_handler._df, df)

        data_handler._msg_handler.raise_error = MagicMock()
        with tempfile.TemporaryDirectory() as tmpdir:
            data_path = os.path.join(tmpdir, "test.csv")
            test_data = "1\t2\t3\n4\t5\t6\t7\n8\t9\t1"
            message = "Separação de colunas de arquivos txt e tsv são com tab. Rever dados de entrada."
            with open(data_path, "w") as f:
                f.write(test_data)
            data_handler._read_tsv_txt(data_path)
        data_handler._msg_handler.raise_error.assert_called_once_with(message)

    def test_fill_df_with_array(self, data_handler: DataHandler):

        df_array = [["1", "2", "3", "4", True], ["5", "6", "7", "8", True]]
        columns = ["x", "y", "sy", "sx"]
        expected_data = [["1", "2", "3", "4"], ["5", "6", "7", "8"]]
        df = pd.DataFrame(expected_data, columns=columns)
        data_handler._fill_df_with_array(df_array)
        pd.testing.assert_frame_equal(data_handler._df, df)

    # @pytest.mark.parametrize(
    #     "data,message",
    #     [
    #         ([["1", "2", 0, "0", True], ["5", "6", "7", "8", True]],"Um valor nulo foi encontrado nas incertezas em y, removendo coluna de sy."),

    #     ],
    # )
    # def test_fill_df_with_array_sig_zero(self,data_handler: DataHandler,data,message):
    #
    #     data_handler._msg_handler.raise_error = MagicMock()
    #     data_handler._fill_df_with_array(data)
    #     data_handler._msg_handler.raise_error.assert_called_once_with(message)

    def test_treat_df(self, data_handler: DataHandler):

        columns = ["x", "y", "sy", "sx"]
        test_data = [["1,1", "2,2", "3,3", "4,4"], ["5,5", "6,6", "7,7", "8,8"]]
        expected_data = [[1.1, 2.2, 3.3, 4.4], [5.5, 6.6, 7.7, 8.8]]
        test_df = pd.DataFrame(test_data, columns=columns)
        expected = pd.DataFrame(expected_data, columns=columns)
        result = data_handler._treat_df(test_df)
        pd.testing.assert_frame_equal(result, expected)

    def test_drop_header(self, data_handler: DataHandler):

        test = pd.DataFrame(
            {
                "x": ["a", "1.1", "2.2", "3.3"],
                "y": ["a", "4.4", "5.5", "6.6"],
                "sy": ["1", "7.7", "8.8", "9.9"],
                "sx": ["a", "10.10", "11.11", "12.12"],
            }
        )
        expected = pd.DataFrame(
            {
                "x": ["1.1", "2.2", "3.3"],
                "y": ["4.4", "5.5", "6.6"],
                "sy": ["7.7", "8.8", "9.9"],
                "sx": ["10.10", "11.11", "12.12"],
            }
        )
        result = data_handler._drop_header(test)
        pd.testing.assert_frame_equal(result, expected)

    @pytest.fixture
    def four_columns_df(self, data_handler: DataHandler):
        data = [[1, 2, 3, 4], [5, 6, 7, 8]]
        columns = ["x", "y", "sy", "sx"]
        return pd.DataFrame(data, columns=columns)

    @pytest.mark.parametrize(
        "input_columns,other_columns,has_sy,has_sx",
        [
            (["x"], {"x": [0.0, 1.0], "y": [1, 5], "sy": 0.0, "sx": 0.0}, False, False),
            (["x", "y"], {"sy": 0.0, "sx": 0.0}, False, False),
            (["x", "y", "sy"], {"sx": 0.0}, True, False),
            (["x", "y", "sy", "sx"], {}, True, True),
        ],
    )
    def test_to_check_columns(
        self,
        data_handler: DataHandler,
        four_columns_df,
        input_columns,
        other_columns,
        has_sx,
        has_sy,
    ):

        data_handler._df = four_columns_df[input_columns]
        data_handler._data_json = deepcopy(data_handler._df)
        data_handler._to_check_columns()
        expected_df = deepcopy(four_columns_df)

        for col in other_columns.keys():
            expected_df[col] = other_columns[col]

        result_df = data_handler._df

        pd.testing.assert_frame_equal(result_df, expected_df)
        assert data_handler._has_sx == has_sx
        assert data_handler._has_sy == has_sy

    @patch("atus.src.DataHandler.DataHandler._read_csv")
    @patch("atus.src.DataHandler.DataHandler._read_tsv_txt")
    def test_load_by_data_path(
        self, mock_tsv: MagicMock, mock_csv: MagicMock, data_handler: DataHandler
    ):

        test_string = "arquivo.csv"
        data_handler._load_by_data_path(test_string)
        mock_csv.assert_called_once()
        mock_tsv.assert_not_called()
        test_string = "arquivo.tsv"
        data_handler._load_by_data_path(test_string)
        mock_tsv.assert_called_once()
        mock_csv.assert_called_once()

    def test_load_data(self, data_handler: DataHandler):

        data_handler._treat_df = MagicMock()

        clipboardText = "1\t2\t3\t4\n5\t6\t7\t8"
        data_handler._fill_df_with_clipboardText = MagicMock()
        data_handler.load_data(clipboardText=clipboardText)
        data_handler._fill_df_with_clipboardText.assert_called_once_with(clipboardText)

        data_path = r"file:///C:/User"
        data_handler._load_by_data_path = MagicMock()
        data_handler.load_data(data_path=data_path)
        data_handler._load_by_data_path.assert_called_once_with(
            QUrl(data_path).toLocalFile()
        )

        df_array = [["1", "2", "3", "4", True], ["5", "6", "7", "8", True]]
        data_handler._fill_df_with_array = MagicMock()
        data_handler.load_data(df_array=df_array)
        data_handler._fill_df_with_array.assert_called_once_with(df_array)