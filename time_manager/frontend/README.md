# MonApp - Gestionnaire de Temps

## Description
TimeManager est une application de gestion du temps et des tâches, développée avec Vue.js 3 et Tailwind CSS. Elle permet aux utilisateurs de gérer leurs tâches, suivre leurs heures de travail et visualiser des graphiques de productivité.

## Prérequis
- Node.js (version 14.x ou supérieure)
- npm (normalement installé avec Node.js)

## Installation

1. Clonez le dépôt :
   ```
   git clone [URL_DU_REPO]
   cd [NOM_DU_DOSSIER]
   ```

2. Installez les dépendances :
   ```
   npm install
   ```

## Packages nécessaires

Ce projet utilise les packages suivants :

- `vue` (^3.2.13): Framework JavaScript progressif
- `vue-router` (^4.0.0): Routeur officiel pour Vue.js
- `tailwindcss` (^3.4.13): Framework CSS utilitaire
- `postcss` (^8.4.47): Outil pour transformer le CSS avec des plugins JavaScript
- `autoprefixer` (^10.4.20): Plugin PostCSS pour ajouter automatiquement des préfixes aux propriétés CSS
- `@vue/cli-service` (~5.0.0): Outil de build et de développement pour Vue.js
- `@vue/cli-plugin-babel` (~5.0.0): Plugin Babel pour Vue CLI
- `@vue/cli-plugin-eslint` (~5.0.0): Plugin ESLint pour Vue CLI
- `eslint` (^7.32.0): Outil d'analyse statique pour identifier les problèmes dans le code JavaScript
- `eslint-plugin-vue` (^8.0.3): Plugin ESLint avec des règles spécifiques à Vue.js

## Scripts disponibles

Dans le répertoire du projet, vous pouvez exécuter :

- `npm run serve` : Lance le serveur de développement
- `npm run build` : Compile et minifie le projet pour la production
- `npm run lint` : Exécute le linter pour vérifier et corriger le code

## Configuration

- Le fichier `tailwind.config.js` contient la configuration de Tailwind CSS.
- Le fichier `postcss.config.js` configure PostCSS et ses plugins.
- Le routage est géré dans `src/router.js`.

## Structure du projet

- `src/` : Contient le code source de l'application
  - `assets/` : Fichiers statiques (images, styles, etc.)
  - `components/` : Composants Vue réutilisables
  - `views/` : Composants Vue représentant des pages entières
  - `App.vue` : Composant racine de l'application
  - `main.js` : Point d'entrée de l'application

## Déploiement

Pour déployer l'application :

1. Exécutez `npm run build`
2. Le dossier `dist/` sera créé avec les fichiers optimisés pour la production
3. Déployez le contenu du dossier `dist/` sur votre serveur web

## Contribution

Les contributions sont les bienvenues ! Veuillez suivre ces étapes :

1. Forkez le projet
2. Créez votre branche de fonctionnalité (`git checkout -b feature/AmazingFeature`)
3. Committez vos changements (`git commit -m 'Add some AmazingFeature'`)
4. Poussez vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une Pull Request

# en cas de problème  
   rm -rf node_modules
   rm package-lock.json
   npm install



   npm install @vue/cli-plugin-babel
   npm install @vue/cli-plugin-babel --save-dev