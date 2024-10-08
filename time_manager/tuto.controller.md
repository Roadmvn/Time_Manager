# Génération des routes et contrôleurs pour Time Manager

Ce document répertorie toutes les commandes nécessaires pour générer les routes et les contrôleurs dans le projet **Time Manager**, ainsi que la description de chaque commande pour comprendre son objectif. Ce guide est conçu pour aider les développeurs à automatiser la création des endpoints API pour les utilisateurs et les tâches.

## 1. **Génération des routes et contrôleur pour les utilisateurs**

### a. Génération d'une API JSON pour les utilisateurs

Cette commande génère un contrôleur, des routes, et les fichiers associés pour gérer les opérations CRUD (Create, Read, Update, Delete) sur les utilisateurs. Cette API renvoie uniquement des données au format JSON, sans interface utilisateur.

```bash
mix phx.gen.json Accounts User users first_name:string last_name:string
```

#### Explication :

- **`phx.gen.json`** : Cette commande crée une API RESTful pour gérer les utilisateurs.
- **`Accounts`** : Le contexte qui regroupe la logique métier liée aux utilisateurs.
- **`User`** : Le modèle des utilisateurs qui est généré avec les champs `first_name` et `last_name`.
- **`users`** : Le nom de la table dans la base de données.
- Cette commande va créer :
  - Un fichier de migration pour la table `users`.
  - Un contrôleur pour gérer les actions CRUD sur les utilisateurs.
  - Des routes API pour les utilisateurs.

### b. Génération des fichiers de migration

Après avoir généré le contrôleur et les routes, il est nécessaire d'appliquer les modifications à la base de données en exécutant les migrations :

```bash
mix ecto.migrate
```

#### Explication :

- **`mix ecto.migrate`** : Cette commande applique toutes les migrations (modifications de la base de données) qui ont été générées, créant ainsi la table `users` dans la base de données.

---

## 2. **Génération des routes et contrôleur pour les tâches**

### a. Génération d'une API JSON pour les tâches

Cette commande génère un contrôleur, des routes, et les fichiers associés pour gérer les tâches. L'API permet de créer, lire, mettre à jour et supprimer des tâches, avec une association à un utilisateur.

```bash
mix phx.gen.json Tasks Task tasks title:string description:string status:string user_id:references:users
```

#### Explication :

- **`phx.gen.json`** : Crée une API RESTful pour gérer les tâches.
- **`Tasks`** : Le contexte qui regroupe la logique métier liée aux tâches.
- **`Task`** : Le modèle des tâches, avec les champs `title`, `description`, `status`, et une clé étrangère `user_id` qui fait référence à l'utilisateur associé.
- **`tasks`** : Le nom de la table dans la base de données.
- Cette commande va générer :
  - Un fichier de migration pour la table `tasks`.
  - Un contrôleur pour gérer les actions CRUD sur les tâches.
  - Des routes API pour les tâches.

### b. Application des migrations pour les tâches

Après avoir généré le contrôleur et les routes pour les tâches, exécutez cette commande pour appliquer les modifications à la base de données.

```bash
mix ecto.migrate
```

#### Explication :

- **`mix ecto.migrate`** : Cette commande applique toutes les migrations pour créer la table `tasks` dans la base de données.

---

## 3. **Visualisation de toutes les routes générées**

Pour vérifier que toutes les routes ont bien été générées et sont correctement définies, utilisez la commande suivante :

```bash
mix phx.routes
```

#### Explication :

- **`mix phx.routes`** : Affiche toutes les routes définies dans le projet, incluant les méthodes HTTP (GET, POST, PUT, DELETE), les chemins d'accès, et les actions des contrôleurs associées.

---

## 4. **Test des routes API**

Pour vérifier que toutes les routes fonctionnent correctement, vous pouvez utiliser un outil comme **Postman**, **Insomnia**, ou envoyer des requêtes via **cURL** depuis le terminal.

### Exemple avec cURL

- **GET (Liste des utilisateurs)** :

  ```bash
  curl http://localhost:4000/api/users
  ```

- **POST (Créer un utilisateur)** :

  ```bash
  curl -X POST http://localhost:4000/api/users \
  -H "Content-Type: application/json" \
  -d '{"first_name": "John", "last_name": "Doe"}'
  ```

- **PUT (Mettre à jour un utilisateur)** :

  ```bash
  curl -X PUT http://localhost:4000/api/users/1 \
  -H "Content-Type: application/json" \
  -d '{"first_name": "John", "last_name": "Doe Updated"}'
  ```

- **DELETE (Supprimer un utilisateur)** :
  ```bash
  curl -X DELETE http://localhost:4000/api/users/1
  ```

---

## 5. **Résumé des commandes**

----------------------------------------------------------------------|
| `mix phx.gen.json Accounts User ...` | Générer l'API JSON pour les utilisateurs |
| `mix phx.gen.json Tasks Task ...` | Générer l'API JSON pour les tâches |
| `mix ecto.migrate` | Appliquer les migrations et créer les tables dans la base de données |
| `mix phx.routes` | Visualiser toutes les routes générées dans l'application |
