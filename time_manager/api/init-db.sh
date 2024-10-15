#!/bin/bash
set -e

# Attendre que la base de données soit prête
until PGPASSWORD=$POSTGRES_PASSWORD psql -h "$PGHOST" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c '\q'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - executing command"

# Exécuter les commandes de configuration de la base de données
mix deps.get
mix ecto.create
mix ecto.migrate

# Exécuter la commande passée en argument (dans ce cas, "mix phx.server")
exec "$@"
