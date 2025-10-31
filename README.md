# Docker + PostgreSQL + Python (ETL) — Complete Approach

This repo gives you a **ready-to-run, production-style** solution for the take-home:
- **Docker Compose** spins up **Postgres** and a **Python app**.
- **SQL schema/seed** scripts create demo tables/data.
- **Python ETL** copies data from `table_a` → `table_b` with a derived column.
- **Pytest** verifies the logic.
- **Makefile** provides one-command workflows.

## Prerequisites
- Docker Desktop (Windows/Mac)
- `docker compose` available in your terminal

## Quickstart (90 seconds)
```bash
# 1) Start services
make up

# 2) Initialize tables and seed data
make init-db
make seed

# 3) Run the ETL logic
make run

# 4) (Optional) See logs
make logs
```

You should see logs showing rows copied from `table_a` to `table_b`.

## Project Structure
```
.
├── .env
├── docker-compose.yml
├── Makefile
├── sql/
│   ├── schema.sql
│   └── Data.sql
├── app/
│   ├── requirements.txt
│   ├── db.py
│   └── main.py
└── tests/
    └── test_copy_logic.py
```

## Commands Cheat Sheet
```bash
make up        # Start Postgres + app
make init-db   # Apply schema
make seed      # Optional: load sample rows into table_a
make run       # Execute ETL (main.py)
make test      # Run pytest
make psql      # Open psql inside the db container
make logs      # Tail logs
make down      # Stop & remove containers/volumes
make clean     # Stop & delete volumes (wipes data)
```

## Connection Details
- Host: `db` (inside Docker network) or `localhost` (from your machine to port 5432)
- DB: `testdb` | User: `admin` | Password: `admin`

## How the ETL Works
1. `schema.sql` creates `table_a` and `table_b` if not present.
2. `Data.sql` inserts a few rows into `table_a`.
3. `main.py` runs:
   - Apply schema (idempotent)
   - Seed data (idempotent)
   - **Copy/transform:** insert into `table_b` from `table_a` with a `category` derived from `age`.

## Troubleshooting
- **Port 5432 already in use:** Edit `docker-compose.yml` → change to `"5433:5432"` and reconnect on port 5433.
- **Docker not found:** Open Docker Desktop and ensure whale icon shows “running”.
- **Password auth failed:** Recreate the stack: `make clean && make up`.
- **Apple Silicon:** Image is multi-arch; no special flag needed.

## Customize
- Add your own tables & SQL to `sql/`.
- Replace `copy_logic()` in `app/main.py` with your logic.
- Extend tests in `tests/` to assert business rules.
```
