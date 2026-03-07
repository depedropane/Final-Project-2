package models

import "gorm.io/gorm"

type Nakes struct {
	gorm.Model
	Nama         string `json:"nama"`
	Email        string `json:"email" gorm:"unique"`
	Password     string `json:"-"`
	Nik          string `json:"nik" gorm:"unique"`
	JenisKelamin string `json:"jenis_kelamin"`
	Alamat       string `json:"alamat"`
}