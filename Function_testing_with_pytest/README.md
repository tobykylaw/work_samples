# Testing functions with `pytest`

Wrote test functions for a Ceasar cipher to see if it:
- processes text with different cases, spaces, out-of-range symbols succesfully.
- throws the correct error when non-legitimate arguments are submitted.
- if the Ceasar cipher faithfully encrypts and decrypts given text.

Also:
- Constructed a test class to group test functions.
- Parametrized test cases to submit iteratively to test functions/class.
- Used the `hypothesis` package to generate arbitrary inputs to the Caesar cipher,
and check if the right outputs are returned. 
