from hypothesis import given, settings, strategies as st
import pytest
from cipher import cipher

@given(text = st.text(min_size = 5, max_size = 10), shift = st.integers()) 
@settings(max_examples = 200)
def test_hypothesis(text, shift):
    """Testing the cipher function on single words."""
    actual = cipher(text = text, shift = shift, encrypt = True)
    expected = cipher(text = actual, shift = shift, encrypt = False)
    assert text == expected, "cipher has failed the hypothesis test."


        
