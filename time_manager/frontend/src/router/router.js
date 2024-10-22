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
			{ path: '/', redirect: '/users' },
			{ path: '/users', component: UserManager },
			{ path: '/working-times', component: WorkingTimes },
			{ path: '/charts', component: ChartManager },
			{ path: '/tutorial', component: PdfViewer, props: { pdfFilePath: 'tutoriel.pdf' } },
			{ path: '/roles', component: RoleManager },
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
router.beforeEach((to, from, next) => {
	const authStore = useAuthStore();
	const isAuthenticated = authStore.isAuthenticated
	const userRole = authStore.userRole;
	console.log("ISAUTH", isAuthenticated);

	if (to.matched.some(record => record.meta.requiresAuth) && !isAuthenticated) {
	  next('/login')
	} else if (to.matched.some(record => record.meta.requiresAdmin) && userRole !== 'admin') {
	  next('/')
	} else if (to.matched.some(record => record.meta.requiresManager) && !['admin', 'manager'].includes(userRole)) {
	  next('/')
	} else {
	  next()
	}
  })



export default router
