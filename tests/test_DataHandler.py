from atus.src.DataHandler import DataHandler
import pytest
from unittest.mock import patch, MagicMock
import pandas as pd
from pandas.testing import assert_frame_equal

from pytest import fixture


@pytest.mark.data_handler
class TestDataHandler:
    # @pytest.fixture
    # def data_handler():
    #     return DataHandler()

    @pytest.mark.parametrize(
        "test_input, expected", [(1, True), (1.0, True), ("1", True), ("a", False)]
    )
    def test_is_number(self, test_input, expected):
        data_handler = DataHandler()
        assert data_handler._is_number(test_input) == expected

    def test_fill_df_with_array(self):
        data_handler = DataHandler()
        df_array = [["1", "2", "3", "4", True], ["5", "6", "7", "8", True]]
        data_handler._fill_df_with_array(df_array)
        assert isinstance(data_handler._df, pd.DataFrame)

    def test_treat_df(self):
        data_handler = DataHandler()
        test_df = pd.DataFrame(
            {
                "x": ["1,1", "2,2", "3,3"],
                "y": ["4,4", "5,5", "6,6"],
                "sy": ["7,7", "8,8", "9,9"],
                "sx": ["10,10", "11,11", "12,12"],
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
        result = data_handler._treat_df(test_df)
        pd.testing.assert_frame_equal(result, expected)

    def test_drop_header(self):
        data_handler = DataHandler()
        test = pd.DataFrame(
            {
                "x":  ["a", "1.1", "2.2", "3.3"],
                "y":  ["a", "4.4", "5.5", "6.6"],
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

    def _test_to_check_columns(self):
        pass

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


