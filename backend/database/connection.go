package database

import (
	"fmt"
	"golang-app/models"
	"log"
	"os"

	"github.com/joho/godotenv"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var DB *gorm.DB

func ConnectDatabase() {
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}

	dsn := fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s sslmode=%s",
		os.Getenv("DB_HOST"), os.Getenv("DB_USER"), os.Getenv("DB_PASSWORD"),
		os.Getenv("DB_NAME"), os.Getenv("DB_PORT"), os.Getenv("DB_SSLMODE"))

	database, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		panic("Gagal koneksi ke database!")
	}

	err = database.AutoMigrate(
		// Level 1: tabel tanpa FK ke sesama tabel aplikasi
		&models.Pasien{},
		&models.Nakes{},

		// Level 2: tabel yang FK ke pasien / nakes saja
		&models.Obat{},
		&models.Jadwal{},
		&models.Rutinitas{},
		&models.TrackingObat{},

		// Level 3: tabel yang FK ke obat / jadwal / rutinitas
		&models.JadwalObat{},
		&models.ResepObat{},
		&models.TrackingJadwal{},
		&models.TrackingRutinitas{},
	)
	if err != nil {
		log.Fatal("Gagal migrasi database:", err)
	}

	DB = database
	log.Println("Database terkoneksi dan migrasi berhasil!")
}