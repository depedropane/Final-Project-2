<template>
  <LayoutWrapper>
    <div class="p-8">
      <h2 class="text-3xl font-bold text-gray-800 mb-8">Dashboard</h2>
    
    <div v-if="loading" class="text-center py-12">
      <p class="text-gray-600">Loading...</p>
    </div>

    <div v-else-if="error" class="mb-4 p-4 bg-red-100 border border-red-400 text-red-700 rounded-lg">
      {{ error }}
    </div>

    <div v-else class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
      <!-- Total Pasien Card -->
      <div class="bg-gradient-to-br from-blue-500 to-blue-600 rounded-lg shadow-lg p-6 text-white">
        <div class="flex items-center justify-between">
          <div>
            <p class="text-blue-100 text-sm font-semibold">Total Pasien</p>
            <p class="text-4xl font-bold mt-2">{{ dashboard.total_pasien }}</p>
          </div>
          <div class="text-5xl">👥</div>
        </div>
      </div>

      <!-- Total Jadwal Card -->
      <div class="bg-gradient-to-br from-green-500 to-green-600 rounded-lg shadow-lg p-6 text-white">
        <div class="flex items-center justify-between">
          <div>
            <p class="text-green-100 text-sm font-semibold">Total Jadwal</p>
            <p class="text-4xl font-bold mt-2">{{ dashboard.total_jadwal }}</p>
          </div>
          <div class="text-5xl">📅</div>
        </div>
      </div>
    </div>

    <!-- Quick Actions -->
    <div class="bg-white rounded-lg shadow-lg p-6">
      <h3 class="text-xl font-semibold text-gray-800 mb-4">Aksi Cepat</h3>
      <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
        <router-link 
          to="/pasien"
          class="p-4 border border-gray-200 rounded-lg hover:bg-gray-50 transition text-center"
        >
          <p class="text-2xl mb-2">👥</p>
          <p class="text-gray-800 font-semibold">Kelola Pasien</p>
        </router-link>
        <router-link 
          to="/jadwal"
          class="p-4 border border-gray-200 rounded-lg hover:bg-gray-50 transition text-center"
        >
          <p class="text-2xl mb-2">📅</p>
          <p class="text-gray-800 font-semibold">Kelola Jadwal</p>
        </router-link>
        <router-link 
          to="/obat"
          class="p-4 border border-gray-200 rounded-lg hover:bg-gray-50 transition text-center"
        >
          <p class="text-2xl mb-2">💊</p>
          <p class="text-gray-800 font-semibold">Info Obat</p>
        </router-link>
      </div>
    </div>
    </div>
  </LayoutWrapper>
</template>

<script>
import { ref, onMounted } from 'vue'
import LayoutWrapper from '../components/LayoutWrapper.vue'
import { dashboardService } from '../services'

export default {
  components: {
    LayoutWrapper
  },
  name: 'DashboardView',
  setup() {
    const dashboard = ref({
      total_pasien: 0,
      total_jadwal: 0
    })
    const loading = ref(false)
    const error = ref(null)

    const fetchDashboard = async () => {
      loading.value = true
      try {
        const response = await dashboardService.getDashboard()
        dashboard.value = response.data.data
        error.value = null
      } catch (err) {
        error.value = 'Gagal memuat dashboard'
        console.error(err)
      } finally {
        loading.value = false
      }
    }

    onMounted(fetchDashboard)

    return {
      dashboard,
      loading,
      error
    }
  }
}
</script>
