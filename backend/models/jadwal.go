package models

import "time"

type Jadwal struct {
	JadwalID  uint      `gorm:"primaryKey" json:"jadwal_id"`
	PasienID  uint      `json:"pasien_id"`
	NamaJadwal string   `json:"nama_jadwal"`
	Catatan   string    `json:"catatan"`
	Dosis     string    `json:"dosis"`
	Gambar    string    `json:"gambar"`
	Frekuensi int       `json:"frekuensi"`
	Durasi    int       `json:"durasi"`
	Status    string    `json:"status"`
	CreatedAt time.Time `json:"created_at"`
}