<template>
  <div
    class="working-times bg-white dark:bg-gray-800 shadow-lg rounded-lg p-6 max-w-4xl mx-auto"
  >
    <h2
      class="text-3xl font-bold mb-6 text-gray-800 dark:text-white border-b pb-2"
    >
      Heures de travail
    </h2>

    <div class="mb-6">
      <label
        for="user-select"
        class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1"
        >Sélectionner un utilisateur</label
      >
      <select
        id="user-select"
        v-model="selectedUserId"
        @change="getWorkingTimes"
        class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
      >
        <option value="">Sélectionner un utilisateur</option>
        <option v-for="user in users" :key="user.id" :value="user.id">
          {{ user.username }} ({{ user.email }})
        </option>
      </select>
    </div>

    <form @submit.prevent="submitWorkingTime" class="space-y-4 mb-6">
      <div class="flex flex-wrap -mx-2">
        <div class="w-full md:w-1/2 px-2 mb-4 md:mb-0">
          <label
            for="start-time"
            class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1"
            >Heure de début</label
          >
          <input
            id="start-time"
            v-model="currentWorkingTime.start"
            type="datetime-local"
            class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
            required
          />
        </div>
        <div class="w-full md:w-1/2 px-2">
          <label
            for="end-time"
            class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1"
            >Heure de fin</label
          >
          <input
            id="end-time"
            v-model="currentWorkingTime.end"
            type="datetime-local"
            class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
            required
          />
        </div>
      </div>
      <div class="flex justify-end">
        <button
          type="submit"
          class="bg-green-500 hover:bg-green-600 text-white px-6 py-2 rounded-md transition duration-300 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-opacity-50"
        >
          <PlusIcon v-if="!isEditing" class="w-5 h-5 inline-block mr-1" />
          <RefreshCwIcon v-else class="w-5 h-5 inline-block mr-1" />
          {{ isEditing ? "Mettre à jour" : "Ajouter" }}
        </button>
      </div>
    </form>

    <div v-if="selectedUserId">
      <h3 class="text-xl font-semibold mb-4 text-gray-700 dark:text-gray-300">
        Plages horaires de travail
      </h3>
      <ul class="space-y-3">
        <li
          v-for="time in workingTimes"
          :key="time.id"
          class="bg-gray-50 dark:bg-gray-700 p-4 rounded-md shadow flex items-center justify-between transition-all duration-300 hover:shadow-md"
        >
          <span class="text-gray-700 dark:text-gray-200"
            >{{ formatDate(time.start) }} - {{ formatDate(time.end) }}</span
          >
          <span class="ml-2 text-blue-600 dark:text-blue-400"
            >(Jour : {{ time.day_hours }}h, Nuit : {{ time.night_hours }}h,
            Heures supp : {{ time.overtime_hours }}h)</span
          >
          <div class="space-x-2">
            <button
              @click="editWorkingTime(time)"
              class="bg-blue-500 hover:bg-blue-600 text-white px-3 py-1 rounded transition duration-300 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50"
            >
              <EditIcon class="w-4 h-4 inline-block mr-1" />
              Modifier
            </button>
            <button
              @click="deleteWorkingTime(time.id)"
              class="bg-red-500 hover:bg-red-600 text-white px-3 py-1 rounded transition duration-300 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-opacity-50"
            >
              <TrashIcon class="w-4 h-4 inline-block mr-1" />
              Supprimer
            </button>
          </div>
        </li>
      </ul>
    </div>
    <p v-else class="text-gray-500 dark:text-gray-400 text-center mt-4">
      Veuillez sélectionner un utilisateur pour voir ses plages horaires de
      travail.
    </p>
  </div>
</template>

<script>
import { ref, onMounted, watch } from "vue";
import { EditIcon, TrashIcon, PlusIcon, RefreshCwIcon } from "lucide-vue-next";
import { http } from "@/api/network/axios";

