import { createRouter, createWebHistory } from 'vue-router'
import UserManager from './components/UserManager.vue'
import WorkingTimes from './components/WorkingTimes.vue'
import ChartManager from './components/ChartManager.vue'
import RoleManager from './components/RoleManager.vue'
import PdfViewer from './components/PdfViewer.vue'

const routes = [
  { path: '/users', component: UserManager },
  { path: '/working-times', component: WorkingTimes },
  { path: '/charts', component: ChartManager },
 { path: '/tutorial', component: PdfViewer, props: { pdfFilePath: 'tutoriel.pdf' } },
  { path: '/roles', component: RoleManager },
  { path: '/', redirect: '/users' }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
