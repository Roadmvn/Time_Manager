# README - Schémas et Endpoints API

## 8. **Schémas à créer pour l'API Time Manager**

Pour répondre aux exigences du projet, voici les schémas de base que tu dois implémenter dans l'API :

### a. Schéma `User`

Le schéma des utilisateurs doit comporter deux champs : `username` et `email`. Ces champs sont obligatoires.

- **Migration pour `User`** :

  1.  Générer la migration pour le schéma `User` :

  ```bash
  mix phx.gen.json Accounts User users username:string email:string
  ```

  2.  Vérifier et ajuster le fichier de migration si nécessaire.

  3.  Appliquer la migration :

  ```bash
  mix ecto.migrate
  ```

  - **Exemple de modèle `User`** (dans `lib/time_manager/accounts/user.ex`) :

  ```elixir
  defmodule TimeManager.Accounts.User do
    use Ecto.Schema
    import Ecto.Changeset

    schema "users" do
      field :username, :string
      field :email, :string

      timestamps()
    end

    def changeset(user, attrs) do
      user
      |> cast(attrs, [:username, :email])
      |> validate_required([:username, :email])
    end
  end
  ```

### b. Schéma `Clock` (Horodatage)

Le schéma `Clock` doit contenir les informations sur l'heure (`time`), le statut (`status`), et la relation avec un utilisateur (`user_id`).

- **Migration pour `Clock`** :

  1.  Générer la migration pour le schéma `Clock` :

  ```bash
  mix phx.gen.json Times Clock clocks time:naive_datetime status:boolean user_id:references:users
  ```

  2.  Appliquer la migration :

  ```bash
  mix ecto.migrate
  ```

  - **Exemple de modèle `Clock`** (dans `lib/time_manager/times/clock.ex`) :

  ```elixir
  defmodule TimeManager.Times.Clock do
    use Ecto.Schema
    import Ecto.Changeset

    schema "clocks" do
      field :time, :naive_datetime
      field :status, :boolean
      belongs_to :user, TimeManager.Accounts.User

      timestamps()
    end

    def changeset(clock, attrs) do
      clock
      |> cast(attrs, [:time, :status, :user_id])
      |> validate_required([:time, :status, :user_id])
    end
  end
  ```

### c. Schéma `WorkingTime` (Temps de travail)

Le schéma `WorkingTime` doit contenir les informations sur les horaires de début (`start`), de fin (`end`), et la relation avec un utilisateur (`user_id`).

- **Migration pour `WorkingTime`** :

  1.  Générer la migration pour le schéma `WorkingTime` :

  ```bash
  mix phx.gen.json Times WorkingTime workingtimes start:naive_datetime end:naive_datetime user_id:references:users
  ```

  2.  Appliquer la migration :

  ```bash
  mix ecto.migrate
  ```

  - **Exemple de modèle `WorkingTime`** (dans `lib/time_manager/times/working_time.ex`) :

  ```elixir
  defmodule TimeManager.Times.WorkingTime do
    use Ecto.Schema
    import Ecto.Changeset

    schema "workingtimes" do
      field :start, :naive_datetime
      field :end, :naive_datetime
      belongs_to :user, TimeManager.Accounts.User

      timestamps()
    end

    def changeset(working_time, attrs) do
      working_time
      |> cast(attrs, [:start, :end, :user_id])
      |> validate_required([:start, :end, :user_id])
    end
  end
  ```

---

## 9. **Endpoints API requis**

Voici les endpoints obligatoires pour manipuler les utilisateurs, les horodatages (clocks) et les temps de travail (workingtimes). Respecte bien la structure pour chaque méthode HTTP.

### a. **Endpoints pour `User`** :

- `GET /api/users?email=XXX&username=YYY` : Récupérer les utilisateurs en fonction de l'email et du nom d'utilisateur.
- `GET /api/users/:userID` : Récupérer un utilisateur spécifique par ID.
- `POST /api/users` : Créer un nouvel utilisateur.
- `PUT /api/users/:userID` : Mettre à jour un utilisateur spécifique par ID.
- `DELETE /api/users/:userID` : Supprimer un utilisateur par ID.

### b. **Endpoints pour `WorkingTime`** :

- `GET /api/workingtime/:userID?start=XXX&end=YYY` : Récupérer tous les temps de travail d'un utilisateur entre deux dates.
- `GET /api/workingtime/:userID/:id` : Récupérer un temps de travail spécifique.
- `POST /api/workingtime/:userID` : Créer un nouvel enregistrement de temps de travail pour un utilisateur.
- `PUT /api/workingtime/:id` : Mettre à jour un temps de travail spécifique.
- `DELETE /api/workingtime/:id` : Supprimer un temps de travail.

### c. **Endpoints pour `Clock`** :

- `GET /api/clocks/:userID` : Récupérer les horodatages d'un utilisateur.
- `POST /api/clocks/:userID` : Créer un horodatage (arrivée ou départ) pour un utilisateur.

---

## 10. **Test des endpoints avec Postman**

Il est fortement recommandé de tester tous les endpoints avec **Postman** pour s'assurer que tout fonctionne correctement. Voici un exemple de requête POST pour créer un utilisateur :

- **POST /api/users** (exemple avec `curl`) :
  ```bash
  curl -X POST http://localhost:4000/api/users \
  -H "Content-Type: application/json" \
  -d '{"username": "johndoe", "email": "john@example.com"}'
  ```

---

Cela devrait couvrir toutes les nouvelles exigences et schémas que tu dois implémenter dans ton projet **Time Manager**, en suivant les spécifications fournies dans le dernier document. Si tu as besoin de plus de détails, n'hésite pas à demander !
