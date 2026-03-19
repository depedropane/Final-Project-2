package models

import (
	"time"
)

// ─── Rutinitas ────────────────────────────────────────────────────────────────

type Rutinitas struct {
	RutinitasID    uint      `gorm:"primaryKey;column:rutinitas_id" json:"rutinitas_id"`
	PasienID       uint      `gorm:"column:pasien_id;not null" json:"pasien_id"`
	NamaRutinitas  string    `gorm:"column:nama_rutinitas" json:"nama_rutinitas"`
	Deskripsi      string    `gorm:"column:deskripsi" json:"deskripsi"`
	WaktuReminder  string    `gorm:"column:waktu_reminder;type:time" json:"waktu_reminder"`
	TanggalMulai   time.Time `gorm:"column:tanggal_mulai" json:"tanggal_mulai"`
	TanggalSelesai time.Time `gorm:"column:tanggal_selesai" json:"tanggal_selesai"`
	Status         string    `gorm:"column:status;default:aktif" json:"status"`
	Gambar         string    `gorm:"column:gambar" json:"gambar"`
	CreatedAt      time.Time `gorm:"column:created_at" json:"created_at"`
	UpdatedAt      time.Time `gorm:"column:updated_at" json:"updated_at"`
}

func (Rutinitas) TableName() string { return "rutinitas" }

// ─── TrackingRutinitas ────────────────────────────────────────────────────────

type TrackingRutinitas struct {
	TrackingRutinitasID uint      `gorm:"primaryKey;column:tracking_rutinitas_id" json:"tracking_rutinitas_id"`
	RutinitasID         uint      `gorm:"column:rutinitas_id;not null" json:"rutinitas_id"`
	PasienID            uint      `gorm:"column:pasien_id;not null" json:"pasien_id"`
	Status              string    `gorm:"column:status;default:pending" json:"status"`
	Tanggal             time.Time `gorm:"column:tanggal" json:"tanggal"`
	UpdatedAt           time.Time `gorm:"column:updated_at" json:"updated_at"`
}

func (TrackingRutinitas) TableName() string { return "tracking_rutinitas" }