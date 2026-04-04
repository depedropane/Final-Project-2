import { ref, onMounted } from 'vue'
import { obatService } from '../services'

export function useObat() {
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
      await fetchObats()
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
        await fetchObats()
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
    fetchObats,
    submitForm,
    editObat,
    confirmDelete,
    closeForm
  }
}
