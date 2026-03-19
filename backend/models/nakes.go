package models

import (
	"time"

	"gorm.io/gorm"
)

type Nakes struct {
	NakesID      uint           `gorm:"primaryKey;column:nakes_id" json:"nakes_id"`
	Nama         string         `gorm:"column:nama" json:"nama"`
	Email        string         `gorm:"column:email;unique" json:"email"`
	Password     string         `gorm:"column:password" json:"-"`
	Nik          string         `gorm:"column:nik;unique" json:"nik"`
	JenisKelamin string         `gorm:"column:jenis_kelamin" json:"jenis_kelamin"`
	Alamat       string         `gorm:"column:alamat" json:"alamat"`
	CreatedAt    time.Time      `gorm:"column:created_at" json:"created_at"`
	UpdatedAt    time.Time      `gorm:"column:updated_at" json:"updated_at"`
	DeletedAt    gorm.DeletedAt `gorm:"index" json:"-"`
}

func (Nakes) TableName() string { return "nakes" }