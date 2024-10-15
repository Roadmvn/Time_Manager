# Utiliser l'image officielle Elixir
FROM elixir:1.14

# Installer les dépendances système nécessaires
RUN apt-get update && apt-get install -y postgresql-client

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers de dépendances
COPY mix.exs mix.lock ./

# Installer les dépendances Hex
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix deps.compile

# Copier le reste du code de l'application
COPY . .

# Forcer la recompilation des dépendances
RUN mix deps.clean --all
RUN mix deps.get
RUN mix deps.compile

# Compiler l'application
RUN mix do compile

# Copier le script d'initialisation
COPY init-db.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init-db.sh

# Modifier le point d'entrée
ENTRYPOINT ["/usr/local/bin/init-db.sh"]
CMD ["mix", "phx.server"]

# Définir la variable d'environnement pour utiliser la configuration Docker
ENV MIX_ENV=docker
