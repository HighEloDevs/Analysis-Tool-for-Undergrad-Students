from atus.src.DataHandler import DataHandler
import pytest
from unittest.mock import patch, MagicMock
import pandas as pd
from pandas.testing import assert_frame_equal
from copy import deepcopy
from io import StringIO


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
        columns = ["x", "y", "sy", "sx"]
        test_data = [["1,1", "2,2", "3,3", "4,4"], ["5,5", "6,6", "7,7", "8,8"]]
        expected_data = [[1.1, 2.2, 3.3, 4.4], [5.5, 6.6, 7.7, 8.8]]
        test_df = pd.DataFrame(test_data, columns = columns)
        expected = pd.DataFrame(expected_data, columns=columns)
        
        result = data_handler._treat_df(test_df)
        pd.testing.assert_frame_equal(result, expected)

    def test_drop_header(self):
        data_handler = DataHandler()
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
    def four_columns_df(self):
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
        self, four_columns_df, input_columns, other_columns, has_sx, has_sy
    ):
        data_handler = DataHandler()
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
    def test_load_by_data_path(self, mock_tsv: MagicMock, mock_csv: MagicMock):
        data_handler = DataHandler()
        test_string = "arquivo.csv"
        data_handler._load_by_data_path(test_string)
        mock_csv.assert_called_once()
        mock_tsv.assert_not_called()
        test_string = "arquivo.tsv"
        data_handler._load_by_data_path(test_string)
        mock_tsv.assert_called_once()
        mock_csv.assert_called_once()

