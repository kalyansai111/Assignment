CREATE TABLE IF NOT EXISTS table_a (
  id   SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  age  INT NOT NULL,
  city VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS table_b (
  id       SERIAL PRIMARY KEY,
  name     VARCHAR(100) NOT NULL,
  age      INT NOT NULL,
  city     VARCHAR(50) NOT NULL,
  category VARCHAR(50) NOT NULL
);

-- Avoid duplicates in table_a (natural key)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_indexes
    WHERE schemaname = 'public' AND indexname = 'uq_table_a_natural'
  ) THEN
    CREATE UNIQUE INDEX uq_table_a_natural ON table_a (name, age, city);
  END IF;
END $$;

-- Avoid duplicates in table_b (natural key)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_indexes
    WHERE schemaname = 'public' AND indexname = 'uq_table_b_natural'
  ) THEN
    CREATE UNIQUE INDEX uq_table_b_natural ON table_b (name, age, city);
  END IF;
END $$;

