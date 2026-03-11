package models

import (
	"time"
)

// ── Obat ─────────────────────────────────────────────────────────────────────
type Obat struct {
	ObatID          uint      `gorm:"primaryKey;column:obat_id" json:"obat_id"`
	PasienID        uint      `gorm:"column:pasien_id" json:"pasien_id"`
	NakesID         uint      `gorm:"column:nakes_id" json:"nakes_id"`
	NamaObat        string    `gorm:"column:nama_obat" json:"nama_obat"`
	Fungsi          string    `gorm:"column:fungsi" json:"fungsi"`
	AturanPemakaian string    `gorm:"column:aturan_pemakaian" json:"aturan_pemakaian"`
	Pantangan       string    `gorm:"column:pantangan" json:"pantangan"`
	Gambar          string    `gorm:"column:gambar" json:"gambar"`
	CreatedAt       time.Time `json:"created_at"`
	UpdatedAt       time.Time `json:"updated_at"`
}

func (Obat) TableName() string { return "obat" }

// ── JadwalObat ────────────────────────────────────────────────────────────────
type JadwalObat struct {
	JadwalObatID   uint      `gorm:"primaryKey;column:jadwal_obat_id" json:"jadwal_obat_id"`
	ObatID         uint      `gorm:"column:obat_id" json:"obat_id"`
	NakesID        uint      `gorm:"column:nakes_id" json:"nakes_id"`
	TrackingObatID *uint     `gorm:"column:tracking_obat_id" json:"tracking_obat_id"`
	JamMinum       string    `gorm:"column:jam_minum;type:time" json:"jam_minum"`
	CreatedAt      time.Time `json:"created_at"`
	UpdatedAt      time.Time `json:"updated_at"`
}

func (JadwalObat) TableName() string { return "jadwal_obat" }

// ── TrackingObat ──────────────────────────────────────────────────────────────
type TrackingObat struct {
	TrackingObatID uint      `gorm:"primaryKey;column:tracking_obat_id" json:"tracking_obat_id"`
	PasienID       uint      `gorm:"column:pasien_id" json:"pasien_id"`
	NakesID        uint      `gorm:"column:nakes_id" json:"nakes_id"`
	Tanggal        time.Time `gorm:"column:tanggal" json:"tanggal"`
	Status         string    `gorm:"column:status;default:pending" json:"status"`
	UpdatedAt      time.Time `json:"updated_at"`
}

func (TrackingObat) TableName() string { return "tracking_obat" }

// ── ResepObat ─────────────────────────────────────────────────────────────────
type ResepObat struct {
	ResepObatID    uint      `gorm:"primaryKey;column:resep_obat_id" json:"resep_obat_id"`
	PasienID       uint      `gorm:"column:pasien_id" json:"pasien_id"`
	ObatID         uint      `gorm:"column:obat_id" json:"obat_id"`
	NakesID        uint      `gorm:"column:nakes_id" json:"nakes_id"`
	Dosis          string    `gorm:"column:dosis" json:"dosis"`
	TanggalMulai   time.Time `gorm:"column:tanggal_mulai" json:"tanggal_mulai"`
	TanggalSelesai time.Time `gorm:"column:tanggal_selesai" json:"tanggal_selesai"`
	Catatan        string    `gorm:"column:catatan" json:"catatan"`
	CreatedAt      time.Time `json:"created_at"`
	UpdatedAt      time.Time `json:"updated_at"`
}

func (ResepObat) TableName() string { return "resep_obat" }