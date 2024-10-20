import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from './App.vue'
import router from './router'
import './assets/main.css'  // Ajoutez cette ligne
import Chart from 'chart.js/auto'

Chart.defaults.color = '#666'
Chart.defaults.font.family = 'Arial, sans-serif'

const app = createApp(App)
app.use(createPinia())
app.use(router)
app.mount('#app')
