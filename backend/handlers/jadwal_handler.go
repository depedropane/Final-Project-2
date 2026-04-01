package handlers

import (
	"golang-app/models"
	"golang-app/services"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

type JadwalHandler struct {
	jadwalService *services.JadwalService
}

func NewJadwalHandler(jadwalService *services.JadwalService) *JadwalHandler {
	return &JadwalHandler{jadwalService: jadwalService}
}

// GET ALL
func (h *JadwalHandler) GetJadwal(c *gin.Context) {
	jadwal, err := h.jadwalService.GetAllJadwal()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"data": jadwal})
}

// CREATE
func (h *JadwalHandler) CreateJadwal(c *gin.Context) {
	var jadwal models.Jadwal

	if err := c.ShouldBindJSON(&jadwal); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := h.jadwalService.CreateJadwal(&jadwal); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Jadwal berhasil dibuat",
		"data":    jadwal,
	})
}

// DELETE
func (h *JadwalHandler) DeleteJadwal(c *gin.Context) {
	id := c.Param("id")
	jadwalID, _ := strconv.ParseUint(id, 10, 32)

	if err := h.jadwalService.DeleteJadwal(uint(jadwalID)); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Jadwal berhasil dihapus",
	})
}
