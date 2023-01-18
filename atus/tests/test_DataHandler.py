import os
import sys
import inspect
# getting parent directory
currentdir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parentdir = os.path.dirname(currentdir)
# This will insert the path of the parent directory at the 0th position in the search path
# This allows the current file to import modules from the parent directory.
from src.DataHandler import DataHandler
sys.path.insert(0, currentdir)
from pytest import mark
import pandas as pd


from pytest import fixture
import os



@fixture
def data_handler():
    return DataHandler()

class TestDataHandler:
    def test_is_number(data_handler):
        assert data_handler._is_number(1) == True
        assert data_handler._is_number(1.0) == True
        assert data_handler._is_number("1") == True
        assert data_handler._is_number("a") == False


    def test_fill_df_with_array(data_handler):
        df_array = [["1", "2", "3", "4", True], ["5", "6", "7", "8", True]]
        data_handler._fill_df_with_array(df_array)
        assert isinstance(data_handler._df, pd.DataFrame)



    def test_load_by_data_path(data_handler):
        data_handler._load_by_data_path('C:\Users\abelh\OneDrive\Área de Trabalho\txts-atus\teste1')
        assert isinstance(data_handler._df, pd.DataFrame)
