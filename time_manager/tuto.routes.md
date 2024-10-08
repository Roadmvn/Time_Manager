# Tutoriel : Configuration des Routes et Contrôleurs pour Time Manager

Ce tutoriel explique les modifications apportées aux routes et aux contrôleurs pour le projet Time Manager.

## 1. Configuration des Routes

Dans le fichier `lib/time_manager_web/router.ex`, nous avons ajouté un nouveau scope pour les routes API :


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

## 2. Modification des Contrôleurs

### UserController

Dans `lib/time_manager_web/controllers/user_controller.ex`, nous avons modifié la fonction `index` pour prendre en compte les paramètres email et username :
elixir
def index(conn, %{"email" => email, "username" => username}) do
users = Accounts.list_users(email, username)
render(conn, :index, users: users)
end


### WorkingTimeController

Dans `lib/time_manager_web/controllers/working_time_controller.ex`, nous avons ajouté des fonctions pour gérer les temps de travail :


elixir
def index(conn, %{"user_id" => user_id, "start" => start, "end" => end_time}) do
workingtimes = Times.list_workingtimes(user_id, start, end_time)
render(conn, :index, workingtimes: workingtimes)
end
def show(conn, %{"user_id" => user_id, "id" => id}) do
working_time = Times.get_working_time!(id, user_id)
render(conn, :show, working_time: working_time)
end
def create(conn, %{"user_id" => user_id, "working_time" => working_time_params}) do
with {:ok, %WorkingTime{} = working_time} <- Times.create_working_time(user_id, working_time_params) do
conn
|> put_status(:created)
|> put_resp_header("location", ~p"/api/workingtime/#{user_id}/#{working_time.id}")
|> render(:show, working_time: working_time)
end
end

### ClockController

Dans `lib/time_manager_web/controllers/clock_controller.ex`, nous avons ajouté des fonctions pour gérer les horloges :


elixir
def index(conn, %{"user_id" => user_id}) do
clocks = Times.list_clocks(user_id)
render(conn, :index, clocks: clocks)
end
def create(conn, %{"user_id" => user_id, "clock" => clock_params}) do
with {:ok, %Clock{} = clock} <- Times.create_clock(user_id, clock_params) do
conn
|> put_status(:created)
|> put_resp_header("location", ~p"/api/clocks/#{user_id}")
|> render(:show, clock: clock)
end
end
bash
mix phx.routes
Ce tutoriel mis à jour explique en détail les modifications apportées aux routes et aux contrôleurs, et fournit des instructions pour les étapes suivantes du développement.

elixir
def index(conn, %{"user_id" => user_id}) do
clocks = Times.list_clocks(user_id)
render(conn, :index, clocks: clocks)
end
def create(conn, %{"user_id" => user_id, "clock" => clock_params}) do
with {:ok, %Clock{} = clock} <- Times.create_clock(user_id, clock_params) do
conn
|> put_status(:created)
|> put_resp_header("location", ~p"/api/clocks/#{user_id}")
|> render(:show, clock: clock)
end
end



Ces modifications permettent de gérer les requêtes API pour les utilisateurs, les temps de travail et les horloges, conformément aux spécifications du projet Time Manager.

## 3. Vérification des Routes

Pour vérifier que toutes les routes ont été correctement configurées, vous pouvez utiliser la commande suivante dans votre terminal :

bash
mix phx.routes


Cette commande affichera toutes les routes disponibles dans votre application, y compris les nouvelles routes API que nous venons de configurer.

## 4. Prochaines étapes

Après avoir configuré ces routes et contrôleurs, assurez-vous de :

1. Implémenter les fonctions correspondantes dans vos modules `Accounts` et `Times` (par exemple, `list_users/2`, `list_workingtimes/3`, `create_clock/2`, etc.).
2. Créer les vues JSON appropriées pour chaque contrôleur.
3. Tester chaque endpoint à l'aide d'un outil comme Postman pour vous assurer qu'ils fonctionnent comme prévu.

N'oubliez pas de gérer les cas d'erreur et d'ajouter des validations appropriées dans vos changeset et vos contrôleurs.