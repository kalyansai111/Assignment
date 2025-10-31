INSERT INTO table_a (name, age, city) VALUES
  ('Alice',   25, 'Las Vegas'),
  ('Bob',     32, 'Seattle'),
  ('Charlie', 45, 'Austin')
ON CONFLICT (name, age, city) DO NOTHING;
