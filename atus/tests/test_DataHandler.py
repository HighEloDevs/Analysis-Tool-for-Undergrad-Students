import os
import sys
import inspect
currentdir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parentdir = os.path.dirname(currentdir)
sys.path.insert(0, parentdir)
from src.DataHandler import DataHandler
import pytest
from pytest import mark



class TestClass:
    def test_is_number(self):
        input = 2
        espected = True
        result = DataHandler()._is_number(input)
        assert result == espected
