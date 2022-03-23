import pytest
from cipher import cipher

def test_singleword():
    """Testing the cipher function on single words."""
    actual = cipher(text = "Hello", shift = 2)
    expected = "Jgnnq"
    assert actual == expected, "cipher has failed on a single word."
    
def test_negshift():
    """Testing if negative shift values are accepted."""
    actual = cipher(text = "Hello", shift = -1)
    expected = "Gdkkn"
    assert actual == expected, "cipher did not accept negative shift values."
    
def test_ooa():
    """Testing if out-of-alphabet values are returned as they are"""
    actual = cipher(text = "Hel123lo", shift = 2)
    expected = 'Jgn123nq'
    assert actual == expected, "Out-of-alphabet values were modified."

def test_valueerror_on_string_shift():
    """Test if submitting a string to shift argument returns TypeError."""
    with pytest.raises(TypeError) as exception_info:
        cipher(text = "Hello", shift = 'two')
        
@pytest.fixture
def test_pairs():
    return [
        ("MixeD", "PlAhG", 3),
        ("lower", "qtBjw", 5),
        ("UPPER", "Avvkx", 32),
        ("A sentence WITH spaCes", "H zluAlujl dPaO zwhJlz", 7)
    ]

def test_multiple(test_pairs):
    """Testing for multiple string variations."""
    for pair in test_pairs:
        example = pair[0]
        expected = pair[1]
        result = cipher(text = example, shift = pair[2], encrypt = True)
        assert result == expected, "cipher cannot handle all string variations."
        
@pytest.mark.parametrize("shift", list(range(1, 11)))

def test_integrate(shift):
    """Check that cipher can encrypt and decrypt faithfully."""
    original = "Switching Back and Forth."
    encrypt = cipher(text = original, shift = shift, encrypt = True)
    decrypt = cipher(text = encrypt, shift = shift, encrypt = False)
    assert original == decrypt, "Decrypted text not the same as original!"