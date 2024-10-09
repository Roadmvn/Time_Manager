import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import './assets/main.css'  // Ajoutez cette ligne
import Chart from 'chart.js/auto'

Chart.defaults.color = '#666'
Chart.defaults.font.family = 'Arial, sans-serif'

createApp(App).use(router).mount('#app')
