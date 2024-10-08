# Guide de Nettoyage et Configuration du Projet Time Manager

## Table des Matières

- [1. Supprimer les Fichiers de Migration](#1-supprimer-les-fichiers-de-migration)
- [2. Supprimer les Fichiers Générés Automatiquement](#2-supprimer-les-fichiers-générés-automatiquement)
- [3. Supprimer la Base de Données](#3-supprimer-la-base-de-données)
- [4. Nettoyer les Dépendances Compilées](#4-nettoyer-les-dépendances-compilées)
- [5. Réinstaller les Dépendances](#5-réinstaller-les-dépendances)
- [6. Régénérer les Schémas et Contrôleurs](#6-régénérer-les-schémas-et-contrôleurs)
- [7. Mettre à Jour le Routeur](#7-mettre-à-jour-le-routeur)
- [8. Créer la Base de Données et Exécuter les Migrations](#8-créer-la-base-de-données-et-exécuter-les-migrations)
- [9. Prochaines Étapes](#9-prochaines-étapes)

---

## 1. Supprimer les Fichiers de Migration

Supprimez tous les fichiers de migration existants pour repartir sur de bonnes bases.

```bash
rm priv/repo/migrations/*
```

---

## 2. Supprimer les Fichiers Générés Automatiquement

Supprimez tous les fichiers de schéma, contexte, contrôleur et test qui ont été générés automatiquement.

```bash
rm lib/time_manager/accounts.ex
rm lib/time_manager/accounts/user.ex
rm lib/time_manager/times.ex
rm lib/time_manager/times/clock.ex
rm lib/time_manager/times/working_time.ex
rm lib/time_manager_web/controllers/user_controller.ex
rm lib/time_manager_web/controllers/user_json.ex
rm lib/time_manager_web/controllers/clock_controller.ex
rm lib/time_manager_web/controllers/clock_json.ex
rm lib/time_manager_web/controllers/working_time_controller.ex
rm lib/time_manager_web/controllers/working_time_json.ex
rm test/time_manager_web/controllers/user_controller_test.exs
rm test/time_manager_web/controllers/clock_controller_test.exs
rm test/time_manager_web/controllers/working_time_controller_test.exs
```

---

## 3. Supprimer la Base de Données

Supprimez complètement la base de données existante.

```bash
mix ecto.drop
```

---

## 4. Nettoyer les Dépendances Compilées

Nettoyez toutes les dépendances compilées et les artefacts de construction.

```bash
mix deps.clean --all
mix clean
```

---

## 5. Réinstaller les Dépendances

Récupérez et installez les dépendances du projet.

```bash
mix deps.get
```

---

## 6. Régénérer les Schémas et Contrôleurs

Générez les schémas et les contrôleurs nécessaires en utilisant les générateurs Phoenix.

### Générer le Schéma et le Contrôleur pour User

```bash
mix phx.gen.json Accounts User users username:string email:string
```

### Générer le Schéma et le Contrôleur pour Clock

```bash
mix phx.gen.json Times Clock clocks time:naive_datetime status:boolean user_id:references:users
```

### Générer le Schéma et le Contrôleur pour WorkingTime

```bash
mix phx.gen.json Times WorkingTime workingtimes start:naive_datetime end:naive_datetime user_id:references:users
```

---

## 7. Mettre à Jour le Routeur

Ajoutez les ressources générées dans votre fichier `router.ex` situé à `lib/time_manager_web/router.ex`. Assurez-vous d'avoir les routes appropriées configurées pour vos nouveaux contrôleurs.

```elixir
resources "/users", UserController, except: [:new, :edit]
resources "/clocks", ClockController, except: [:new, :edit]
resources "/workingtimes", WorkingTimeController, except: [:new, :edit]
```

---

## 8. Créer la Base de Données et Exécuter les Migrations

Créez une nouvelle base de données et exécutez les migrations pour configurer le schéma de votre base de données.

```bash
mix ecto.create
mix ecto.migrate
```

---

## 9. Prochaines Étapes

Votre projet est maintenant nettoyé et configuré avec les nouveaux schémas et contrôleurs. Si vous rencontrez des problèmes pendant ces étapes, n'hésitez pas à demander de l'aide.

Bon développement !

### b. Définition de la relation dans le modèle `Task`

Dans le modèle `Task`, ajoute la relation suivante pour indiquer qu'une tâche appartient à un utilisateur :

```elixir
belongs_to :user, TimeManager.Accounts.User
```

### c. Mise à jour de la base de données avec la relation

Crée une nouvelle migration pour ajouter la colonne `user_id` à la table `tasks` :

```bash
mix ecto.gen.migration add_user_id_to_tasks
```

Dans le fichier généré, ajoute :

```elixir
alter table(:tasks) do
  add :user_id, references(:users, on_delete: :nothing)
end

create index(:tasks, [:user_id])
```

Ensuite, applique la migration avec :

```bash
mix ecto.migrate
```
