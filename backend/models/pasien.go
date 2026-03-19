package models

import (
	"time"

	"gorm.io/gorm"
)

type Pasien struct {
	PasienID     uint           `gorm:"primaryKey;column:pasien_id" json:"pasien_id"`
	Nama         string         `gorm:"column:nama" json:"nama"`
	Email        string         `gorm:"column:email;unique" json:"email"`
	Password     string         `gorm:"column:password" json:"-"`
	Nik          string         `gorm:"column:nik;unique" json:"nik"`
	TanggalLahir time.Time      `gorm:"column:tanggal_lahir" json:"tanggal_lahir"`
	TempatLahir  string         `gorm:"column:tempat_lahir" json:"tempat_lahir"`
	Alamat       string         `gorm:"column:alamat" json:"alamat"`
	JenisKelamin string         `gorm:"column:jenis_kelamin" json:"jenis_kelamin"`
	NoTelepon    string         `gorm:"column:no_telepon" json:"no_telepon"`
	CreatedAt    time.Time      `gorm:"column:created_at" json:"created_at"`
	UpdatedAt    time.Time      `gorm:"column:updated_at" json:"updated_at"`
	DeletedAt    gorm.DeletedAt `gorm:"index" json:"-"`
}

func (Pasien) TableName() string { return "pasien" }