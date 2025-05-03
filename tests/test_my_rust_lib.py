import my_rust_lib



def test_double():
    assert my_rust_lib.double(2.0) == 4.0

def test_cowsay():
    assert my_rust_lib.cowsays('foo') == "🐮💬 foo"

def test_coordinates():
    coords = my_rust_lib.Coordinate(3, 4)
    assert coords.norm() == 5.