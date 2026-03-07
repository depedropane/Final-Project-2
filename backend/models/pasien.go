package models

import (
	"time"
	"gorm.io/gorm"
)

type Pasien struct {
	gorm.Model
	Nama         string    `json:"nama"`
	Email        string    `json:"email" gorm:"unique"`
	Password     string    `json:"-"`
	Nik          string    `json:"nik" gorm:"unique"`
	TanggalLahir time.Time `json:"tanggal_lahir"`
	TempatLahir  string    `json:"tempat_lahir"`
	Alamat       string    `json:"alamat"`
	JenisKelamin string    `json:"jenis_kelamin"` 
	NoTelepon    string    `json:"no_telepon"`
}