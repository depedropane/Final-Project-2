<template>
  <LayoutWrapper>
    <div class="p-8">
      <h2 class="text-3xl font-bold text-gray-800 mb-8">Kelola Pasien</h2>
    
    <div v-if="loading" class="text-center py-12">
      <p class="text-gray-600">Loading...</p>
    </div>

    <div v-else-if="error" class="mb-4 p-4 bg-red-100 border border-red-400 text-red-700 rounded-lg">
      {{ error }}
    </div>

    <div v-else class="bg-white rounded-lg shadow-lg overflow-hidden">
      <div class="overflow-x-auto">
        <table class="w-full">
          <thead class="bg-gray-100 border-b border-gray-200">
            <tr>
              <th class="px-6 py-3 text-left text-sm font-semibold text-gray-700">ID</th>
              <th class="px-6 py-3 text-left text-sm font-semibold text-gray-700">Nama</th>
              <th class="px-6 py-3 text-left text-sm font-semibold text-gray-700">Email</th>
              <th class="px-6 py-3 text-left text-sm font-semibold text-gray-700">No. HP</th>
              <th class="px-6 py-3 text-left text-sm font-semibold text-gray-700">Aksi</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="pasien in pasienList" :key="pasien.id" class="border-b hover:bg-gray-50">
              <td class="px-6 py-4 text-sm text-gray-700">{{ pasien.id }}</td>
              <td class="px-6 py-4 text-sm text-gray-700">{{ pasien.nama_pasien }}</td>
              <td class="px-6 py-4 text-sm text-gray-700">{{ pasien.email }}</td>
              <td class="px-6 py-4 text-sm text-gray-700">{{ pasien.nomor_hp }}</td>
              <td class="px-6 py-4 text-sm">
                <button 
                  @click="confirmDelete(pasien.id)"
                  class="px-3 py-1 bg-red-600 text-white rounded hover:bg-red-700 transition"
                >
                  Hapus
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <div v-if="pasienList.length === 0" class="text-center py-8 text-gray-500">
        Tidak ada data pasien
      </div>
    </div>
    </div>
  </LayoutWrapper>
</template>

<script>
import { onMounted, computed } from 'vue'
import LayoutWrapper from '../components/LayoutWrapper.vue'
import { usePasienStore } from '../stores/pasien'

export default {
  components: {
    LayoutWrapper
  },
  name: 'PasienView',
  setup() {
    const pasienStore = usePasienStore()

    const pasienList = computed(() => pasienStore.pasienList)
    const loading = computed(() => pasienStore.loading)
    const error = computed(() => pasienStore.error)

    const fetchPasiens = async () => {
      await pasienStore.fetchPasiens()
    }

    const confirmDelete = async (id) => {
      if (confirm('Apakah Anda yakin ingin menghapus pasien ini?')) {
        try {
          await pasienStore.deletePasien(id)
          alert('Pasien berhasil dihapus')
        } catch (err) {
          alert('Gagal menghapus pasien: ' + err.message)
        }
      }
    }

    onMounted(fetchPasiens)

    return {
      pasienList,
      loading,
      error,
      confirmDelete
    }
  }
}
</script>
