import pytest
from cipher import cipher
import re

test_cases = [
    ("Hello!", "two", "Jgnnq!"),
    ("MixeD", 3, "PlAhG"),
    ("lower", 5, "qtBjw"),
    ("UPPER", -32, "ojjYl"),
    ("A sentence WITH spaCes?", -7, "t lXgmXgVX PBMA liTvXl?")
]

@pytest.mark.parametrize('example, shift, result', test_cases)

class TestCipher:
    def test_singleword(self, example, shift, result):
        """Testing the cipher function on single words."""
        if isinstance(shift, int):
            actual = cipher(text = example, shift = shift)
            expected = result
            assert actual == expected, "cipher has failed on a single word."
    
    def test_negshift(self, example, shift, result):
        """Testing if negative shift values are accepted."""
        if isinstance(shift, int) and shift < 0:
            actual = cipher(text = example, shift = shift)
            expected = result
            assert actual == expected, "cipher did not accept negative shift values."

    def test_ooa(self, example, shift, result):
        """Testing if out-of-alphabet values are returned as they are"""
        symbol_regex = re.compile("[^A-Za-z]+")
        if isinstance(shift, int) and symbol_regex.search(example):
            actual = cipher(text = example, shift = shift)
            expected = result
            assert actual == expected, "Out-of-alphabet values were modified."
            
    def test_valueerror_on_string_shift(self, example, shift, result):
        """Test if submitting a string to shift argument returns TypeError."""
        if isinstance(shift, str):
            with pytest.raises(TypeError) as exception_info:
                cipher(text = example, shift = shift)
    
   