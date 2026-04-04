<template>
  <LayoutWrapper>
    <div class="p-8">
      <div class="flex justify-between items-center mb-8">
        <h2 class="text-3xl font-bold text-gray-800">Info Obat</h2>
        <button 
          @click="showFormCreate = true"
          class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition"
        >
          + Tambah Obat
        </button>
      </div>
    
    <div v-if="loading" class="text-center py-12">
      <p class="text-gray-600">Loading...</p>
    </div>

    <div v-else-if="error" class="mb-4 p-4 bg-red-100 border border-red-400 text-red-700 rounded-lg">
      {{ error }}
    </div>

    <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <div v-for="obat in obatList" :key="obat.id" class="bg-white rounded-lg shadow-lg p-6">
        <h3 class="text-lg font-bold text-gray-800">{{ obat.nama_obat }}</h3>
        <p class="text-sm text-gray-600 mt-2"><strong>Dosis:</strong> {{ obat.dosis }}</p>
        <p class="text-sm text-gray-600"><strong>Tipe:</strong> {{ obat.tipe }}</p>
        <p class="text-sm text-gray-600"><strong>Deskripsi:</strong> {{ obat.deskripsi }}</p>
        
        <div class="mt-4 flex gap-2">
          <button 
            @click="editObat(obat)"
            class="flex-1 px-3 py-1 bg-yellow-600 text-white rounded hover:bg-yellow-700 transition text-sm"
          >
            Edit
          </button>
          <button 
            @click="confirmDelete(obat.id)"
            class="flex-1 px-3 py-1 bg-red-600 text-white rounded hover:bg-red-700 transition text-sm"
          >
            Hapus
          </button>
        </div>
      </div>
    </div>

    <div v-if="obatList.length === 0" class="text-center py-8 text-gray-500">
      Tidak ada data obat
    </div>

    <!-- Modal Form -->
    <div v-if="showFormCreate" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
      <div class="bg-white rounded-lg shadow-lg p-6 w-full max-w-md">
        <h3 class="text-xl font-bold text-gray-800 mb-4">{{ editingId ? 'Edit Obat' : 'Tambah Obat' }}</h3>
        
        <form @submit.prevent="submitForm">
          <div class="mb-4">
            <label class="block text-gray-700 font-semibold mb-2">Nama Obat</label>
            <input 
              v-model="form.nama_obat"
              type="text"
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-600"
              required
            />
          </div>

          <div class="mb-4">
            <label class="block text-gray-700 font-semibold mb-2">Dosis</label>
            <input 
              v-model="form.dosis"
              type="text"
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-600"
              required
            />
          </div>

          <div class="mb-4">
            <label class="block text-gray-700 font-semibold mb-2">Tipe</label>
            <input 
              v-model="form.tipe"
              type="text"
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-600"
              required
            />
          </div>

          <div class="mb-4">
            <label class="block text-gray-700 font-semibold mb-2">Deskripsi</label>
            <textarea 
              v-model="form.deskripsi"
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-600"
              rows="4"
            ></textarea>
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
import { ref, onMounted } from 'vue'
import LayoutWrapper from '../components/LayoutWrapper.vue'
import { obatService } from '../services'

export default {
  components: {
    LayoutWrapper
  },
  name: 'ObatView',
  setup() {
    const obatList = ref([])
    const loading = ref(false)
    const error = ref(null)

    const showFormCreate = ref(false)
    const editingId = ref(null)
    const form = ref({
      nama_obat: '',
      dosis: '',
      tipe: '',
      deskripsi: ''
    })

    const fetchObats = async () => {
      loading.value = true
      try {
        const response = await obatService.getAllObat()
        obatList.value = response.data.data || []
        error.value = null
      } catch (err) {
        error.value = 'Gagal memuat data obat'
        console.error(err)
      } finally {
        loading.value = false
      }
    }

    const submitForm = async () => {
      try {
        if (editingId.value) {
          await obatService.updateObat(editingId.value, form.value)
          alert('Obat berhasil diupdate')
        } else {
          await obatService.createObat(form.value)
          alert('Obat berhasil ditambahkan')
        }
        closeForm()
        fetchObats()
      } catch (err) {
        alert('Gagal menyimpan obat: ' + err.message)
      }
    }

    const editObat = (obat) => {
      editingId.value = obat.id
      form.value = { ...obat }
      showFormCreate.value = true
    }

    const confirmDelete = async (id) => {
      if (confirm('Apakah Anda yakin ingin menghapus obat ini?')) {
        try {
          await obatService.deleteObat(id)
          alert('Obat berhasil dihapus')
          fetchObats()
        } catch (err) {
          alert('Gagal menghapus obat: ' + err.message)
        }
      }
    }

    const closeForm = () => {
      showFormCreate.value = false
      editingId.value = null
      form.value = {
        nama_obat: '',
        dosis: '',
        tipe: '',
        deskripsi: ''
      }
    }

    onMounted(fetchObats)

    return {
      obatList,
      loading,
      error,
      showFormCreate,
      editingId,
      form,
      submitForm,
      editObat,
      confirmDelete,
      closeForm
    }
  }
}
</script>
