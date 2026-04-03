package models

import "time"

type InfoObat struct {
	InfoObatID  uint      `gorm:"primaryKey;column:info_obat_id" json:"info_obat_id"`
	NamaObat    string    `gorm:"column:nama_obat" json:"nama_obat"`
	Kategori    string    `gorm:"column:kategori" json:"kategori"`
	Frekuensi   string    `gorm:"column:frekuensi" json:"frekuensi"`     // contoh: "3-4x sehari"
	Durasi      string    `gorm:"column:durasi" json:"durasi"`           // contoh: "3-5 hari"
	WaktuMinum  string    `gorm:"column:waktu_minum" json:"waktu_minum"` // contoh: "Sesudah makan"
	Fungsi      string    `gorm:"column:fungsi" json:"fungsi"`
	AturanPakai string    `gorm:"column:aturan_pakai" json:"aturan_pakai"`
	Perhatian   string    `gorm:"column:perhatian" json:"perhatian"`
	Warna       string    `gorm:"column:warna" json:"warna"` // hex color, contoh: "#4CAF82"
	CreatedAt   time.Time `gorm:"column:created_at" json:"created_at"`
	UpdatedAt   time.Time `gorm:"column:updated_at" json:"updated_at"`
}

func (InfoObat) TableName() string { return "info_obat" }