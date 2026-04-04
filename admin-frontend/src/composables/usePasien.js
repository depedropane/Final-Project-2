import { usePasienStore } from '../stores/pasien'

export function usePasien() {
  const pasienStore = usePasienStore()

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

  return {
    confirmDelete
  }
}
