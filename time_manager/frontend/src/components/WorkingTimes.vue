<template>
  <div
    class="working-times bg-white dark:bg-gray-800 shadow-lg rounded-lg p-8 max-w-4xl mx-auto"
  >
    <div class="relative mb-8">
      <div class="absolute inset-0 rounded-lg -m-2"></div>
      <h2 class="relative text-3xl font-bold text-gray-800 dark:text-white">
        Heures de travail
        <span
          class="block mt-2 text-sm font-normal text-gray-500 dark:text-gray-400"
        >
          Gérez les temps de travail des utilisateurs
        </span>
      </h2>
    </div>

    <transition
      enter-active-class="transition-all duration-300"
      enter-from-class="opacity-0 transform -translate-y-4"
      enter-to-class="opacity-100 transform translate-y-0"
      leave-active-class="transition-all duration-200"
      leave-from-class="opacity-100 transform translate-y-0"
      leave-to-class="opacity-0 transform -translate-y-4"
    >
      <div
        v-if="nightShiftAlert"
        class="mb-6 bg-red-50 dark:bg-red-900/20 border-l-4 border-red-500 p-4 rounded-r-lg"
        role="alert"
      >
        <div class="flex items-center gap-3">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-5 w-5 text-red-500"
            viewBox="0 0 20 20"
            fill="currentColor"
          >
            <path
              fill-rule="evenodd"
              d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z"
              clip-rule="evenodd"
            />
          </svg>
          <div>
            <p class="font-medium text-red-800 dark:text-red-200">Attention!</p>
            <p class="text-sm text-red-700 dark:text-red-300">
              Cet utilisateur a travaillé plus de 5 nuits ce mois-ci ou a fait 3
              jours d'affilée de travail nocturne!
            </p>
          </div>
        </div>
      </div>
    </transition>

    <div class="mb-8">
      <div class="group">
        <div class="relative transition-all duration-300 rounded-lg" v-if="role !== 'user'">
          <select
            v-model="selectedUserId"
            @change="getWorkingTimes"
            class="w-full px-4 py-3 pl-12 pr-4 border-2 border-gray-200 rounded-lg shadow-sm transition-all duration-300 ease-in-out focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white group-hover:border-blue-500/50"
          >
            <option value="">Sélectionner un utilisateur</option>
            <option v-for="user in users" :key="user.id" :value="user.id">
              {{ user.username }} ({{ user.email }})
            </option>
          </select>
          <span
            class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 transition-transform duration-300 group-hover:scale-110"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="h-6 w-6"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
              />
            </svg>
          </span>
        </div>
      </div>
    </div>

    <form
      @submit.prevent="submitWorkingTime"
      class="space-y-6 mb-8 bg-gray-50 dark:bg-gray-800/50 p-6 rounded-lg"
    >
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div class="space-y-2">
          <label
            class="block text-sm font-medium text-gray-700 dark:text-gray-300"
          >
            Heure de début
          </label>
          <input
            v-model="currentWorkingTime.start"
            type="datetime-local"
            class="w-full px-4 py-2.5 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white transition-colors duration-200"
            required
          />
        </div>
        <div class="space-y-2">
          <label
            class="block text-sm font-medium text-gray-700 dark:text-gray-300"
          >
            Heure de fin
          </label>
          <input
            v-model="currentWorkingTime.end"
            type="datetime-local"
            class="w-full px-4 py-2.5 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white transition-colors duration-200"
            required
          />
        </div>
      </div>
      <div class="flex justify-end">
        <button
          type="submit"
          class="bg-blue-500 hover:bg-blue-600 text-white px-6 py-2.5 rounded-lg transition duration-200 ease-in-out transform hover:-translate-y-0.5 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50 shadow-sm hover:shadow-md"
        >
          <span v-if="!isEditing">Ajouter</span>
          <span v-else>Mettre à jour</span>
        </button>
      </div>
    </form>

    <div v-if="selectedUserId" class="space-y-6">
      <div class="flex justify-between items-center mb-6">
        <h3 class="text-xl font-semibold text-gray-700 dark:text-gray-300">
          Plages horaires de travail
        </h3>
        <button
          @click="downloadTimesheet"
          :disabled="!workingTimes.length"
          class="bg-indigo-500 hover:bg-indigo-600 disabled:bg-gray-400 text-white px-5 py-2.5 rounded-lg transition duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-opacity-50 shadow-sm hover:shadow-md disabled:hover:shadow-sm flex items-center space-x-2"
        >
          <span>📥</span>
          <span>Télécharger le timesheet</span>
        </button>
      </div>

      <ul class="space-y-4">
        <li
          v-for="time in paginatedWorkingTimes"
          :key="time.id"
          class="bg-gray-50 dark:bg-gray-700 p-5 rounded-lg shadow-sm hover:shadow-md transition-all duration-200 border border-gray-100 dark:border-gray-600 flex flex-col sm:flex-row items-center justify-between gap-4"
        >
          <div class="flex flex-col sm:flex-row items-center gap-4 w-full">
            <span class="text-gray-700 dark:text-gray-200 font-medium">
              {{ formatDate(time.start) }} - {{ formatDate(time.end) }}
            </span>
            <span class="text-blue-600 dark:text-blue-400">
              (Jour : {{ time.day_hours }}h, Nuit : {{ time.night_hours }}h,
              Heures supp : {{ time.overtime_hours }}h)
            </span>
          </div>
          <div class="flex gap-3">
            <button
              @click="editWorkingTime(time)"
              class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded-lg transition duration-200 ease-in-out transform hover:-translate-y-0.5 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50"
            >
              Modifier
            </button>
            <button v-if="role ==='admin'"
              @click="deleteWorkingTime(time.id)"
              class="bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-lg transition duration-200 ease-in-out transform hover:-translate-y-0.5 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-opacity-50"
            >
              Supprimer
            </button>
          </div>
        </li>
      </ul>

      <div class="mt-8 flex justify-center items-center space-x-2">
        <button
          @click="prevPage"
          :disabled="currentPage === 1"
          class="px-4 py-2 bg-gray-200 dark:bg-gray-600 rounded-lg hover:bg-gray-300 dark:hover:bg-gray-500 disabled:bg-gray-100 dark:disabled:bg-gray-700 transition duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-gray-400"
        >
          &laquo; Précédent
        </button>
        <span
          v-for="page in totalPages"
          :key="page"
          @click="setPage(page)"
          class="px-4 py-2 cursor-pointer rounded-lg transition duration-200 ease-in-out"
          :class="{
            'bg-indigo-500 text-white shadow-sm': page === currentPage,
            'bg-gray-200 dark:bg-gray-600 hover:bg-gray-300 dark:hover:bg-gray-500':
              page !== currentPage,
          }"
        >
          {{ page }}
        </span>
        <button
          @click="nextPage"
          :disabled="currentPage === totalPages"
          class="px-4 py-2 bg-gray-200 dark:bg-gray-600 rounded-lg hover:bg-gray-300 dark:hover:bg-gray-500 disabled:bg-gray-100 dark:disabled:bg-gray-700 transition duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-gray-400"
        >
          Suivant &raquo;
        </button>
      </div>
    </div>

    <p v-else class="text-gray-500 dark:text-gray-400 text-center mt-8 text-lg">
      Veuillez sélectionner un utilisateur pour voir ses plages horaires de
      travail.
    </p>
  </div>
