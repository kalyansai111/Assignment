import sys
sys.path.append('/app')  # make /app importable inside the container

from pathlib import Path
from typing import Tuple
from db import connect
from main import run_sql_file, copy_logic

SCHEMA_FILE = Path("/sql/schema.sql")
SEED_FILE = Path("/sql/Data.sql")

# ---------- helpers ----------

def rows(table: str) -> int:
    with connect() as conn:
        with conn.cursor() as cur:
            cur.execute(f"SELECT COUNT(*) FROM {table};")
            return cur.fetchone()[0]

def tables_exist() -> Tuple[bool, bool]:
    q = """
    SELECT table_name FROM information_schema.tables
    WHERE table_schema='public' AND table_name IN ('table_a','table_b')
    ORDER BY table_name;
    """
    with connect() as conn:
        with conn.cursor() as cur:
            cur.execute(q)
            names = {r[0] for r in cur.fetchall()}
            return ('table_a' in names, 'table_b' in names)

def truncate_all():
    with connect() as conn:
        with conn.cursor() as cur:
            cur.execute("TRUNCATE table_b, table_a RESTART IDENTITY;")
        conn.commit()

# ---------- fixtures ----------

import pytest

@pytest.fixture(scope="session", autouse=True)
def apply_schema_once():
    # apply schema once for the whole run (idempotent)
    run_sql_file(SCHEMA_FILE)

@pytest.fixture(autouse=True)
def clean_tables_before_each_test():
    # start each test from a clean state
    truncate_all()
    yield
    # (optional) ensure clean after as well
    truncate_all()

# ---------- tests ----------

def test_schema_creates_tables():
    # just assert presence; do NOT truncate in this test
    a_exists, b_exists = tables_exist()
    assert a_exists and b_exists

def test_seed_is_idempotent():
    # seed twice; unique index + ON CONFLICT should keep it at 3
    run_sql_file(SEED_FILE)
    run_sql_file(SEED_FILE)
    assert rows("table_a") == 3

def test_copy_logic_inserts_expected_rows():
    run_sql_file(SEED_FILE)
    copy_logic()
    assert rows("table_b") == 3

def test_copy_logic_is_idempotent():
    run_sql_file(SEED_FILE)
    copy_logic()
    copy_logic()  # running again must not add rows
    assert rows("table_b") == 3
