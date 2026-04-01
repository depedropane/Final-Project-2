package handlers

import (
	"golang-app/models"
	"golang-app/services"
	"net/http"
	"unicode"

	"github.com/gin-gonic/gin"
)

type NakesHandler struct {
	nakesService *services.NakesService
}

func NewNakesHandler(nakesService *services.NakesService) *NakesHandler {
	return &NakesHandler{nakesService: nakesService}
}

// POST /api/v1/nakes/register
func (h *NakesHandler) RegisterNakes(c *gin.Context) {
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

	// ── Buat nakes baru ──────────────────────────────────────────────────────
	nakes := &models.Nakes{
		Nama:         input.Nama,
		Email:        input.Email,
		Password:     input.Password,
		Nik:          input.Nik,
		JenisKelamin: input.JenisKelamin,
		Alamat:       input.Alamat,
	}

	if err := h.nakesService.CreateNakes(nakes); err != nil {
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
func (h *NakesHandler) GetNakes(c *gin.Context) {
	nakes, err := h.nakesService.GetAllNakes()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"success": false, "error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"success": true, "data": nakes})
}
