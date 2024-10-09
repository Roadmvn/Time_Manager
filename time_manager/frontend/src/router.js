import { createRouter, createWebHistory } from 'vue-router'
import UserManager from './components/UserManager.vue'
import WorkingTimes from './components/WorkingTimes.vue'
import ClockManager from './components/ClockManager.vue'
import ChartManager from './components/ChartManager.vue'

const routes = [
  { path: '/users', component: UserManager },
  { path: '/tasks', component: ClockManager }, // Supposons que ClockManager gère les tâches
  { path: '/working-times', component: WorkingTimes },
  { path: '/charts', component: ChartManager },
  { path: '/', redirect: '/users' } // Redirection par défaut
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router