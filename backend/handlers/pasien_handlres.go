package handlers

import (
	"golang-app/database"
	"golang-app/models"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"golang.org/x/crypto/bcrypt"
)

// Pastikan G-nya KAPITAL agar bisa dibaca dari routes.go
func GetPasien(c *gin.Context) {
	var pasien []models.Pasien
	if err := database.DB.Find(&pasien).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "success", "data": pasien})
}

// Fungsi Register yang kita bahas sebelumnya
func RegisterPasien(c *gin.Context) {
	var input struct {
		Nama         string `json:"nama"`
		Email        string `json:"email"`
		Password     string `json:"password"`
		Nik          string `json:"nik"`
		TanggalLahir string `json:"tanggal_lahir"`
		TempatLahir  string `json:"tempat_lahir"`
		Alamat       string `json:"alamat"`
		JenisKelamin string `json:"jenis_kelamin"`
		NoTelepon    string `json:"no_telepon"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "message": "Format data salah"})
		return
	}

	// Parsing tanggal sesuai format YYYY-MM-DD dari Flutter/Postman
	tglLahir, err := time.Parse("2006-01-02", input.TanggalLahir)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "message": "Format tanggal salah, gunakan YYYY-MM-DD"})
		return
	}

	hashedPassword, _ := bcrypt.GenerateFromPassword([]byte(input.Password), bcrypt.DefaultCost)

	pasien := models.Pasien{
		Nama:         input.Nama,
		Email:        input.Email,
		Password:     string(hashedPassword),
		Nik:          input.Nik,
		TanggalLahir: tglLahir,
		TempatLahir:  input.TempatLahir,
		Alamat:       input.Alamat,
		JenisKelamin: input.JenisKelamin,
		NoTelepon:    input.NoTelepon,
	}

	// Tambahkan .Error untuk menangkap pesan asli dari database
	if err := database.DB.Create(&pasien).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false, 
			"message": "Gagal simpan database",
			"error": err.Error(), // Menampilkan detail error (misal: duplicate key)
		})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"success": true, "message": "Registrasi berhasil", "data": pasien})
}

// Pastikan L-nya KAPITAL
func LoginPasien(c *gin.Context) {
	var input struct {
		Email    string `json:"email"`
		Password string `json:"password"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "message": "Input tidak valid"})
		return
	}

	var pasien models.Pasien
	if err := database.DB.Where("email = ?", input.Email).First(&pasien).Error; err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"success": false, "message": "Akun tidak ditemukan"})
		return
	}

	if err := bcrypt.CompareHashAndPassword([]byte(pasien.Password), []byte(input.Password)); err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"success": false, "message": "Password salah"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"message": "Login berhasil!",
		"data": gin.H{
			"token": "dummy-token-pa2",
			"user":  pasien,
		},
	})
}