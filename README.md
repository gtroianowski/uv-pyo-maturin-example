# Summary 

This defines the base structure of a python codebase
relying on a rust-based library exposed to python using 
`PyO3` and built with `maturin`. The dependency between the 
larger code base and the rust library is handled by `uv` 
using `sources`


To run, first install [`uv`](https://docs.astral.sh/uv/getting-started/installation/). 
Then simply run the tests with 
```shell
$ uv run pytest
```

This will trigger the initial creation of the `venv` and run the tests (using the rust code) in it. If you make changes
to the rust code, you need to recompile it and install it by running:

```shell
$ uv pip install -e rust-library 
```
This will recompile the library and install it in the outer project's uv `venv`. 
The reason we do this rather than relying on `uv`'s natural dependency invalidation is that it is still not fully 
integrated with `maturin` and AFAIK, it cannot automatically rebuild the rust library upon changes (as it would
for python libraries).



# code structure

```
project
│   README.md  <-- this readme
│   pyproject.toml  <-- uv project definition
│   .python-version
│
└───rust-library
│   │   Cargo.toml  <-- rust cargo file
│   │   pyproject.toml  <-- uv build information
│   │
│   └───src
│       │   lib.rs  <-- entrypoint of the library (defining the module, ...)
│       │   ...
│
└───my_python_library
    │    __init__.py  <-- entrypoint of the python library
    │    ...
    
```


# Components
## `rust-library/pyproject.toml`
This provides information for the python package wrapped around the rust library
In particular, it specifies the build system:
```toml
[build-system]
requires = ["maturin>=1.0,<2.0"]
build-backend = "maturin"
```

## `rust-library/Cargo.toml`
This is the `toml` file associated with the rust code, defining dependencies as expected, 
including the `PyO3` dependencies:
```toml
pyo3 = { version = "0.24.0", features = ["extension-module"] }
```
Note the feature `extension-module` needed to build a python extension 
(see [here](https://pyo3.rs/main/features.html#extension-module))

It also needs to specify a library type that is compatible with being wrapped into a python library as follows:
```toml
[lib]
name = "my_rust_lib"
crate-type = ["cdylib"]
```
Note that the `name` field must match the name of the function decorated with `#[pymodule]` defining the structure of 
the resulting python module. Also, the crate type needs to be `cdylib`.


## `pyproject.toml`
This provides the information to build the larger python package. Note that it points
to the subproject containing the rust library, allowing `uv` to build the rust project 
as part of building the larger project. 


# A note on the naming and nomenclature
## Parent python library

- This is the library written in python
- The name of the package is `pyo3-maturin-example`. This is the name to use in the `dependency` section of the
  `pyproject.toml` of any application or library depending on it.
- `my_python_lib` is the name of the python package exposed by the `pyo3-maturin-example` library

## Inner rust library
- `rust-library` is the name of the resulting python package, specified in the inner 
  [`pyproject.toml`](./rust-library/pyproject.toml) (to be used `dependency` section of the
  [`pyproject.toml`](./pyproject.toml) and any other library depending on it). It seems to have to match the name of the directory it lives in
- `pyo3-library-example` is the name of the rust crate (to be imported by rust projects). 
  It is specified in the [`cargo.toml`](./rust-library/Cargo.toml)
- `my_rust_lib` is the name of the python package (relying on the compiled rust code) specified under the `lib` section in the [`cargo.toml`](./rust-library/Cargo.toml)
