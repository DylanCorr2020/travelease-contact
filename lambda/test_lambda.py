
import pytest
from lambda_function import validate_input , parse_event

# Test that validate_input passes when given valid input data
def test_validate_input_valid():
    data = {
        "first_name": "Dylan",
        "email": "test@email.com"
    }
     #Should not raise an exception
    validate_input(data)


# Test that validate_input raises ValueError when 'first_name' is missing   
def test_validate_input_missing_name():
    data = {
        "email": "test@email.com"
    }
    # Expect a ValueError due to missing first_name
    with pytest.raises(ValueError):
        validate_input(data)


# Test that validate_input raises ValueError when email format is invalid       
def test_validate_input_invalid_email():
    data = {
        "first_name": "Dylan",
        "email": "invalid-email"
    }
    # Expect a ValueError due to invalid email format
    with pytest.raises(ValueError):
        validate_input(data)


# Test parse_event correctly parses JSON string from the event body      
def test_parse_event():
    event = {
        "body": '{"first_name": "Dylan", "email": "test@email.com"}'
    }
     #Check that the parsed dictionary contains the expected first_name
    result = parse_event(event)

    assert result["first_name"] == "Dylan"