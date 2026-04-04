import { ref, onMounted } from 'vue'
import { dashboardService } from '../services'

export function useDashboard() {
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
    error,
    fetchDashboard
  }
}
