import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { authService } from '../services'

export function useLogin() {
  const router = useRouter()
  const authStore = useAuthStore()
  
  const showPassword = ref(false)
  const form = ref({
    email: '',
    password: ''
  })
  
  const loading = ref(false)
  const error = ref(null)

  const handleLogin = async () => {
    loading.value = true
    error.value = null

    try {
      // Try admin login first
      const response = await authService.loginAdmin(form.value.email, form.value.password)
      
      const { token, data } = response.data

      // Prepare user data
      const user = {
        id: data.id,
        nama_nakes: data.nama,
        email: data.email,
        role: data.role
      }

      // Store in Pinia
      authStore.setUser(user)
      authStore.setToken(token)

      // Redirect to dashboard
      router.push('/dashboard')
    } catch (err) {
      error.value = err.response?.data?.message || 'Email atau password salah'
      console.error(err)
    } finally {
      loading.value = false
    }
  }

  return {
    showPassword,
    form,
    loading,
    error,
    handleLogin
  }
}
