<template>
  <LayoutWrapper>
    <div class="p-8">
      <div class="flex justify-between items-center mb-8">
        <h2 class="text-3xl font-bold text-gray-800">Kelola Jadwal</h2>
        <button 
          @click="showFormCreate = true"
          class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition"
        >
          + Tambah Jadwal
        </button>
      </div>
    
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
              <th class="px-6 py-3 text-left text-sm font-semibold text-gray-700">Hari</th>
              <th class="px-6 py-3 text-left text-sm font-semibold text-gray-700">Jam Mulai</th>
              <th class="px-6 py-3 text-left text-sm font-semibold text-gray-700">Jam Selesai</th>
              <th class="px-6 py-3 text-left text-sm font-semibold text-gray-700">Nakes ID</th>
              <th class="px-6 py-3 text-left text-sm font-semibold text-gray-700">Aksi</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="jadwal in jadwalList" :key="jadwal.id" class="border-b hover:bg-gray-50">
              <td class="px-6 py-4 text-sm text-gray-700">{{ jadwal.id }}</td>
              <td class="px-6 py-4 text-sm text-gray-700">{{ jadwal.hari }}</td>
              <td class="px-6 py-4 text-sm text-gray-700">{{ jadwal.jam_mulai }}</td>
              <td class="px-6 py-4 text-sm text-gray-700">{{ jadwal.jam_selesai }}</td>
              <td class="px-6 py-4 text-sm text-gray-700">{{ jadwal.nakes_id }}</td>
              <td class="px-6 py-4 text-sm space-x-2">
                <button 
                  @click="editJadwal(jadwal)"
                  class="px-3 py-1 bg-yellow-600 text-white rounded hover:bg-yellow-700 transition"
                >
                  Edit
                </button>
                <button 
                  @click="confirmDelete(jadwal.id)"
                  class="px-3 py-1 bg-red-600 text-white rounded hover:bg-red-700 transition"
                >
                  Hapus
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <div v-if="jadwalList.length === 0" class="text-center py-8 text-gray-500">
        Tidak ada data jadwal
      </div>
    </div>

    <!-- Modal Form -->
    <div v-if="showFormCreate" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
      <div class="bg-white rounded-lg shadow-lg p-6 w-full max-w-md">
        <h3 class="text-xl font-bold text-gray-800 mb-4">{{ editingId ? 'Edit Jadwal' : 'Tambah Jadwal' }}</h3>
        
        <form @submit.prevent="submitForm">
          <div class="mb-4">
            <label class="block text-gray-700 font-semibold mb-2">Hari</label>
            <input 
              v-model="form.hari"
              type="text"
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-600"
              required
            />
          </div>

          <div class="mb-4">
            <label class="block text-gray-700 font-semibold mb-2">Jam Mulai</label>
            <input 
              v-model="form.jam_mulai"
              type="time"
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-600"
              required
            />
          </div>

          <div class="mb-4">
            <label class="block text-gray-700 font-semibold mb-2">Jam Selesai</label>
            <input 
              v-model="form.jam_selesai"
              type="time"
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-600"
              required
            />
          </div>

          <div class="mb-4">
            <label class="block text-gray-700 font-semibold mb-2">Nakes ID</label>
            <input 
              v-model.number="form.nakes_id"
              type="number"
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-600"
              required
            />
          </div>

          <div class="flex gap-4">
            <button 
              type="submit"
              class="flex-1 bg-blue-600 text-white font-semibold py-2 rounded-lg hover:bg-blue-700 transition"
            >
              {{ editingId ? 'Update' : 'Simpan' }}
            </button>
            <button 
              type="button"
              @click="closeForm"
              class="flex-1 bg-gray-300 text-gray-800 font-semibold py-2 rounded-lg hover:bg-gray-400 transition"
            >
              Batal
            </button>
          </div>
        </form>
      </div>
    </div>
    </div>
  </LayoutWrapper>
</template>

<script>
import { ref, onMounted, computed } from 'vue'
import LayoutWrapper from '../components/LayoutWrapper.vue'
import { useJadwalStore } from '../stores/jadwal'

export default {
  components: {
    LayoutWrapper
  },
  name: 'JadwalView',
  setup() {
    const jadwalStore = useJadwalStore()

    const jadwalList = computed(() => jadwalStore.jadwalList)
    const loading = computed(() => jadwalStore.loading)
    const error = computed(() => jadwalStore.error)

    const showFormCreate = ref(false)
    const editingId = ref(null)
    const form = ref({
      hari: '',
      jam_mulai: '',
      jam_selesai: '',
      nakes_id: null
    })

    const fetchJadwals = async () => {
      await jadwalStore.fetchJadwals()
    }

    const submitForm = async () => {
      try {
        if (editingId.value) {
          await jadwalStore.updateJadwal(editingId.value, form.value)
          alert('Jadwal berhasil diupdate')
        } else {
          await jadwalStore.createJadwal(form.value)
          alert('Jadwal berhasil ditambahkan')
        }
        closeForm()
      } catch (err) {
        alert('Gagal menyimpan jadwal: ' + err.message)
      }
    }

    const editJadwal = (jadwal) => {
      editingId.value = jadwal.id
      form.value = { ...jadwal }
      showFormCreate.value = true
    }

    const confirmDelete = async (id) => {
      if (confirm('Apakah Anda yakin ingin menghapus jadwal ini?')) {
        try {
          await jadwalStore.deleteJadwal(id)
          alert('Jadwal berhasil dihapus')
        } catch (err) {
          alert('Gagal menghapus jadwal: ' + err.message)
        }
      }
    }

    const closeForm = () => {
      showFormCreate.value = false
      editingId.value = null
      form.value = {
        hari: '',
        jam_mulai: '',
        jam_selesai: '',
        nakes_id: null
      }
    }

    onMounted(fetchJadwals)

    return {
      jadwalList,
      loading,
      error,
      showFormCreate,
      editingId,
      form,
      submitForm,
      editJadwal,
      confirmDelete,
      closeForm
    }
  }
}
</script>
