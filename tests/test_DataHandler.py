from atus.src.DataHandler import DataHandler
import pytest
from unittest.mock import patch, MagicMock
import pandas as pd


@pytest.mark.data_handler
class TestDataHandler:
    # @fixture
    # def data_handler():
    #     return DataHandler()

    def test_is_number(self):
        data_handler = DataHandler()
        assert data_handler._is_number(1) == True
        assert data_handler._is_number(1.0) == True
        assert data_handler._is_number("1") == True
        assert data_handler._is_number("a") == False

    def test_fill_df_with_array(self):
        data_handler = DataHandler()
        df_array = [["1", "2", "3", "4", True], ["5", "6", "7", "8", True]]
        data_handler._fill_df_with_array(df_array)
        assert isinstance(data_handler._df, pd.DataFrame)

    # def test_load_by_data_path(self, data_handler):
    #     data_handler._load_by_data_path(
    #         r"C:\Users\abelh\OneDrive\Área de Trabalho\txts-atus\teste1"
    #     )
    #     assert isinstance(data_handler._df, pd.DataFrame)

    @patch("atus.src.DataHandler.DataHandler._read_csv")
    @patch("atus.src.DataHandler.DataHandler._read_tsv_txt")
    def test_load_by_data_path(self, mock_tsv: MagicMock, mock_csv: MagicMock):
        dh = DataHandler()
        test_string = "arquivo.csv"
        dh._load_by_data_path(test_string)
        mock_csv.assert_called_once()
        mock_tsv.assert_not_called()
        test_string = "arquivo.tsv"
        dh._load_by_data_path(test_string)
        mock_tsv.assert_called_once()
        mock_csv.assert_called_once()
