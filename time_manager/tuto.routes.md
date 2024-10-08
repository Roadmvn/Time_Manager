        modified:   time_manager/lib/time_manager_web/controllers/clock_controller.ex
        modified:   time_manager/lib/time_manager_web/controllers/user_controller.ex
        modified:   time_manager/lib/time_manager_web/controllers/working_time_controller.ex
        modified:   time_manager/lib/time_manager_web/router.ex
        new file:   time_manager/tuto.routes.md


    elixir

scope "/api", TimeManagerWeb do
pipe_through :api

# User routes

get "/users", UserController, :index
get "/users/:id", UserController, :show
post "/users", UserController, :create
put "/users/:id", UserController, :update
delete "/users/:id", UserController, :delete

# WorkingTime routes

get "/workingtime/:user_id", WorkingTimeController, :index
get "/workingtime/:user_id/:id", WorkingTimeController, :show
post "/workingtime/:user_id", WorkingTimeController, :create
put "/workingtime/:id", WorkingTimeController, :update
delete "/workingtime/:id", WorkingTimeController, :delete

# Clock routes

get "/clocks/:user_id", ClockController, :index
post "/clocks/:user_id", ClockController, :create
end

Ces routes définissent les endpoints API pour les utilisateurs, les temps de travail et les horloges.

### 2. Modification des contrôleurs

#### UserController

Dans `lib/time_manager_web/controllers/user_controller.ex`, nous avons modifié la fonction `index` pour prendre en compte les paramètres email et username :

elixir
def index(conn, params) do
users = Accounts.list_users(params["email"], params["username"])
render(conn, :index, users: users)
end

#### WorkingTimeController

Dans `lib/time_manager_web/controllers/working_time_controller.ex`, nous avons ajouté des fonctions pour gérer les temps de travail, notamment :

- `index/2` : Liste les temps de travail pour un utilisateur donné, avec filtrage optionnel par date.
- `show/2` : Affiche un temps de travail spécifique.
- `create/2` : Crée un nouveau temps de travail.
- `update/2` : Met à jour un temps de travail existant.
- `delete/2` : Supprime un temps de travail.

#### ClockController

Dans `lib/time_manager_web/controllers/clock_controller.ex`, nous avons ajouté des fonctions pour gérer les horloges :

- `index/2` : Liste les horloges pour un utilisateur donné.
- `create/2` : Crée une nouvelle entrée d'horloge.

### 3. Modification du contexte Times

Dans `lib/time_manager/times.ex`, nous avons ajouté et modifié plusieurs fonctions pour supporter les nouvelles fonctionnalités :

- `list_workingtimes/3` : Cette fonction a été modifiée pour accepter des paramètres de filtrage par date.
- `filter_by_date_range/3` : Une nouvelle fonction privée pour filtrer les temps de travail par plage de dates.

### 4. Prochaines étapes

Après ces modifications, assurez-vous de :

1. Tester chaque endpoint API pour vérifier son bon fonctionnement.
2. Mettre à jour la documentation API si nécessaire.
3. Implémenter la gestion des erreurs et les validations appropriées.
4. Considérer l'ajout de tests pour les nouvelles fonctionnalités.

### 5. Comment tester les nouvelles routes

Vous pouvez utiliser des outils comme Postman ou cURL pour tester les nouvelles routes API. Par exemple :

bash
Lister les utilisateurs
curl http://localhost:4000/api/users
Créer un nouveau temps de travail
curl -X POST http://localhost:4000/api/workingtime/1 \
-H "Content-Type: application/json" \
-d '{"start": "2023-10-25T09:00:00", "end": "2023-10-25T17:00:00"}'
Lister les horloges d'un utilisateur
curl http://localhost:4000/api/clocks/1

N'oubliez pas de remplacer les IDs et les données selon vos besoins spécifiques.
