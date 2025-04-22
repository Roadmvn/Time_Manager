# Time Manager

## Configuration des Secrets GitHub pour le Déploiement

Pour permettre le déploiement automatique via GitHub Actions, vous devez configurer les secrets suivants dans votre repository GitHub:

1. `SSH_PRIVATE_KEY` - Votre clé SSH privée pour se connecter au serveur
2. `KNOWN_HOSTS` - Le contenu du fichier known_hosts pour authentifier le serveur
3. `SSH_USER` - Le nom d'utilisateur pour la connexion SSH
4. `SSH_HOST` - L'adresse IP ou le nom d'hôte du serveur
5. `PROJECT_PATH` - Le chemin complet du projet sur le serveur

### Comment configurer les secrets GitHub

1. Allez dans votre repository GitHub
2. Cliquez sur "Settings" (Paramètres)
3. Dans le menu de gauche, cliquez sur "Secrets and variables" puis "Actions"
4. Cliquez sur "New repository secret" pour ajouter chacun des secrets mentionnés ci-dessus

### Génération des informations requises

#### Pour SSH_PRIVATE_KEY
```bash
# Générer une nouvelle paire de clés si nécessaire
ssh-keygen -t rsa -b 4096 -C "votre_email@example.com"
# Copier la clé privée
cat ~/.ssh/id_rsa
```

#### Pour KNOWN_HOSTS
```bash
ssh-keyscan -H votre_serveur >> ~/.ssh/known_hosts
cat ~/.ssh/known_hosts
```

### Workflow de déploiement

Le workflow de déploiement est défini dans le fichier `.github/workflows/main.yml`. Il se déclenche à chaque push sur la branche main et déploie automatiquement l'application sur le serveur configuré.

## Documentation du projet

Pour plus d'informations sur la configuration et l'utilisation du projet, veuillez consulter:

- [Documentation API](./time_manager/api/README.md)
- [Documentation Frontend](./time_manager/frontend/README.md)
- [Guide Docker](./time_manager/tuto.docker.md) 