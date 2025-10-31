import logging
from pathlib import Path
import subprocess
import psycopg2
from db import connect

logging.basicConfig(level=logging.INFO, format='%(asctime)s %(levelname)s %(message)s')

SCHEMA_FILE = Path('/sql/schema.sql')  # mounted by docker-compose
SEED_FILE = Path('/sql/Data.sql')

def run_sql_file(path: Path):
    if not path.exists():
        logging.warning("SQL file not found: %s", path)
        return
    with connect() as conn:
        with conn.cursor() as cur:
            sql = path.read_text()
            cur.execute(sql)
        conn.commit()

def copy_logic():
    """Example business logic: copy from table_a to table_b with a derived category."""
    with connect() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                            INSERT INTO table_b (name, age, city, category)
                            SELECT name, age, city,
                                   CASE WHEN age < 30 THEN 'YOUNG' ELSE 'ADULT' END
                            FROM table_a
                            ON CONFLICT (name, age, city) DO NOTHING;
                        """)
            conn.commit()
        logging.info("Copied rows from table_a to table_b.")

def counts():
    with connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT COUNT(*) FROM table_a;")
            a = cur.fetchone()[0]
            cur.execute("SELECT COUNT(*) FROM table_b;")
            b = cur.fetchone()[0]
            return a, b

def main():
    logging.info("Applying schema (idempotent).")
    run_sql_file(SCHEMA_FILE)

    logging.info("Seeding sample data (optional).")
    run_sql_file(SEED_FILE)

    logging.info("Running copy/transform logic.")
    copy_logic()

    a, b = counts()
    logging.info("Row counts -> table_a: %s, table_b: %s", a, b)
    logging.info("Done.")

if __name__ == "__main__":
    main()