export default {
  name: "WorkingTimes",
  components: {
    EditIcon,
    TrashIcon,
    PlusIcon,
    RefreshCwIcon,
  },
  setup() {
    const workingTimes = ref([]);
    const currentWorkingTime = ref({ start: "", end: "" });
    const isEditing = ref(false);
    const users = ref([]);
    const selectedUserId = ref("");

    onMounted(() => {
      getUsers();
    });

    watch(selectedUserId, (newValue) => {
      if (newValue) {
        getWorkingTimes();
      } else {
        workingTimes.value = [];
      }
    });

    async function getUsers() {
      try {
        const response = await http.get("/users");
        users.value = response.data.data;
      } catch (error) {
        console.error(
          "Erreur lors de la récupération des utilisateurs:",
          error
        );
      }
    }

    async function getWorkingTimes() {
      if (!selectedUserId.value) return;
      try {
        const response = await http.get(`/workingtime/${selectedUserId.value}`);
        workingTimes.value = response.data.data.map((time) => {
          const start = new Date(time.start);
          const end = new Date(time.end);
          const { dayHours, nightHours, overtimeHours } = calculateHours(
            start,
            end
          );

          return {
            ...time,
            day_hours: dayHours,
            night_hours: nightHours,
            overtime_hours: overtimeHours,
          };
        });
      } catch (error) {
        console.error(
          "Erreur lors de la récupération des heures de travail:",
          error
        );
      }
    }

    async function createWorkingTime() {
      if (!selectedUserId.value) return;
      try {
        const start = new Date(currentWorkingTime.value.start);
        const end = new Date(currentWorkingTime.value.end);

        const { dayHours, nightHours, overtimeHours } = calculateHours(
          start,
          end
        );

        const response = await http.post("/workingtime", {
          working_time: {
            start: start.toISOString(),
            end: end.toISOString(),
            user_id: selectedUserId.value,
            day_hours: dayHours,
            night_hours: nightHours,
            overtime_hours: overtimeHours,
          },
        });
        console.log("RESPONSE", response.data.data);

        // Recalcule les heures avant d'ajouter la nouvelle entrée
        const newWorkingTime = {
          ...response.data.data,
          day_hours: dayHours,
          night_hours: nightHours,
          overtime_hours: overtimeHours,
        };
        workingTimes.value.push(newWorkingTime);
        currentWorkingTime.value = { start: "", end: "" }; // Réinitialise le formulaire
      } catch (error) {
        console.error(
          "Erreur lors de la création des heures de travail:",
          error
        );
      }
    }

    async function updateWorkingTime() {
      if (!selectedUserId.value) return;
      try {
        const start = new Date(currentWorkingTime.value.start);
        const end = new Date(currentWorkingTime.value.end);
        const { dayHours, nightHours, overtimeHours } = calculateHours(
          start,
          end
        );

        const response = await http.put(
          `/workingtime/${currentWorkingTime.value.id}`,
          {
            working_time: {
              start: start.toISOString(),
              end: end.toISOString(),
              day_hours: dayHours,
              night_hours: nightHours,
              overtime_hours: overtimeHours,
            },
          }
        );

        // Mettre à jour la liste des heures de travail dans l'état local
        const updatedWorkingTime = response.data.data;
        const index = workingTimes.value.findIndex(
          (wt) => wt.id === updatedWorkingTime.id
        );
        if (index !== -1) {
          workingTimes.value[index] = updatedWorkingTime;
        }
        currentWorkingTime.value = { start: "", end: "" };
        isEditing.value = false;
      } catch (error) {
        console.error(
          "Erreur lors de la mise à jour des heures de travail:",
          error
        );
      }
    }

    async function deleteWorkingTime(id) {
      if (!selectedUserId.value) return;
      try {
        await http.delete(`/workingtime/${id}`);
        workingTimes.value = workingTimes.value.filter((wt) => wt.id !== id);
      } catch (error) {
        console.error(
          "Erreur lors de la suppression des heures de travail:",
          error
        );
      }
    }

    function calculateHours(start, end) {
      const NIGHT_START = 22; // Heure de début du travail de nuit (22h)
      const NIGHT_END = 6; // Heure de fin du travail de nuit (6h)
      const MAX_HOURS = 8; // Nombre d'heures normales avant de considérer les heures supplémentaires

      let totalNightHours = 0;
      let totalDayHours = 0;
      let current = new Date(start);

      while (current < end) {
        const nextHour = new Date(current);
        nextHour.setHours(current.getHours() + 1, 0, 0, 0);

        if (nextHour > end) {
          nextHour.setTime(end.getTime());
        }

        const isNightTime =
          current.getHours() >= NIGHT_START || current.getHours() < NIGHT_END;
        const hoursWorked = (nextHour - current) / (1000 * 60 * 60);

        if (isNightTime) {
          totalNightHours += hoursWorked;
        } else {
          totalDayHours += hoursWorked;
        }

        current = nextHour;
      }

      const totalHours = totalDayHours + totalNightHours;
      const overtimeHours = totalHours > MAX_HOURS ? totalHours - MAX_HOURS : 0;

      return {
        dayHours: totalDayHours,
        nightHours: totalNightHours,
        overtimeHours,
      };
    }

    function editWorkingTime(time) {
      currentWorkingTime.value = { ...time };
      isEditing.value = true;
    }

    function submitWorkingTime() {
      if (isEditing.value) {
        updateWorkingTime();
      } else {
        createWorkingTime();
      }
    }

    function formatDate(date) {
      const options = {
        year: "numeric",
        month: "2-digit",
        day: "2-digit",
        hour: "2-digit",
        minute: "2-digit",
      };
      return new Date(date).toLocaleDateString("fr-FR", options);
    }

    return {
      workingTimes,
      currentWorkingTime,
      isEditing,
      users,
      selectedUserId,
      getUsers,
      getWorkingTimes,
      createWorkingTime,
      updateWorkingTime,
      deleteWorkingTime,
      editWorkingTime,
      submitWorkingTime,
      formatDate,
    };
  },
};
</script>
