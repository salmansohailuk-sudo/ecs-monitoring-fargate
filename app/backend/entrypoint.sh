#!/bin/sh
set -eu

if [ -n "${DB_HOST:-}" ] && [ -n "${DB_USER:-}" ] && [ -n "${DB_PASSWORD:-}" ]; then
  echo "Waiting for MySQL at ${DB_HOST}:${DB_PORT:-3306}..."

  ATTEMPTS=0

  until python - <<'PY'
import os
import mysql.connector

connection = mysql.connector.connect(
    host=os.environ["DB_HOST"],
    port=int(os.environ.get("DB_PORT", "3306")),
    user=os.environ["DB_USER"],
    password=os.environ["DB_PASSWORD"],
    connection_timeout=3,
)

connection.close()
PY
  do
    ATTEMPTS=$((ATTEMPTS + 1))

    if [ "$ATTEMPTS" -ge 30 ]; then
      echo "MySQL did not become available; skipping schema initialization."
      break
    fi

    sleep 5
  done

  if [ "$ATTEMPTS" -lt 30 ]; then
    python - <<'PY'
import os
import mysql.connector

database_name = os.environ.get("DB_NAME", "ecomm")

connection = mysql.connector.connect(
    host=os.environ["DB_HOST"],
    port=int(os.environ.get("DB_PORT", "3306")),
    user=os.environ["DB_USER"],
    password=os.environ["DB_PASSWORD"],
)

cursor = connection.cursor()

cursor.execute(
    f"CREATE DATABASE IF NOT EXISTS `{database_name}`"
)

cursor.execute(
    f"USE `{database_name}`"
)

with open("/app/schema.sql", "r", encoding="utf-8") as file:
    sql = file.read()

for statement in sql.split(";"):
    statement = statement.strip()

    if statement:
        upper_statement = statement.upper()

        if upper_statement.startswith("CREATE DATABASE"):
            continue

        if upper_statement.startswith("USE "):
            continue

        cursor.execute(statement)

connection.commit()

cursor.close()
connection.close()

print(f"Database schema initialized successfully in {database_name}")
PY
  fi
else
  echo "Database variables incomplete; skipping schema initialization."
fi

exec "$@"