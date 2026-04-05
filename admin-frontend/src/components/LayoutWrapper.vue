<template>
  <div class="min-h-screen bg-gray-50 flex flex-col">
    <!-- Navbar -->
    <nav class="sticky top-0 z-40 bg-white border-b border-gray-200 shadow-sm">
      <div class="max-w-full px-6 sm:px-8 lg:px-12">
        <div class="flex justify-between h-16 items-center">
          <div class="flex items-center space-x-3">
            <div class="w-10 h-10 bg-gradient-to-br from-teal-400 to-cyan-500 rounded-full flex items-center justify-center">
              <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4"></path>
              </svg>
            </div>
            <div>
              <h1 class="text-lg font-bold text-slate-900">SahabatSehat</h1>
              <p class="text-xs text-teal-600">Admin Portal</p>
            </div>
          </div>
          <div class="flex items-center space-x-4">
            <span class="text-sm text-gray-600">{{ authStore.user?.nama_nakes || 'Admin' }}</span>
            <button 
              @click="logout"
              class="px-4 py-2 text-sm font-medium text-white bg-red-600 rounded-lg hover:bg-red-700 transition"
            >
              Logout
            </button>
          </div>
        </div>
      </div>
    </nav>

    <!-- Sidebar + Main Content -->
    <div class="flex flex-1 overflow-hidden">
      <!-- Sidebar -->
      <aside class="w-64 bg-white border-r border-gray-200 overflow-y-auto">
        <nav class="mt-6 px-4 space-y-2">
          <router-link 
            to="/dashboard"
            class="block px-4 py-3 rounded-lg font-medium transition"
            :class="$route.path === '/dashboard' ? 'bg-teal-100 text-teal-700' : 'text-gray-700 hover:bg-gray-100'"
          >
            📊 Dashboard
          </router-link>
          <router-link 
            to="/pasien"
            class="block px-4 py-3 rounded-lg font-medium transition"
            :class="$route.path === '/pasien' ? 'bg-teal-100 text-teal-700' : 'text-gray-700 hover:bg-gray-100'"
          >
            👥 Kelola Pasien
          </router-link>
          <router-link 
            to="/jadwal"
            class="block px-4 py-3 rounded-lg font-medium transition"
            :class="$route.path === '/jadwal' ? 'bg-teal-100 text-teal-700' : 'text-gray-700 hover:bg-gray-100'"
          >
            📅 Kelola Jadwal
          </router-link>
          <router-link 
            to="/obat"
            class="block px-4 py-3 rounded-lg font-medium transition"
            :class="$route.path === '/obat' ? 'bg-teal-100 text-teal-700' : 'text-gray-700 hover:bg-gray-100'"
          >
            💊 Info Obat
          </router-link>
        </nav>
      </aside>

      <!-- Main Content -->
      <main class="flex-1 overflow-auto">
        <slot />
      </main>
    </div>
  </div>
</template>

<script>
import { useAuthStore } from '../stores/auth'
import { useRouter } from 'vue-router'

export default {
  name: 'LayoutWrapper',
  setup() {
    const authStore = useAuthStore()
    const router = useRouter()

    const logout = () => {
      authStore.logout()
      router.push('/login')
    }

    return {
      authStore,
      logout
    }
  }
}
</script>
