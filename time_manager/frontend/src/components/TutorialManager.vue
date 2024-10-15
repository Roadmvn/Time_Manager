<template>
  <div class="tutorial-manager">
    <h2>Tutoriels de formation</h2>
    <ul>
      <li v-for="tutorial in tutorials" :key="tutorial.id">
        <h3>{{ tutorial.title }}</h3>
        <p>{{ tutorial.content }}</p>
        <video v-if="tutorial.video_url" :src="tutorial.video_url" controls></video>
      </li>
    </ul>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import http from '@/http-common'

export default {
  name: 'TutorialManager',
  setup() {
    const tutorials = ref([])

    const fetchTutorials = async () => {
      try {
        const response = await http.get('/tutorials')
        tutorials.value = response.data.data
      } catch (error) {
        console.error('Erreur lors de la récupération des tutoriels:', error)
      }
    }

    onMounted(fetchTutorials)

    return {
      tutorials
    }
  }
}
</script>