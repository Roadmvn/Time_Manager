import { createRouter, createWebHistory } from 'vue-router'
import UserManager from './components/UserManager.vue'
import WorkingTimes from './components/WorkingTimes.vue'
import ChartManager from './components/ChartManager.vue'

const routes = [
  { path: '/users', component: UserManager },
  { path: '/working-times', component: WorkingTimes },
  { path: '/charts', component: ChartManager },
  { path: '/', redirect: '/users' }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
