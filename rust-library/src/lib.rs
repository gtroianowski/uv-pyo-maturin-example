use pyo3::prelude::*;
use pyo3::types::PyModule;
use pyo3::wrap_pyfunction;

#[pyfunction]
fn cowsays(s: String) -> String {
    format!("🐮💬 {}", s)
}

#[pyfunction]
fn double(x: f64) -> f64 {
    x * 2.0
}

#[pyclass]
struct Coordinate {
    x: f64,
    y: f64,
}

#[pymethods]
impl Coordinate {
    #[new]
    fn new(x: f64, y: f64) -> Self {
        Coordinate { x, y }
    }

    fn norm(&self) -> f64 {
        (self.x * self.x + self.y * self.y).sqrt()
    }
}

#[pymodule]
fn my_rust_lib(_py: Python, m: &Bound<'_, PyModule>) -> PyResult<()> {
    m.add_function(wrap_pyfunction!(double, m)?)?;
    m.add_function(wrap_pyfunction!(cowsays, m)?)?;
    m.add_class::<Coordinate>()?;
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*; // to access the functions in the same file

    #[test]
    fn test_double() {
        assert_eq!(double(2.), 4.);
    }

    #[test]
    fn test_cowsays() {
        assert_eq!(cowsays("foo".to_string()), "🐮💬 foo");
    }

    #[test]
    fn test_coordinates() {
        let coords = Coordinate { x: 3., y: 4. };
        assert_eq!(coords.norm(), 5.);
    }
}
