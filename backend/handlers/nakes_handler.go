package handlers

import (
	"golang-app/database"
	"golang-app/models"
	"net/http"
	"unicode"

	"github.com/gin-gonic/gin"
	"golang.org/x/crypto/bcrypt"
)

// POST /api/v1/nakes/register
func RegisterNakes(c *gin.Context) {
	var input struct {
		Nama         string `json:"nama"`
		Email        string `json:"email"`
		Password     string `json:"password"`
		Nik          string `json:"nik"`
		JenisKelamin string `json:"jenis_kelamin"`
		Alamat       string `json:"alamat"`
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
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "message": "NIK harus 16 digit"})
		return
	}
	for _, ch := range input.Nik {
		if !unicode.IsDigit(ch) {
			c.JSON(http.StatusBadRequest, gin.H{"success": false, "message": "NIK hanya boleh berisi angka"})
			return
		}
	}

	// ── Validasi jenis kelamin ────────────────────────────────────────────────
	if input.JenisKelamin != "L" && input.JenisKelamin != "P" {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "message": "Jenis kelamin harus 'L' atau 'P'"})
		return
	}

	// ── Cek duplikat email & NIK ──────────────────────────────────────────────
	var existing models.Nakes
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

	nakes := models.Nakes{
		Nama:         input.Nama,
		Email:        input.Email,
		Password:     string(hashedPassword),
		Nik:          input.Nik,
		JenisKelamin: input.JenisKelamin,
		Alamat:       input.Alamat,
	}

	if err := database.DB.Create(&nakes).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"message": "Gagal simpan database",
			"error":   err.Error(),
		})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"success": true, "message": "Registrasi nakes berhasil", "data": nakes})
}

// GET /api/v1/nakes
func GetNakes(c *gin.Context) {
	var nakes []models.Nakes
	if err := database.DB.Find(&nakes).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"success": false, "error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"success": true, "data": nakes})
}