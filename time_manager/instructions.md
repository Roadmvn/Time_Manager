
---

# Instructions pour le projet Time Manager

## Situation du projet

Le projet **Time Manager** est une application de gestion de temps destinée à trois types d'utilisateurs : les employés, les managers, et le directeur général. L'application a pour objectif principal de permettre à chaque utilisateur de suivre, gérer et visualiser leur temps de travail à travers des tableaux de bord.

### Contexte

1. **Employés** : Les employés peuvent enregistrer leurs heures d'arrivée et de départ, modifier ou supprimer leur compte, et consulter un tableau de bord personnel pour visualiser leur temps de travail quotidien et hebdomadaire.
2. **Managers** : Les managers, en plus de leurs propres fonctionnalités, ont la possibilité de gérer les membres de leur équipe. Ils peuvent consulter les temps de travail quotidiens et hebdomadaires de chaque membre de l'équipe.
3. **Directeur général** : Le directeur général peut consulter les tableaux de bord de tous les utilisateurs, promouvoir des employés au rang de manager, et gérer (créer/supprimer) des comptes utilisateurs.

L'application est développée avec le framework Phoenix d'Elixir et utilise PostgreSQL comme base de données. Le projet a déjà été créé, mais il reste à implémenter plusieurs parties clés, notamment les schémas de données, les relations entre les utilisateurs et les tâches, ainsi que les routes API pour permettre la gestion complète des utilisateurs et des tâches.

---

## Objectif de ce fichier

Ce fichier **instruction.md** contient toutes les étapes à suivre pour compléter le projet Time Manager à partir du moment où les schémas de données doivent être modélisés. Les étapes suivantes expliquent comment créer les modèles, configurer les routes, et implémenter les contrôleurs pour assurer une gestion complète de l'API, ainsi que les commandes nécessaires à exécuter.

---

## 1. Modélisation des utilisateurs et des tâches

### a. Création du schéma des utilisateurs

Les utilisateurs ont un prénom (`first_name`) et un nom (`last_name`). Pour créer le schéma des utilisateurs, exécutez la commande suivante dans votre terminal :

```bash
mix phx.gen.schema User users first_name:string last_name:string
```

Cette commande génère un fichier dans le dossier `lib/time_manager/user.ex`. Ce fichier contient la définition du modèle utilisateur.

### b. Création du schéma des tâches

Les tâches ont un titre (`title`), une description (`description`), un statut (`status`), et sont associées à un utilisateur via une clé étrangère `user_id`. Pour générer le schéma des tâches, utilisez la commande suivante :

```bash
mix phx.gen.schema Task tasks title:string description:string status:string user_id:references:users
```

Cela créera un fichier dans `lib/time_manager/task.ex`, contenant la définition du modèle des tâches.

### c. Migration de la base de données

Après avoir généré les schémas des utilisateurs et des tâches, il est nécessaire d'appliquer ces modifications à la base de données en exécutant la migration :

```bash
mix ecto.migrate
```

Cette commande créera les tables `users` et `tasks` dans la base de données PostgreSQL.

---

## 2. Gestion des relations entre utilisateurs et tâches

### a. Définir la relation dans le modèle User

Un utilisateur peut avoir plusieurs tâches (relation "un à plusieurs"). Ouvrez le fichier `lib/time_manager/user.ex` et ajoutez la relation suivante :

```elixir
has_many :tasks, TimeManager.Task
```

### b. Définir la relation dans le modèle Task

Chaque tâche est associée à un utilisateur. Ouvrez le fichier `lib/time_manager/task.ex` et ajoutez la relation suivante :

```elixir
belongs_to :user, TimeManager.User
```

---

## 3. Création des routes API

### a. Routes pour les utilisateurs

Pour gérer les utilisateurs (CRUD), vous devez ajouter des routes dans le fichier `lib/time_manager_web/router.ex`. Ajoutez les lignes suivantes sous le scope `/api` :

```elixir
scope "/api", TimeManagerWeb do
  pipe_through :api

  resources "/users", UserController, except: [:new, :edit]
end
```

Cela permet de créer les routes suivantes :
- `GET /api/users` : Liste tous les utilisateurs.
- `POST /api/users` : Crée un nouvel utilisateur.
- `GET /api/users/:id` : Récupère un utilisateur par son ID.
- `PUT /api/users/:id` et `PATCH /api/users/:id` : Met à jour un utilisateur.
- `DELETE /api/users/:id` : Supprime un utilisateur.

