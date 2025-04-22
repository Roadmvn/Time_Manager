# Tutoriel Docker pour Time Manager

Ce tutoriel vous guidera à travers le processus de configuration et d'exécution de votre projet Time Manager en utilisant Docker.

## Prérequis

- Docker
- Docker Compose

## Structure du projet
time_manager/
├── api/
│ ├── Dockerfile
│ └── init-db.sh
├── frontend/
│ └── Dockerfile
├── docker-compose.yml
├── .env
└── tuto.docker.md



## Configuration

1. Créez un fichier `.env` à la racine du projet avec le contenu suivant :

```env
# PostgreSQL
POSTGRES_DB=<nom_de_votre_base_de_donnees>
POSTGRES_USER=<votre_utilisateur>
POSTGRES_PASSWORD=<votre_mot_de_passe>

# Backend
BACKEND_PORT=4000
SECRET_KEY_BASE=<votre_cle_secrete>
SIGNING_SALT=<votre_sel_de_signature>

# Frontend
FRONTEND_PORT=8080

# General
PROJECT_NAME=time_manager
```

Assurez-vous de remplacer les valeurs entre `<>` par vos propres informations sécurisées.

2. Assurez-vous que les Dockerfiles et le script `init-db.sh` sont présents dans les dossiers appropriés.

## Construction et démarrage des conteneurs

1. Ouvrez un terminal à la racine du projet.

2. Construisez les images Docker :

3. Démarrez les conteneurs :



L'option `-d` permet de démarrer les conteneurs en arrière-plan.

## Accès aux services

- Frontend : http://localhost:8080
- Backend API : http://localhost:4000
- Base de données : accessible via le port 5432 (par défaut pour PostgreSQL)

## Commandes utiles

- Voir les logs des conteneurs :
  ```bash
  docker-compose logs
  ```

- Arrêter les conteneurs :
  ```bash
  docker-compose down
  ```

- Redémarrer un service spécifique :
  ```bash
  docker-compose restart [service_name]
  ```

- Exécuter des commandes dans un conteneur :
  ```bash
  docker-compose exec [service_name] [command]
  ```
  Par exemple, pour exécuter des migrations dans le backend :
  ```bash
  docker-compose exec backend mix ecto.migrate
  ```

## Dépannage

1. Si vous rencontrez des problèmes de connexion à la base de données, assurez-vous que les variables d'environnement dans le fichier `.env` correspondent à celles utilisées dans votre configuration Phoenix.

2. Si le frontend ne parvient pas à communiquer avec le backend, vérifiez que l'URL de l'API dans votre code frontend pointe vers `http://localhost:4000` (ou l'URL appropriée si vous avez modifié la configuration).

3. En cas de problèmes persistants, essayez de reconstruire les images et de redémarrer les conteneurs :
   ```bash
   docker-compose down
   docker-compose build
   docker-compose up -d
   docker-compose up
   ```



## Conclusion

Cette configuration Docker vous permet de développer et de déployer facilement votre application Time Manager. N'hésitez pas à ajuster les configurations selon vos besoins spécifiques.


# Problème de port déjà utilisé

##  Nettoyez les ressources Docker :
##  Parfois, des problèmes peuvent survenir à cause de ressources Docker existantes. Essayez de nettoyer votre environnement Docker :

   docker-compose down -v
   docker system prune -a

## Reconstruisez les images :
## Après avoir effectué ces modifications, essayez de reconstruire vos images Docker :


   docker-compose build --no-cache
   docker-compose up




   docker-compose build backend
   docker-compose up backend