import { createRouter, createWebHistory } from 'vue-router'
import store from './store'
import UserManager from './components/UserManager.vue'
import WorkingTimes from './components/WorkingTimes.vue'
import ChartManager from './components/ChartManager.vue'
import RoleManager from './components/RoleManager.vue'
import PdfViewer from './components/PdfViewer.vue'
import LoginForm from './components/LoginForm.vue'
import Registration from './components/UserRegistration.vue'
import ProfileManagement from './components/ProfileManagement.vue'
import TeamManager from './components/TeamManager.vue'
import TeamWorkingTime from './components/TeamWorkingTime.vue'

const routes = [
  { path: '/users', component: UserManager },
  { path: '/working-times', component: WorkingTimes },
  { path: '/charts', component: ChartManager },
  { path: '/tutorial', component: PdfViewer, props: { pdfFilePath: 'tutoriel.pdf' } },
  { path: '/roles', component: RoleManager },
  { path: '/', redirect: '/users' },
  { path: '/login', component: LoginForm },
  { path: '/register', component: Registration },
  { 
    path: '/profile', 
    component: ProfileManagement,
    meta: { requiresAuth: true }
  },
  { 
    path: '/roles', 
    component: RoleManager,
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  { 
    path: '/teams', 
    component: TeamManager,
    meta: { requiresAuth: true, requiresManager: true }
  },
  { 
    path: '/team-working-time', 
    component: TeamWorkingTime,
    meta: { requiresAuth: true, requiresManager: true }
  },
  { path: '/auth', component: () => import('./components/AuthenticationForm.vue') }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  const isAuthenticated = store.getters['auth/isAuthenticated']
  const userRole = store.getters['auth/userRole']

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
