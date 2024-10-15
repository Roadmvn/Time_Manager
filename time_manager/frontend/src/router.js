import { createRouter, createWebHistory } from 'vue-router'
import UserManager from './components/UserManager.vue'
import WorkingTimes from './components/WorkingTimes.vue'
import ChartManager from './components/ChartManager.vue'
import TutorialManager from './components/TutorialManager.vue'
import FlexibleWorkingTimeManager from './components/FlexibleWorkingTimeManager.vue'
import ReminderNotifications from './components/ReminderNotifications.vue'
import NightShiftManager from './components/NightShiftManager.vue'
import RoleManager from './components/RoleManager.vue'

const routes = [
  { path: '/users', component: UserManager },
  { path: '/working-times', component: WorkingTimes },
  { path: '/charts', component: ChartManager },
  { path: '/tutorials', component: TutorialManager },
  { path: '/flexible-times', component: FlexibleWorkingTimeManager },
  { path: '/reminders', component: ReminderNotifications },
  { path: '/night-shifts', component: NightShiftManager },
  { path: '/roles', component: RoleManager },
  { path: '/', redirect: '/users' }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router