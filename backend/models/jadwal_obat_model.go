package models

import (
	"time"
)

// ─── Jadwal ──────────────────────────────────────────────────────────────────

type Jadwal struct {
	JadwalID       uint      `gorm:"primaryKey;column:jadwal_id" json:"jadwal_id"`
	PasienID       uint      `gorm:"column:pasien_id;not null" json:"pasien_id"`
	NakesID        uint      `gorm:"column:nakes_id;not null" json:"nakes_id"`
	NamaJadwal     string    `gorm:"column:nama_jadwal" json:"nama_jadwal"`
	Dosis          string    `gorm:"column:dosis" json:"dosis"`
	Catatan        string    `gorm:"column:catatan" json:"catatan"`
	Status         string    `gorm:"column:status;default:aktif" json:"status"`
	Gambar         string    `gorm:"column:gambar" json:"gambar"`
	Frekuensi      string    `gorm:"column:frekuensi" json:"frekuensi"`
	Durasi         string    `gorm:"column:durasi" json:"durasi"`
	TanggalSelesai time.Time `gorm:"column:tanggal_selesai" json:"tanggal_selesai"`
	CreatedAt      time.Time `gorm:"column:created_at" json:"created_at"`
	UpdatedAt      time.Time `gorm:"column:updated_at" json:"updated_at"`
}

func (Jadwal) TableName() string { return "jadwal" }

// ─── TrackingJadwal ───────────────────────────────────────────────────────────

type TrackingJadwal struct {
	TrackingJadwalID uint      `gorm:"primaryKey;column:tracking_jadwal_id" json:"tracking_jadwal_id"`
	JadwalID         uint      `gorm:"column:jadwal_id;not null" json:"jadwal_id"`
	PasienID         uint      `gorm:"column:pasien_id;not null" json:"pasien_id"`
	Status           string    `gorm:"column:status;default:pending" json:"status"`
	Tanggal          time.Time `gorm:"column:tanggal" json:"tanggal"`
	UpdatedAt        time.Time `gorm:"column:updated_at" json:"updated_at"`
}

func (TrackingJadwal) TableName() string { return "tracking_jadwal" }