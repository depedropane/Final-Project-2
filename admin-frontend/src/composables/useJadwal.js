import { ref } from 'vue'
import { useJadwalStore } from '../stores/jadwal'

export function useJadwal() {
  const jadwalStore = useJadwalStore()

  const showFormCreate = ref(false)
  const editingId = ref(null)
  const form = ref({
    hari: '',
    jam_mulai: '',
    jam_selesai: '',
    nakes_id: null
  })

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

  return {
    showFormCreate,
    editingId,
    form,
    submitForm,
    editJadwal,
    confirmDelete,
    closeForm
  }
}
