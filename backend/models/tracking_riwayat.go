package models

import "time"

type TrackingRiwayat struct {
	TrackingID uint      `gorm:"primaryKey;column:tracking_id" json:"tracking_id"`
	JadwalID   uint      `gorm:"column:jadwal_id;index" json:"jadwal_id"`
	PasienID   uint      `gorm:"column:pasien_id;index" json:"pasien_id"`
	Tanggal    time.Time `gorm:"column:tanggal;index" json:"tanggal"`
	Status     string    `gorm:"column:status" json:"status"` // "taken" atau "missed"
	Waktu      string    `gorm:"column:waktu" json:"waktu"`   // contoh: "08:10"
	CreatedAt  time.Time `gorm:"column:created_at" json:"created_at"`
	UpdatedAt  time.Time `gorm:"column:updated_at" json:"updated_at"`
}

func (TrackingRiwayat) TableName() string { return "tracking_riwayat" }
