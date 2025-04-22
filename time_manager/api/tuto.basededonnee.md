### 6. **Initialisation de la base de données PostgreSQL**

Avant de commencer à utiliser ta base de données avec Phoenix et PostgreSQL, tu dois t'assurer que PostgreSQL est installé et configuré sur ta machine.

#### a. Configuration de PostgreSQL

1. **Installation de PostgreSQL** : Si PostgreSQL n'est pas encore installé sur ta machine, tu peux suivre les instructions d'installation pour ton système d'exploitation :

   - **Linux** (Ubuntu) :
     ```bash
     sudo apt update
     sudo apt install postgresql postgresql-contrib
     ```
   - **MacOS** : Utilise Homebrew :
     ```bash
     brew install postgresql
     ```
   - **Windows** : Télécharge PostgreSQL depuis le site officiel : [PostgreSQL Download](https://www.postgresql.org/download/).

2. **Démarrer le service PostgreSQL** : Assure-toi que le service PostgreSQL est bien en cours d'exécution :
   - **Linux**/**MacOS** :
     ```bash
     sudo service postgresql start
     ```
   - **Windows** : Lance PostgreSQL via PgAdmin ou démarre le service depuis les Services Windows.

#### b. Création de la base de données dans Phoenix

1. **Configurer la base de données dans Phoenix** : Avant d'initialiser la base de données, tu dois t'assurer que les paramètres PostgreSQL dans le fichier de configuration de développement (`config/dev.exs`) sont correctement définis. Voici un exemple de configuration :

   Dans `config/dev.exs`, assure-toi que les paramètres suivants sont bien configurés :

   ```elixir
   config :time_manager, TimeManager.Repo,
     username: "<votre_utilisateur>",
     password: "<votre_mot_de_passe>",
     database: "time_manager_dev",
     hostname: "localhost",
     show_sensitive_data_on_connection_error: true,
     pool_size: 10
   ```

   - **username** : Ton nom d'utilisateur PostgreSQL.
   - **password** : Ton mot de passe PostgreSQL.
   - **database** : Le nom de la base de données à créer (ici `time_manager_dev`).

2. **Créer la base de données** : Utilise la commande suivante pour initialiser la base de données PostgreSQL dans ton projet Phoenix.

   ```bash
   mix ecto.create
   ```

#### Explication :

- **`mix ecto.create`** : Cette commande crée la base de données PostgreSQL spécifiée dans le fichier de configuration (`config/dev.exs`) en utilisant les informations de connexion fournies.

---

### Mise à jour du README avec la commande d'initialisation de PostgreSQL

---

# README - Initialisation de la base de données PostgreSQL

...

## 6. **Initialisation de la base de données PostgreSQL**

### a. Configuration de PostgreSQL

Avant de créer la base de données, assurez-vous que PostgreSQL est installé et en cours d'exécution. Vous pouvez vérifier en utilisant la commande suivante pour démarrer le service PostgreSQL :

```bash
sudo service postgresql start
```

### b. Configuration de la base de données dans Phoenix

Assurez-vous que le fichier `config/dev.exs` est configuré correctement avec les bonnes informations de connexion pour PostgreSQL :

```elixir
config :time_manager, TimeManager.Repo,
  username: "<votre_utilisateur>",
  password: "<votre_mot_de_passe>",
  database: "time_manager_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
```

### c. Initialisation de la base de données

Une fois PostgreSQL configuré, exécutez la commande suivante pour créer la base de données dans PostgreSQL :

```bash
mix ecto.create
```

#### Explication :

- **`mix ecto.create`** : Crée la base de données spécifiée dans le fichier de configuration. Assurez-vous que PostgreSQL est en cours d'exécution.
