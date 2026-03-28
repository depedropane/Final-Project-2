package handlers

import (
	"golang-app/database"
	"golang-app/models"
	"net/http"
	"time"
	"unicode"

	"github.com/gin-gonic/gin"
	"golang.org/x/crypto/bcrypt"
)

func GetPasien(c *gin.Context) {
	var pasien []models.Pasien
	if err := database.DB.Find(&pasien).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "success", "data": pasien})
}

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

	// ── Validasi field wajib ──────────────────────────────────────────────────
	if input.Nama == "" {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "message": "Nama tidak boleh kosong"})
		return
	}
	if input.Email == "" {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "message": "Email tidak boleh kosong"})
		return
	}
	if len(input.Password) < 8 {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "message": "Password minimal 8 karakter"})
		return
	}

	// ── Validasi NIK: harus tepat 16 digit angka ──────────────────────────────
	if len(input.Nik) != 16 {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": "NIK harus 16 digit",
		})
		return
	}
	for _, ch := range input.Nik {
		if !unicode.IsDigit(ch) {
			c.JSON(http.StatusBadRequest, gin.H{
				"success": false,
				"message": "NIK hanya boleh berisi angka",
			})
			return
		}
	}

	// ── Validasi jenis kelamin ────────────────────────────────────────────────
	if input.JenisKelamin != "L" && input.JenisKelamin != "P" {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "message": "Jenis kelamin harus 'L' atau 'P'"})
		return
	}

	// ── Parse tanggal lahir ───────────────────────────────────────────────────
	tglLahir, err := time.Parse("2006-01-02", input.TanggalLahir)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "message": "Format tanggal salah, gunakan YYYY-MM-DD"})
		return
	}

	// ── Cek duplikat email & NIK ──────────────────────────────────────────────
	var existing models.Pasien
	if err := database.DB.Where("email = ?", input.Email).First(&existing).Error; err == nil {
		c.JSON(http.StatusConflict, gin.H{"success": false, "message": "Email sudah terdaftar"})
		return
	}
	if err := database.DB.Where("nik = ?", input.Nik).First(&existing).Error; err == nil {
		c.JSON(http.StatusConflict, gin.H{"success": false, "message": "NIK sudah terdaftar"})
		return
	}

	// ── Hash password & simpan ────────────────────────────────────────────────
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

	if err := database.DB.Create(&pasien).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"message": "Gagal simpan database",
			"error":   err.Error(),
		})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"success": true, "message": "Registrasi berhasil", "data": pasien})
}

func LoginPasien(c *gin.Context) { 
	var input struct {
		Email    string `json:"email"`
		Password string `json:"password"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "message": "Input tidak valid"})
		return
	}

	if input.Email == "" || input.Password == "" {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "message": "Email dan password wajib diisi"})
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