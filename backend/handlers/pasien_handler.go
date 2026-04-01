package handlers

import (
	"golang-app/models"
	"golang-app/services"
	"net/http"
	"time"
	"unicode"

	"github.com/gin-gonic/gin"
)

type PasienHandler struct {
	pasienService *services.PasienService
	jadwalService *services.JadwalService
}

func NewPasienHandler(pasienService *services.PasienService, jadwalService *services.JadwalService) *PasienHandler {
	return &PasienHandler{
		pasienService: pasienService,
		jadwalService: jadwalService,
	}
}

func (h *PasienHandler) GetPasien(c *gin.Context) {
	pasien, err := h.pasienService.GetAllPasien()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "success", "data": pasien})
}

func (h *PasienHandler) RegisterPasien(c *gin.Context) {
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

	// ── Buat pasien baru ──────────────────────────────────────────────────────
	pasien := &models.Pasien{
		Nama:         input.Nama,
		Email:        input.Email,
		Password:     input.Password,
		Nik:          input.Nik,
		TanggalLahir: tglLahir,
		TempatLahir:  input.TempatLahir,
		Alamat:       input.Alamat,
		JenisKelamin: input.JenisKelamin,
		NoTelepon:    input.NoTelepon,
	}

	if err := h.pasienService.CreatePasien(pasien); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"message": "Gagal simpan database",
			"error":   err.Error(),
		})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"success": true, "message": "Registrasi berhasil", "data": pasien})
}

func (h *PasienHandler) GetPasienJadwal(c *gin.Context) {
	// Ambil pasien ID dari claims (sudah di validasi oleh middleware)
	claims, exists := c.Get("claims")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	// Cast claims untuk mendapatkan ID
	claimsMap := claims.(map[string]interface{})
	pasienIDFloat := claimsMap["id"].(float64)
	pasienID := uint(pasienIDFloat)

	jadwal, err := h.jadwalService.GetJadwalByPasienID(pasienID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success", "data": jadwal})
}