</template>

<script>
import { ref, onMounted, watch, computed } from "vue";
import { http } from "@/api/network/axios";
import * as XLSX from "xlsx";
import { useAuthStore } from '@/store/auth';

export default {
  name: "WorkingTimes",
  setup() {
    const workingTimes = ref([]);
    const currentWorkingTime = ref({ start: "", end: "" });
    const isEditing = ref(false);
    const users = ref([]);
    const selectedUserId = ref("");
    const nightShiftAlert = ref(false);
    const authStore = useAuthStore();
	const user = computed(() => authStore.user);
    const role = computed(() => user.value.role)

    const currentPage = ref(1);
    const pageSize = ref(6);

    onMounted(() => {
        if (role.value === "user") {
            selectedUserId.value = user.value.id;
            getWorkingTimes()
        } else {
            getUsers();
        }
      console.log("AUTH", role.value);
    });

    watch(selectedUserId, (newValue) => {
      if (newValue) {
        getWorkingTimes();
      } else {
        workingTimes.value = [];
        nightShiftAlert.value = false;
      }
    });

    const sortedWorkingTimes = computed(() => {
      return [...workingTimes.value].sort(
        (a, b) => new Date(a.start) - new Date(b.start)
      );
    });

    const paginatedWorkingTimes = computed(() => {
      const start = (currentPage.value - 1) * pageSize.value;
      const end = start + pageSize.value;
      return sortedWorkingTimes.value.slice(start, end);
    });

    const totalPages = computed(() => {
      return Math.ceil(sortedWorkingTimes.value.length / pageSize.value);
    });

    function prevPage() {
      if (currentPage.value > 1) currentPage.value--;
    }

    function nextPage() {
      if (currentPage.value < totalPages.value) currentPage.value++;
    }

    function setPage(page) {
      currentPage.value = page;
    }

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
        const response = await http.get(
          `/workingtimes/${selectedUserId.value}`
        );
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
        checkNightShiftConditions();
      } catch (error) {
        console.error(
          "Erreur lors de la récupération des heures de travail:",
          error
        );
      }
    }

    function calculateHours(start, end) {
      const NIGHT_START = 22;
      const NIGHT_END = 6;
      const MAX_HOURS = 8;

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
        dayHours: Number(totalDayHours.toFixed(2)),
        nightHours: Number(totalNightHours.toFixed(2)),
        overtimeHours: Number(overtimeHours.toFixed(2)),
      };
    }

    function checkNightShiftConditions() {
      const now = new Date();
      const thisMonth = `${now.getFullYear()}-${String(
        now.getMonth() + 1
      ).padStart(2, "0")}`;

      let nightShiftDaysThisMonth = 0;
      let consecutiveNightShifts = 0;
      let previousNightShiftDate = null;

      workingTimes.value.forEach((time) => {
        const start = new Date(time.start);
        const month = `${start.getFullYear()}-${String(
          start.getMonth() + 1
        ).padStart(2, "0")}`;

        if (month === thisMonth && time.night_hours > 0) {
          nightShiftDaysThisMonth++;
        }

        if (time.night_hours > 0) {
          const currentDate = start.toISOString().split("T")[0];
          if (previousNightShiftDate) {
            const previousDate = new Date(previousNightShiftDate);
            const diffInDays =
              (new Date(currentDate) - previousDate) / (1000 * 60 * 60 * 24);
            if (diffInDays === 1) {
              consecutiveNightShifts++;
            } else {
              consecutiveNightShifts = 1;
            }
          } else {
            consecutiveNightShifts = 1;
          }
          previousNightShiftDate = currentDate;
        }
      });

      if (nightShiftDaysThisMonth > 5 || consecutiveNightShifts >= 3) {
        nightShiftAlert.value = true;
      } else {
        nightShiftAlert.value = false;
      }
    }

    function editWorkingTime(time) {
      currentWorkingTime.value = { ...time };
      isEditing.value = true;
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

        const response = await http.post("/workingtimes", {
          working_time: {
            start: start.toISOString(),
            end: end.toISOString(),
            user_id: selectedUserId.value,
            day_hours: dayHours,
            night_hours: nightHours,
            overtime_hours: overtimeHours,
          },
        });

        const newWorkingTime = {
          ...response.data.data,
          day_hours: dayHours,
          night_hours: nightHours,
          overtime_hours: overtimeHours,
        };
        workingTimes.value.push(newWorkingTime);
        currentWorkingTime.value = { start: "", end: "" };

        checkNightShiftConditions();
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
          `/workingtimes/${currentWorkingTime.value.id}`,
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

        const updatedWorkingTime = response.data.data;
        const index = workingTimes.value.findIndex(
          (wt) => wt.id === updatedWorkingTime.id
        );
        if (index !== -1) {
          workingTimes.value[index] = updatedWorkingTime;
        }
        currentWorkingTime.value = { start: "", end: "" };
        isEditing.value = false;

        checkNightShiftConditions();
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
        await http.delete(`/workingtimes/${id}`);
        workingTimes.value = workingTimes.value.filter((wt) => wt.id !== id);

        checkNightShiftConditions();
      } catch (error) {
        console.error(
          "Erreur lors de la suppression des heures de travail:",
          error
        );
      }
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

    function downloadTimesheet() {
      if (!workingTimes.value.length || !selectedUserId.value) return;

      const selectedUser = users.value.find(
        (user) => user.id === selectedUserId.value
      );
      if (!selectedUser) return;

      const wb = XLSX.utils.book_new();
      const startDate = new Date(workingTimes.value[0].start);
      const endDate = new Date(
        workingTimes.value[workingTimes.value.length - 1].end
      );
      const periodStart = startDate.toLocaleDateString("fr-FR", {
        day: "2-digit",
        month: "2-digit",
        year: "numeric",
      });
      const periodEnd = endDate.toLocaleDateString("fr-FR", {
        day: "2-digit",
        month: "2-digit",
        year: "numeric",
      });

      const headerRows = [
        [`Feuille de temps - ${selectedUser.username}`],
        [`Email: ${selectedUser.email}`],
        [`Période: ${periodStart} au ${periodEnd}`],
        [],
      ];

      const columnHeaders = [
        "Date",
        "Début",
        "Fin",
        "Heures de nuit",
        "Heures supp.",
        "Total",
      ];

      const data = workingTimes.value.map((time) => {
        const start = new Date(time.start);
        const end = new Date(time.end);
        const totalHours = time.day_hours + time.night_hours;

        return [
          start.toLocaleDateString("fr-FR"),
          start.toLocaleTimeString("fr-FR", {
            hour: "2-digit",
            minute: "2-digit",
          }),
          end.toLocaleTimeString("fr-FR", {
            hour: "2-digit",
            minute: "2-digit",
          }),
          Number(time.day_hours.toFixed(2)),
          Number(time.night_hours.toFixed(2)),
          Number(time.overtime_hours.toFixed(2)),
          Number(totalHours.toFixed(2)),
        ];
      });

      const totals = data.reduce(
        (acc, row) => ({
          dayHours: acc.dayHours + row[3],
          nightHours: acc.nightHours + row[4],
          overtimeHours: acc.overtimeHours + row[5],
          totalHours: acc.totalHours + row[6],
        }),
        { dayHours: 0, nightHours: 0, overtimeHours: 0, totalHours: 0 }
      );

      const totalsRow = [
        "TOTAL",
        "",
        "",
        Number(totals.dayHours.toFixed(2)),
        Number(totals.nightHours.toFixed(2)),
        Number(totals.overtimeHours.toFixed(2)),
        Number(totals.totalHours.toFixed(2)),
      ];

      const wsData = [...headerRows, columnHeaders, ...data, [], totalsRow];

      const ws = XLSX.utils.aoa_to_sheet(wsData);

      XLSX.utils.book_append_sheet(wb, ws, "Timesheet");
      const filename = `timesheet_${selectedUser.username}_${
        new Date().toISOString().split("T")[0]
      }.xlsx`;
      XLSX.writeFile(wb, filename);
    }

    return {
      workingTimes,
      currentWorkingTime,
      isEditing,
      users,
      selectedUserId,
      currentPage,
      pageSize,
      totalPages,
      paginatedWorkingTimes,
      prevPage,
      nextPage,
      setPage,
      getUsers,
      getWorkingTimes,
      createWorkingTime,
      updateWorkingTime,
      deleteWorkingTime,
      submitWorkingTime,
      formatDate,
      downloadTimesheet,
      nightShiftAlert,
      editWorkingTime,
      authStore,
      role
    };
  },
};
</script>
