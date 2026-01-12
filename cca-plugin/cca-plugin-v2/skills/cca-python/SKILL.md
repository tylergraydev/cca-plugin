---
name: cca-python
description: CCA language context for Python projects. Auto-loaded when pyproject.toml, requirements.txt, or setup.py is detected.
---

# CCA: Python Context

## Language Detection
This context applies when any of these files exist:
- `pyproject.toml`
- `requirements.txt`
- `setup.py`
- `Pipfile`
- `*.py` files

## Build-Test-Improve Commands

### Test
```bash
# pytest (preferred)
pytest
pytest -v                    # verbose
pytest path/to/test.py       # specific file
pytest -k "test_name"        # by name
pytest --cov=src             # with coverage

# unittest (stdlib)
python -m unittest discover
```

### Type Checking
```bash
# mypy
mypy .
mypy src/

# pyright
pyright
```

### Lint/Format
```bash
# Ruff (fast, recommended)
ruff check .
ruff check --fix .
ruff format .

# Black (formatting)
black .

# isort (imports)
isort .

# flake8
flake8 .
```

## Virtual Environment Management

### Detection
- `.venv/` or `venv/` → Standard venv
- `poetry.lock` → Poetry
- `Pipfile.lock` → Pipenv
- `uv.lock` → uv
- `conda-lock.yml` → Conda

### Activation
```bash
# venv
source .venv/bin/activate

# Poetry
poetry shell

# uv
source .venv/bin/activate  # after uv venv
```

## Common Patterns

### Error Handling
```python
# Use specific exceptions
class ProjectError(Exception):
    """Base exception for this project."""
    pass

class ValidationError(ProjectError):
    """Raised when validation fails."""
    pass

# Explicit error handling
try:
    result = risky_operation()
except SpecificError as e:
    logger.error(f"Operation failed: {e}")
    raise
```

### Type Hints
```python
from typing import Optional, List, Dict, TypeVar, Generic

def process_items(items: List[str]) -> Dict[str, int]:
    return {item: len(item) for item in items}

# Use | for unions in Python 3.10+
def get_user(id: str) -> User | None:
    ...
```

### Async Patterns
```python
import asyncio

async def fetch_all(urls: list[str]) -> list[Response]:
    async with aiohttp.ClientSession() as session:
        tasks = [fetch_one(session, url) for url in urls]
        return await asyncio.gather(*tasks)
```

## Project Structure Conventions

```
src/
├── package_name/
│   ├── __init__.py
│   ├── core/           # Core business logic
│   ├── api/            # API endpoints
│   ├── models/         # Data models
│   └── utils/          # Utilities
tests/
├── __init__.py
├── conftest.py         # pytest fixtures
├── test_core/
└── test_api/
```

## Common Gotchas
- Always use virtual environments
- `python` vs `python3` - check which is available
- `pip install -e .` for editable installs during development
- Check Python version in `pyproject.toml` or `.python-version`
- f-strings are preferred over `.format()` or `%`
- Use `pathlib.Path` over `os.path` for paths