### b. Routes pour les tâches

Ajoutez également des routes pour les tâches dans le même fichier `router.ex` :

```elixir
resources "/tasks", TaskController, except: [:new, :edit]
```

Cela permet de créer les routes suivantes :
- `GET /api/tasks` : Liste toutes les tâches.
- `POST /api/tasks` : Crée une nouvelle tâche.
- `GET /api/tasks/:id` : Récupère une tâche par son ID.
- `PUT /api/tasks/:id` et `PATCH /api/tasks/:id` : Met à jour une tâche.
- `DELETE /api/tasks/:id` : Supprime une tâche.

---

## 4. Implémentation des contrôleurs

### a. Implémentation du contrôleur User

Dans le fichier `lib/time_manager_web/controllers/user_controller.ex`, implémentez les méthodes pour gérer les utilisateurs. Voici un exemple de méthode pour récupérer la liste de tous les utilisateurs (`index`) :

```elixir
def index(conn, _params) do
  users = Repo.all(User)
  render(conn, "index.json", users: users)
end
```

Vous devrez également implémenter les autres méthodes : `show`, `create`, `update`, et `delete`.

### b. Implémentation du contrôleur Task

Dans le fichier `lib/time_manager_web/controllers/task_controller.ex`, implémentez les méthodes pour gérer les tâches. Par exemple, voici comment récupérer la liste des tâches :

```elixir
def index(conn, _params) do
  tasks = Repo.all(Task)
  render(conn, "index.json", tasks: tasks)
end
```

Les autres méthodes (`show`, `create`, `update`, `delete`) doivent également être implémentées.

---

## 5. Tests des fonctionnalités

### a. Tester les routes API

Utilisez un outil comme **Postman** ou **cURL** pour tester les routes que vous avez créées. Assurez-vous que toutes les actions (CRUD) pour les utilisateurs et les tâches fonctionnent correctement.

### b. Exemple de tests avec cURL

Pour récupérer la liste des utilisateurs, vous pouvez utiliser la commande suivante dans votre terminal :

```bash
curl http://localhost:4000/api/users
```

De la même manière, vous pouvez tester les autres routes en modifiant l'URL et les méthodes (GET, POST, PUT, DELETE).

---

## 6. Compléter le README

Ajoutez les sections suivantes dans votre fichier `README.md` pour documenter le projet :

### a. Prérequis
- **Elixir** : Assurez-vous que la version correcte d'Elixir est installée.
- **Phoenix Framework** : Installez Phoenix avec la commande suivante :
  ```bash
  mix archive.install hex phx_new
  ```
- **PostgreSQL** : La base de données PostgreSQL doit être installée et en cours d'exécution.

### b. Installation
1. Clonez ce dépôt :
   ```bash
   git clone <url_du_projet>
   ```
2. Accédez au répertoire du projet :
   ```bash
   cd time_manager
   ```
3. Installez les dépendances :
   ```bash
   mix deps.get
   ```

### c. Configuration de la base de données
1. Créez la base de données :
   ```bash
   mix ecto.create
   ```
2. Appliquez les migrations :
   ```bash
   mix ecto.migrate
   ```

### d. Démarrage du serveur
1. Démarrez le serveur Phoenix :
   ```bash
   mix phx.server
   ```
2. L'API sera accessible à l'adresse suivante :
   ```url
   http://localhost:4000/api
   ```

### e. Routes API disponibles
- **Utilisateurs** :
  - `GET /api/users` : Liste tous les utilisateurs.
  - `POST /api/users` : Crée un nouvel utilisateur.
  - `GET /api/users/:id` : Récupère un utilisateur par son ID.
  - `PUT /api/users/:id` : Met à jour un utilisateur.
  - `DELETE /api/users/:id` : Supprime un utilisateur.
- **Tâches** :
  - `GET /api/tasks` : Liste toutes les tâches.
  - `POST /api/tasks` : Crée une nouvelle tâche.
  - `GET /api/tasks/:id` : Récupère une tâche par son ID.
  - `PUT /api/tasks/:id` : Met à jour une tâche.
  - `DELETE /api/tasks/:id` : Supprime une tâche.

### f. Exécution des tests
Pour exécuter les tests, utilisez la commande suivante :
```bash
mix test
```

---

Le fichier **instruction2.md** doit fournir une explication complète et guider les

