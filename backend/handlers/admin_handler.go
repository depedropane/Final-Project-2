package handlers

import (
	"golang-app/database"
	"golang-app/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

// AdminDashboard - GET /api/v1/admin/dashboard
func AdminDashboard(c *gin.Context) {
	var totalPasien int64
	var totalJadwal int64

	database.DB.Model(&models.Pasien{}).Count(&totalPasien)
	database.DB.Model(&models.Jadwal{}).Count(&totalJadwal)

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"data": gin.H{
			"total_pasien": totalPasien,
			"total_jadwal": totalJadwal,
		},
	})
}

// AdminGetAllPasien - GET /api/v1/admin/pasien
func AdminGetAllPasien(c *gin.Context) {
	var pasien []models.Pasien
	if err := database.DB.Find(&pasien).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"success": false, "message": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"success": true, "data": pasien})
}

// AdminDeletePasien - DELETE /api/v1/admin/pasien/:id
func AdminDeletePasien(c *gin.Context) {
	id := c.Param("id")
	if err := database.DB.Delete(&models.Pasien{}, id).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"success": false, "message": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"success": true, "message": "Pasien berhasil dihapus"})
}

// AdminGetAllJadwal - GET /api/v1/admin/jadwal
func AdminGetAllJadwal(c *gin.Context) {
	var jadwal []models.Jadwal
	if err := database.DB.Find(&jadwal).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"success": false, "message": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"success": true, "data": jadwal})
}

// AdminCreateJadwal - POST /api/v1/admin/jadwal
func AdminCreateJadwal(c *gin.Context) {
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

	jadwal := models.Jadwal{
		PasienID:   input.PasienID,
		NamaJadwal: input.NamaJadwal,
		Catatan:    input.Catatan,
		Dosis:      input.Dosis,
		Gambar:     input.Gambar,
		Frekuensi:  input.Frekuensi,
		Durasi:     input.Durasi,
		Status:     input.Status,
	}

	if err := database.DB.Create(&jadwal).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"success": false, "message": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"success": true, "message": "Jadwal berhasil dibuat", "data": jadwal})
}

// AdminUpdateJadwal - PUT /api/v1/admin/jadwal/:id
func AdminUpdateJadwal(c *gin.Context) {
	id := c.Param("id")
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

	if err := database.DB.Where("jadwal_id = ?", id).Updates(input).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"success": false, "message": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"success": true, "message": "Jadwal berhasil diupdate"})
}

// AdminDeleteJadwal - DELETE /api/v1/admin/jadwal/:id
func AdminDeleteJadwal(c *gin.Context) {
	id := c.Param("id")
	if err := database.DB.Delete(&models.Jadwal{}, id).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"success": false, "message": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"success": true, "message": "Jadwal berhasil dihapus"})
}

// GetPasienJadwal - GET /api/v1/pasien/jadwal (protected - pasien lihat jadwal mereka)
func GetPasienJadwal(c *gin.Context) {
	userID, _ := c.Get("user_id")
	pasienID := userID.(uint)

	var jadwal []models.Jadwal
	if err := database.DB.Where("pasien_id = ?", pasienID).Find(&jadwal).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"success": false, "message": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"success": true, "data": jadwal})
}
