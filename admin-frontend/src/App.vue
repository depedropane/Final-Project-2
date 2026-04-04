<template>
  <div id="app">
    <router-view />
  </div>
</template>

<script>
import { useAuthStore } from './stores/auth'
import { onMounted } from 'vue'
import { useRouter } from 'vue-router'

export default {
  name: 'App',
  setup() {
    const authStore = useAuthStore()
    const router = useRouter()

    const logout = () => {
      authStore.logout()
      router.push('/login')
    }

    onMounted(() => {
      // Check if user is logged in, if not redirect to login
      if (!authStore.token) {
        router.push('/login')
      }
    })

    return {
      authStore,
      logout
    }
  }
}
</script>

<style scoped>
</style>
