<template>
  <div class="min-h-screen bg-gray-50 flex">
    <!-- Left Side - Dark Sidebar -->
    <div class="hidden lg:flex lg:w-2/5 bg-gradient-to-b from-slate-900 via-slate-800 to-slate-900 flex-col items-center justify-center px-12">
      <div class="text-center">
        <div class="w-16 h-16 bg-gradient-to-br from-teal-400 to-cyan-500 rounded-full flex items-center justify-center mx-auto mb-6">
          <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4"></path>
          </svg>
        </div>
        <h1 class="text-3xl font-bold text-white mb-2">SahabatSehat</h1>
        <p class="text-cyan-400 text-sm mb-8">Healthcare Management System</p>
        <p class="text-slate-400 text-sm">Sistem Manajemen Kesehatan Terintegrasi</p>
      </div>
    </div>

    <!-- Right Side - Form -->
    <div class="w-full lg:w-3/5 flex flex-col items-center justify-center px-6 py-12 sm:px-12">
      <div class="w-full max-w-md">
        <!-- Header -->
        <div class="text-center mb-8">
          <h2 class="text-3xl font-bold text-slate-900 mb-2">Selamat Datang</h2>
          <p class="text-gray-600">Admin Portal SahabatSehat</p>
        </div>

        <!-- Error Message -->
        <div v-if="errorMessage" class="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg flex items-start space-x-3">
          <svg class="w-5 h-5 text-red-500 flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"></path>
          </svg>
          <span class="text-sm text-red-700">{{ errorMessage }}</span>
        </div>

        <!-- Form -->
        <form @submit.prevent="handleLogin" class="space-y-5">
          <!-- Email -->
          <div>
            <label for="email" class="block text-sm font-medium text-slate-700 mb-2">Email</label>
            <input
              id="email"
              v-model="form.email"
              type="email"
              required
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-teal-500 focus:border-transparent outline-none transition"
              placeholder="admin@sahabatsehat.com"
            />
          </div>

          <!-- Password -->
          <div>
            <label for="password" class="block text-sm font-medium text-slate-700 mb-2">Password</label>
            <div class="relative">
              <input
                id="password"
                v-model="form.password"
                :type="showPassword ? 'text' : 'password'"
                required
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-teal-500 focus:border-transparent outline-none transition pr-10"
                placeholder="••••••••"
              />
              <button
                type="button"
                @click="showPassword = !showPassword"
                class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-500 hover:text-gray-700"
              >
                <svg v-if="showPassword" class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                  <path d="M10 12a2 2 0 100-4 2 2 0 000 4z"></path>
                  <path fill-rule="evenodd" d="M.458 10C1.732 5.943 5.522 3 10 3s8.268 2.943 9.542 7c-1.274 4.057-5.064 7-9.542 7S1.732 14.057.458 10zM14 10a4 4 0 11-8 0 4 4 0 018 0z" clip-rule="evenodd"></path>
                </svg>
                <svg v-else class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M3.707 2.293a1 1 0 00-1.414 1.414l14 14a1 1 0 001.414-1.414l-1.473-1.473A10.014 10.014 0 0019.542 10C18.268 5.943 14.478 3 10 3a9.958 9.958 0 00-4.512 1.074l-1.78-1.781zm4.261 4.26l1.514 1.515a2.003 2.003 0 012.45 2.45l1.514 1.514a4 4 0 00-5.478-5.478z" clip-rule="evenodd"></path>
                  <path d="M15.171 13.576l1.473 1.473A10.014 10.014 0 0019.542 10c-1.274-4.057-5.064-7-9.542-7a9.958 9.958 0 00-2.037.242l1.22 1.22a8 8 0 1010.758 0z"></path>
                </svg>
              </button>
            </div>
          </div>

          <!-- Login Button -->
          <button
            type="submit"
            :disabled="loading"
            class="w-full px-4 py-2 mt-6 font-medium text-white bg-gradient-to-r from-teal-500 to-cyan-500 rounded-lg hover:from-teal-600 hover:to-cyan-600 disabled:opacity-50 disabled:cursor-not-allowed transition"
          >
            {{ loading ? 'Signing in...' : 'Login' }}
          </button>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { authService } from '../services'

export default {
  name: 'LoginView',
  setup() {
    const router = useRouter()
    const authStore = useAuthStore()
    const loading = ref(false)
    const errorMessage = ref('')
    const showPassword = ref(false)
    const form = ref({
      email: '',
      password: ''
    })

    const handleLogin = async () => {
      if (!form.value.email || !form.value.password) {
        errorMessage.value = 'Email dan password harus diisi'
        return
      }

      loading.value = true
      errorMessage.value = ''

      try {
        const axiosResponse = await authService.loginAdmin(form.value.email, form.value.password)
        const response = axiosResponse.data
        
        if (response.success) {
          const { token, data } = response
          const user = {
            id: data.id,
            nama_nakes: data.nama,
            email: data.email,
            role: data.role
          }
          
          authStore.setAuth(token, user)
          router.push('/dashboard')
        } else {
          errorMessage.value = response.message || 'Login gagal'
        }
      } catch (error) {
        errorMessage.value = error.response?.data?.message || 'Terjadi kesalahan saat login'
      } finally {
        loading.value = false
      }
    }

    return {
      form,
      loading,
      errorMessage,
      showPassword,
      handleLogin
    }
  }
}
</script>
