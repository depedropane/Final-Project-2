package handlers

import (
	"golang-app/database"
	"golang-app/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

// POST /api/v1/obat
func CreateObat(c *gin.Context) {
	var input struct {
		PasienID        uint   `json:"pasien_id"`
		NakesID         uint   `json:"nakes_id"`
		NamaObat        string `json:"nama_obat"`
		Fungsi          string `json:"fungsi"`
		AturanPemakaian string `json:"aturan_pemakaian"`
		Catatan         string `json:"catatan"`
		Gambar          string `json:"gambar"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "message": "Format data salah"})
		return
	}

	// ── Validasi field wajib ──────────────────────────────────────────────────
	if input.PasienID == 0 {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "message": "pasien_id tidak boleh kosong"})
		return
	}
	if input.NakesID == 0 {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "message": "nakes_id tidak boleh kosong"})
		return
	}
	if input.NamaObat == "" {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "message": "nama_obat tidak boleh kosong"})
		return
	}

	// ── Cek pasien & nakes exist ──────────────────────────────────────────────
	var pasien models.Pasien
	if err := database.DB.First(&pasien, input.PasienID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"success": false, "message": "Pasien tidak ditemukan"})
		return
	}

	var nakes models.Nakes
	if err := database.DB.First(&nakes, input.NakesID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"success": false, "message": "Nakes tidak ditemukan"})
		return
	}

	// ── Simpan obat ───────────────────────────────────────────────────────────
	obat := models.Obat{
		PasienID:        input.PasienID,
		NakesID:         input.NakesID,
		NamaObat:        input.NamaObat,
		Fungsi:          input.Fungsi,
		AturanPemakaian: input.AturanPemakaian,
		Catatan:         input.Catatan,
		Gambar:          input.Gambar,
	}

	if err := database.DB.Create(&obat).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"message": "Gagal simpan database",
			"error":   err.Error(),
		})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"success": true, "message": "Obat berhasil ditambahkan", "data": obat})
}

// GET /api/v1/obat
func GetObat(c *gin.Context) {
	var obat []models.Obat
	if err := database.DB.Find(&obat).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"success": false, "error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"success": true, "data": obat})
}