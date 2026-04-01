package handlers

import (
	"golang-app/models"
	"golang-app/services"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

type AdminHandler struct {
	pasienService *services.PasienService
	jadwalService *services.JadwalService
}

func NewAdminHandler(pasienService *services.PasienService, jadwalService *services.JadwalService) *AdminHandler {
	return &AdminHandler{
		pasienService: pasienService,
		jadwalService: jadwalService,
	}
}

// AdminDashboard - GET /api/v1/admin/dashboard
func (h *AdminHandler) AdminDashboard(c *gin.Context) {
	pasien, _ := h.pasienService.GetAllPasien()
	jadwal, _ := h.jadwalService.GetAllJadwal()

	totalPasien := int64(len(pasien))
	totalJadwal := int64(len(jadwal))

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"data": gin.H{
			"total_pasien": totalPasien,
			"total_jadwal": totalJadwal,
		},
	})
}

// AdminGetAllPasien - GET /api/v1/admin/pasien
func (h *AdminHandler) AdminGetAllPasien(c *gin.Context) {
	pasien, err := h.pasienService.GetAllPasien()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"success": false, "message": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"success": true, "data": pasien})
}

// AdminDeletePasien - DELETE /api/v1/admin/pasien/:id
func (h *AdminHandler) AdminDeletePasien(c *gin.Context) {
	id := c.Param("id")
	pasienID, _ := strconv.ParseUint(id, 10, 32)

	if err := h.pasienService.DeletePasien(uint(pasienID)); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"success": false, "message": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"success": true, "message": "Pasien berhasil dihapus"})
}

// AdminGetAllJadwal - GET /api/v1/admin/jadwal
func (h *AdminHandler) AdminGetAllJadwal(c *gin.Context) {
	jadwal, err := h.jadwalService.GetAllJadwal()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"success": false, "message": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"success": true, "data": jadwal})
}

// AdminCreateJadwal - POST /api/v1/admin/jadwal
func (h *AdminHandler) AdminCreateJadwal(c *gin.Context) {
	var input struct {
		PasienID   uint   `json:"pasien_id" binding:"required"`
		NamaJadwal string `json:"nama_jadwal" binding:"required"`
		Catatan    string `json:"catatan"`
		Dosis      string `json:"dosis"`
		Gambar     string `json:"gambar"`
		Frekuensi  int    `json:"frekuensi"`
		Durasi     int    `json:"durasi"`
		Status     string `json:"status"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "message": err.Error()})
		return
	}

	jadwal := &models.Jadwal{
		PasienID:   input.PasienID,
		NamaJadwal: input.NamaJadwal,
		Catatan:    input.Catatan,
		Dosis:      input.Dosis,
		Gambar:     input.Gambar,
		Frekuensi:  input.Frekuensi,
		Durasi:     input.Durasi,
		Status:     input.Status,
	}

	if err := h.jadwalService.CreateJadwal(jadwal); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"success": false, "message": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"success": true, "message": "Jadwal berhasil dibuat", "data": jadwal})
}

// AdminUpdateJadwal - PUT /api/v1/admin/jadwal/:id
func (h *AdminHandler) AdminUpdateJadwal(c *gin.Context) {
	id := c.Param("id")
	jadwalID, _ := strconv.ParseUint(id, 10, 32)

	var input struct {
		NamaJadwal string `json:"nama_jadwal"`
		Catatan    string `json:"catatan"`
		Dosis      string `json:"dosis"`
		Gambar     string `json:"gambar"`
		Frekuensi  int    `json:"frekuensi"`
		Durasi     int    `json:"durasi"`
		Status     string `json:"status"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "message": err.Error()})
		return
	}

	jadwal := &models.Jadwal{
		NamaJadwal: input.NamaJadwal,
		Catatan:    input.Catatan,
		Dosis:      input.Dosis,
		Gambar:     input.Gambar,
		Frekuensi:  input.Frekuensi,
		Durasi:     input.Durasi,
		Status:     input.Status,
	}

	if err := h.jadwalService.UpdateJadwal(uint(jadwalID), jadwal); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"success": false, "message": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"success": true, "message": "Jadwal berhasil diupdate"})
}

// AdminDeleteJadwal - DELETE /api/v1/admin/jadwal/:id
func (h *AdminHandler) AdminDeleteJadwal(c *gin.Context) {
	id := c.Param("id")
	jadwalID, _ := strconv.ParseUint(id, 10, 32)

	if err := h.jadwalService.DeleteJadwal(uint(jadwalID)); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"success": false, "message": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"success": true, "message": "Jadwal berhasil dihapus"})
}
