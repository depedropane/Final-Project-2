<template>
  <LayoutWrapper>
    <div class="p-8">
      <div class="flex justify-between items-center mb-8">
        <h1 class="text-3xl font-bold text-slate-900">Kelola Jadwal</h1>
        <button 
          @click="openModal()"
          class="px-4 py-2 bg-teal-600 text-white rounded-lg hover:bg-teal-700 transition font-medium"
        >
          + Tambah Jadwal
        </button>
      </div>

      <!-- Table -->
      <div class="bg-white rounded-lg shadow overflow-hidden">
        <table class="w-full">
          <thead class="bg-gray-50 border-b border-gray-200">
            <tr>
              <th class="px-6 py-3 text-left text-sm font-semibold text-gray-900">ID</th>
              <th class="px-6 py-3 text-left text-sm font-semibold text-gray-900">Hari</th>
              <th class="px-6 py-3 text-left text-sm font-semibold text-gray-900">Jam Mulai</th>
              <th class="px-6 py-3 text-left text-sm font-semibold text-gray-900">Jam Selesai</th>
              <th class="px-6 py-3 text-left text-sm font-semibold text-gray-900">Nakes ID</th>
              <th class="px-6 py-3 text-left text-sm font-semibold text-gray-900">Aksi</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-200">
            <tr v-for="jadwal in jadwalStore.jadwalList" :key="jadwal.id" class="hover:bg-gray-50">
              <td class="px-6 py-4 text-sm text-gray-600">{{ jadwal.id }}</td>
              <td class="px-6 py-4 text-sm font-medium text-slate-900">{{ jadwal.hari }}</td>
              <td class="px-6 py-4 text-sm text-gray-600">{{ jadwal.jam_mulai }}</td>
              <td class="px-6 py-4 text-sm text-gray-600">{{ jadwal.jam_selesai }}</td>
              <td class="px-6 py-4 text-sm text-gray-600">{{ jadwal.nakes_id }}</td>
              <td class="px-6 py-4 text-sm space-x-2 flex">
                <button 
                  @click="openModal(jadwal)"
                  class="px-3 py-1 text-blue-600 bg-blue-50 rounded hover:bg-blue-100 transition"
                >
                  Edit
                </button>
                <button 
                  @click="deleteJadwal(jadwal.id)"
                  class="px-3 py-1 text-red-600 bg-red-50 rounded hover:bg-red-100 transition"
                >
                  Hapus
                </button>
              </td>
            </tr>
          </tbody>
        </table>

        <!-- Empty State -->
        <div v-if="jadwalStore.jadwalList.length === 0" class="px-6 py-12 text-center">
          <p class="text-gray-500">Belum ada data jadwal</p>
        </div>
      </div>

      <!-- Modal -->
      <div v-if="showModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50">
        <div class="bg-white rounded-lg shadow-xl p-8 w-full max-w-md">
          <h2 class="text-2xl font-bold text-slate-900 mb-6">
            {{ editingId ? 'Edit Jadwal' : 'Tambah Jadwal Baru' }}
          </h2>

          <form @submit.prevent="handleSubmit" class="space-y-4">
            <!-- Hari -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Hari</label>
              <input
                v-model="form.hari"
                type="text"
                required
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-teal-500 focus:border-transparent outline-none"
                placeholder="Contoh: Senin"
              />
            </div>

            <!-- Jam Mulai -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Jam Mulai</label>
              <input
                v-model="form.jam_mulai"
                type="time"
                required
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-teal-500 focus:border-transparent outline-none"
              />
            </div>

            <!-- Jam Selesai -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Jam Selesai</label>
              <input
                v-model="form.jam_selesai"
                type="time"
                required
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-teal-500 focus:border-transparent outline-none"
              />
            </div>

            <!-- Nakes ID -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Nakes ID</label>
              <input
                v-model.number="form.nakes_id"
                type="number"
                required
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-teal-500 focus:border-transparent outline-none"
              />
            </div>

            <!-- Buttons -->
            <div class="flex gap-3 pt-4">
              <button
                type="button"
                @click="showModal = false"
                class="flex-1 px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 transition font-medium"
              >
                Batal
              </button>
              <button
                type="submit"
                class="flex-1 px-4 py-2 bg-teal-600 text-white rounded-lg hover:bg-teal-700 transition font-medium"
              >
                {{ editingId ? 'Update' : 'Simpan' }}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </LayoutWrapper>
</template>

<script>
import { ref, onMounted } from 'vue'
import LayoutWrapper from '../components/LayoutWrapper.vue'
import { useJadwalStore } from '../stores/jadwal'

export default {
  name: 'JadwalView',
  components: {
    LayoutWrapper
  },
  setup() {
    const jadwalStore = useJadwalStore()
    const showModal = ref(false)
    const editingId = ref(null)
    const form = ref({
      hari: '',
      jam_mulai: '',
      jam_selesai: '',
      nakes_id: null
    })

    const openModal = (jadwal = null) => {
      if (jadwal) {
        editingId.value = jadwal.id
        form.value = {
          hari: jadwal.hari,
          jam_mulai: jadwal.jam_mulai,
          jam_selesai: jadwal.jam_selesai,
          nakes_id: jadwal.nakes_id
        }
      } else {
        editingId.value = null
        form.value = {
          hari: '',
          jam_mulai: '',
          jam_selesai: '',
          nakes_id: null
        }
      }
      showModal.value = true
    }

    const handleSubmit = async () => {
      try {
        if (editingId.value) {
          await jadwalStore.updateJadwal(editingId.value, form.value)
        } else {
          await jadwalStore.createJadwal(form.value)
        }
        showModal.value = false
      } catch (error) {
        alert('Error: ' + error.message)
      }
    }

    const deleteJadwal = async (id) => {
      if (confirm('Yakin ingin menghapus jadwal ini?')) {
        try {
          await jadwalStore.deleteJadwal(id)
        } catch (error) {
          alert('Gagal menghapus jadwal: ' + error.message)
        }
      }
    }

    onMounted(() => {
      jadwalStore.fetchJadwals()
    })

    return {
      jadwalStore,
      showModal,
      editingId,
      form,
      openModal,
      handleSubmit,
      deleteJadwal
    }
  }
}
</script>
