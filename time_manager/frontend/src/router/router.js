import { createRouter, createWebHistory } from 'vue-router'
import UserManager from '../components/UserManager.vue'
import WorkingTimes from '../components/WorkingTimes.vue'
import ChartManager from '../components/ChartManager.vue'
import RoleManager from '../components/RoleManager.vue'
import PdfViewer from '../components/PdfViewer.vue'
import ProfileManagement from '../components/ProfileManagement.vue'
import TeamManager from '../components/TeamManager.vue'
import TeamWorkingTime from '../components/TeamWorkingTime.vue'
import { useAuthStore } from '../store/auth';

const routes = [
	{
		/**
		 * This path contains every pages that aren't locked behind the signin.
		 * This includes, hero, signin, signup, about and that's it.
		 */
		path: '/',
		children: [
			{ path: '', redirect: "auth"},
			{
				path: '/auth',
				component: () => import('../components/AuthenticationForm.vue'),
				meta: { forbiddenAfterAuth: true },
			}
		],
	},
	{
		/**
		 * This path contains every pages that are locked behind the signin and not accesible by the public.
		 * This includes agility, rollcall, materials, retrospective, blog, ...
		 */
		path: '/app',
		children: [
			// { path: '/', redirect: '/app/users' },
			{ path: '/app/users', component: UserManager },
			{ path: '/app/working-times', component: WorkingTimes },
			{ path: '/app/charts', component: ChartManager },
			{ path: '/app/tutorial', component: PdfViewer, props: { pdfFilePath: 'tutoriel.pdf' } },
			{ path: '/app/roles', component: RoleManager },
			{
				path: '/profile',
				component: ProfileManagement,
			},
			{
				path: '/roles',
				component: RoleManager,
				meta: { requiresAdmin: true }
			},
			{
				path: '/teams',
				component: TeamManager,
				meta: { requiresManager: true }
			},
			{
				path: '/team-working-time',
				component: TeamWorkingTime,
				meta: { requiresManager: true }
			},
		],
		meta: {
			requiresAuth: true,
		},
	},

]

const router = createRouter({
  history: createWebHistory(),
  routes
})

/* eslint-disable */
router.beforeEach(async (to, from, next) => {
	const authStore = useAuthStore();
	const isAuth = authStore.isAuth;
	const userRole = authStore.userRole;

	if (to.matched.some(record => record.meta.requiresAuth)) {
		if (!isAuth) {
		  // Redirigez vers la page de connexion si non authentifié
		  return next('/auth');
		}

		// Vérifiez les rôles pour les routes nécessitant des autorisations spécifiques
		if (to.matched.some(record => record.meta.requiresAdmin) && userRole !== 'admin') {
		  return next('/'); // Rediriger vers la page d'accueil si pas admin
		}
		if (to.matched.some(record => record.meta.requiresManager) && !['admin', 'manager'].includes(userRole)) {
		  return next('/'); // Rediriger vers la page d'accueil si pas manager
		}
	  } else if (to.matched.some(record => record.meta.forbiddenAfterAuth) && isAuth) {
		// Si l'utilisateur est déjà authentifié et essaie d'accéder à la page d'authentification, redirigez-le
		return next('/app'); // Redirection vers l'application principale
	  }

	  // Continuer vers la route demandée
	  next();
});


export default router
