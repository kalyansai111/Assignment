.PHONY: all up schema seed show app test down clean \
        dbt-init dbt-seed dbt-run dbt-test dbt-build dbt-clean dbt-docs

# -----------------------------------------------------------------------------
# PRIMARY WORKFLOW (SQL + Python + DBT)
# -----------------------------------------------------------------------------

<<<<<<< HEAD
=======

>>>>>>> edcf83ee1ec7221742634878d5b55e2bd6da372d
all: up schema seed app test dbt-build show

up:
	docker compose up -d

schema:
	docker compose exec -T db psql -U admin -d testdb -f /sql/schema.sql

seed:
	docker compose exec -T db psql -U admin -d testdb -f /sql/Data.sql

show:
	docker compose exec -T db psql -U admin -d testdb -c "\dt"
	docker compose exec -T db psql -U admin -d testdb -c "SELECT * FROM table_a;"
	docker compose exec -T db psql -U admin -d testdb -c "SELECT * FROM table_b;"

app:
	docker compose run --rm app

test:
	docker compose run --rm app bash -lc "pip install -r requirements.txt && PYTHONPATH=/app pytest -q /tests --cov=/app --cov-report=term-missing --cov-report=html:/app/htmlcov --cov-fail-under=50"

down:
	docker compose down

clean:
	docker compose down -v

# -----------------------------------------------------------------------------
# DBT EXECUTION LAYER
# -----------------------------------------------------------------------------
.PHONY: dbt-init dbt-seed dbt-run dbt-test dbt-build dbt-clean dbt-docs

dbt-init:
	docker compose run --rm app bash -lc "python -m pip install -U pip && pip install -r requirements.txt && dbt --version"

dbt-seed:
	docker compose run --rm app bash -lc "pip install -r requirements.txt && dbt seed --project-dir /project --profiles-dir /.dbt"

dbt-run:
	docker compose run --rm app bash -lc "pip install -r requirements.txt && dbt run --project-dir /project --profiles-dir /.dbt"

dbt-test:
	docker compose run --rm app bash -lc "pip install -r requirements.txt && dbt test --project-dir /project --profiles-dir /.dbt"

# dbt-build runs dbt seed + run + test in one go
dbt-build:
	docker compose run --rm app bash -lc "pip install -r requirements.txt && dbt build --project-dir /project --profiles-dir /.dbt"

dbt-clean:
	docker compose run --rm app bash -lc "pip install -r requirements.txt && dbt clean --project-dir /project --profiles-dir /.dbt"

dbt-docs:
	docker compose run --rm -p 8080:8080 app bash -lc "pip install -r requirements.txt && dbt docs generate --project-dir /project --profiles-dir /.dbt && dbt docs serve --port 8080 --no-browser"
