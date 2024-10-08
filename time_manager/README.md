# TimeManager

To start your Phoenix server:

- Run `mix setup` to install and setup dependencies
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix

# TimeManager

Pour démarrer votre serveur Phoenix :

- Exécutez `mix setup` pour installer et configurer les dépendances
- Démarrez le point de terminaison Phoenix avec `mix phx.server` ou à l'intérieur d'IEx avec `iex -S mix phx.server`

Vous pouvez maintenant visiter [`localhost:4000`](http://localhost:4000) depuis votre navigateur.

## Configuration de la base de données

Pour configurer la base de données et créer les tables nécessaires, suivez ces étapes :

1. Créez la base de données :

   ```
   mix ecto.create
   ```

2. Exécutez les migrations pour créer les tables :
   ```
   mix ecto.migrate
   ```

Si vous rencontrez des erreurs de migration en double, suivez ces étapes :

1. Allez dans le dossier des migrations :

   ```
   cd priv/repo/migrations
   ```

2. Supprimez les fichiers de migration en double (gardez le plus récent pour chaque table).

3. Revenez au dossier racine du projet :

   ```
   cd ../../..
   ```

4. Réexécutez la migration :
   ```
   mix ecto.migrate
   ```

## Démarrage du serveur

Une fois la base de données configurée, démarrez le serveur Phoenix :

## Résolution des problèmes de migration et de démarrage

Si vous rencontrez des problèmes lors de la migration ou du démarrage du serveur, suivez ces étapes :

1. `mix deps.get` - Pour s'assurer que toutes les dépendances sont installées.

2. `mix ecto.drop` - Pour supprimer la base de données existante en cas de conflit.

3. `mix ecto.create` - Pour créer une nouvelle base de données propre.

4. `cd priv/repo/migrations` - Accédez au dossier des migrations.

5. Supprimez les fichiers de migration en double, en particulier ceux liés à `create_users`.

6. `cd ../../..` - Revenez au répertoire racine du projet.

7. `mix ecto.migrate` - Pour appliquer les migrations sans conflits.

8. `mix phx.server` - Pour démarrer le serveur Phoenix.

Ces étapes devraient résoudre les problèmes de migration en double et permettre le démarrage correct du serveur.

## Modifications récentes et configuration de l'API

Nous avons récemment apporté des modifications importantes à notre projet Time Manager pour configurer l'API RESTful. Voici un résumé détaillé des changements :

### 1. Configuration des routes API

Dans le fichier `lib/time_manager_web/router.ex`, nous avons ajouté un nouveau scope pour les routes API :
