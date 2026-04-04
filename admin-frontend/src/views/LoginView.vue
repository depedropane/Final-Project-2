<template>
  <div class="min-h-screen flex bg-white">
    <!-- Left Sidebar - Branding -->
    <div class="hidden lg:flex lg:w-2/5 bg-gradient-to-br from-slate-900 via-slate-800 to-slate-900 flex-col justify-between p-12">
      <!-- Top Section -->
      <div>
        <!-- Logo -->
        <div class="flex items-center space-x-3 mb-12">
          <div class="w-16 h-16 bg-gradient-to-br from-teal-400 to-cyan-500 rounded-full flex items-center justify-center">
            <svg class="w-10 h-10 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4"></path>
            </svg>
          </div>
          <div>
            <h2 class="text-white text-xl font-bold">SahabatSehat</h2>
            <p class="text-teal-300 text-xs">Portal Tenaga Kesehatan</p>
          </div>
        </div>

        <!-- Main Heading -->
        <h1 class="text-white text-5xl font-bold leading-tight mb-2">
          Kelola Pasien dengan
          <span class="text-teal-400">Lebih Mudah</span>
        </h1>

        <p class="text-slate-400 text-lg leading-relaxed mb-12">
          Platform terintegrasi untuk monitoring kepatuhan minum obat pasien Desa Nauli secara real-time.
        </p>
      </div>

      <!-- Features Section -->
      <div class="space-y-6">
        <!-- Feature 1 -->
        <div class="flex items-start space-x-4">
          <div class="flex-shrink-0">
            <div class="flex items-center justify-center h-12 w-12 rounded-lg bg-teal-500/20 text-teal-400">
              <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"></path>
              </svg>
            </div>
          </div>
          <div>
            <h3 class="text-white font-semibold text-lg">Input Jadwal Obat</h3>
            <p class="text-slate-400 text-sm mt-1">Atur jadwal dan dosis obat pasien langsung dari sistem</p>
          </div>
        </div>

        <!-- Feature 2 -->
        <div class="flex items-start space-x-4">
          <div class="flex-shrink-0">
            <div class="flex items-center justify-center h-12 w-12 rounded-lg bg-teal-500/20 text-teal-400">
              <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"></path>
              </svg>
            </div>
          </div>
          <div>
            <h3 class="text-white font-semibold text-lg">Monitoring Kepatuhan</h3>
            <p class="text-slate-400 text-sm mt-1">Pantau riwayat konsumsi obat seluruh pasien secara akurat</p>
          </div>
        </div>

        <!-- Feature 3 -->
        <div class="flex items-start space-x-4">
          <div class="flex-shrink-0">
            <div class="flex items-center justify-center h-12 w-12 rounded-lg bg-teal-500/20 text-teal-400">
              <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"></path>
              </svg>
            </div>
          </div>
          <div>
            <h3 class="text-white font-semibold text-lg">Notifikasi Otomatis</h3>
            <p class="text-slate-400 text-sm mt-1">Pasien mendapat pengingat tepat waktu sesuai jadwal</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Right Side - Login Form -->
    <div class="w-full lg:w-3/5 flex flex-col justify-center items-center px-6 sm:px-12 lg:px-16 bg-gray-50">
      <div class="max-w-md w-full text-center">
        <!-- Logo for mobile -->
        <div class="lg:hidden mb-8 flex justify-center">
          <div class="flex items-center space-x-3">
            <div class="w-12 h-12 bg-gradient-to-br from-teal-400 to-cyan-500 rounded-full flex items-center justify-center">
              <svg class="w-7 h-7 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4"></path>
              </svg>
            </div>
            <div>
              <h2 class="text-slate-900 text-lg font-bold text-center">SahabatSehat</h2>
              <p class="text-teal-600 text-xs text-center">Portal Tenaga Kesehatan</p>
            </div>
          </div>
        </div>

        <!-- Heading -->
        <div class="mb-8">
          <h1 class="text-4xl font-bold text-slate-900 mb-2">Selamat Datang</h1>
          <p class="text-slate-600 text-lg">Masuk ke portal tenaga kesehatan SahabatSehat</p>
        </div>

        <!-- Form -->
        <form @submit.prevent="handleLogin" class="space-y-5">
          <!-- Email -->
          <div>
            <label class="block text-left text-sm font-medium text-slate-700 mb-2">Email</label>
            <input 
              v-model="form.email"
              type="email"
              class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-teal-500 focus:border-transparent placeholder-slate-400 bg-white"
              placeholder="Enter your email"
              required
            />
          </div>

          <!-- Password -->
          <div>
            <label class="block text-left text-sm font-medium text-slate-700 mb-2">Password</label>
            <div class="relative">
              <input 
                v-model="form.password"
                :type="showPassword ? 'text' : 'password'"
                class="w-full px-4 py-3 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-teal-500 focus:border-transparent placeholder-slate-400 bg-white pr-12"
                placeholder="Enter your password"
                required
              />
              <button
                type="button"
                @click="showPassword = !showPassword"
                class="absolute right-3 top-1/2 -translate-y-1/2 text-slate-500 hover:text-slate-700 transition focus:outline-none"
              >
                <svg v-if="!showPassword" class="w-5 h-5" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M12 7c2.76 0 5 2.24 5 5s-2.24 5-5 5-5-2.24-5-5 2.24-5 5-5zm0-2C6.48 5 2 8.46 2 12s4.48 7 10 7 10-3.46 10-7-4.48-7-10-7zm0 12c-2.21 0-4-1.79-4-4s1.79-4 4-4 4 1.79 4 4-1.79 4-4 4z"/>
                </svg>
                <svg v-else class="w-5 h-5" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm3.6-9c.33-1.36 1.04-2.63 2.05-3.65C15.25 2.82 13.76 2 12 2c-5.52 0-10 4.48-10 10s4.48 10 10 10 10-4.48 10-10c0-1.71-.43-3.33-1.2-4.75-1.02 1.02-1.72 2.29-2.05 3.65H15.6z"/>
                </svg>
              </button>
            </div>
          </div>

          <!-- Error Message -->
          <div v-if="error" class="p-4 bg-red-50 border border-red-200 text-red-700 rounded-lg text-sm">
            {{ error }}
          </div>

          <!-- Login Button -->
          <button 
            type="submit"
            :disabled="loading"
            class="w-full bg-gradient-to-r from-teal-500 to-cyan-500 text-white font-semibold py-3 rounded-lg hover:from-teal-600 hover:to-cyan-600 transition duration-200 disabled:opacity-50 disabled:cursor-not-allowed mt-8"
          >
            {{ loading ? 'Memproses...' : 'Masuk' }}
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

        authStore.setAuth(token, user)
        router.push('/dashboard')
      } catch (err) {
        error.value = 'Email atau password salah'
        console.error('Login error:', err)
      } finally {
        loading.value = false
      }
    }

    return {
      form,
      loading,
      error,
      showPassword,
      handleLogin
    }
  }
}
</script>
