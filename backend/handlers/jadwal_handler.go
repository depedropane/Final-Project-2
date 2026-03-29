package handlers

import (
	"golang-app/database"
	"golang-app/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

// GET ALL
func GetJadwal(c *gin.Context) {
	var jadwal []models.Jadwal
	database.DB.Find(&jadwal)

	c.JSON(http.StatusOK, gin.H{
		"data": jadwal,
	})
}

// CREATE
func CreateJadwal(c *gin.Context) {
	var jadwal models.Jadwal

	if err := c.ShouldBindJSON(&jadwal); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	jadwal.Status = "active"

	database.DB.Create(&jadwal)

	c.JSON(http.StatusOK, gin.H{
		"message": "Jadwal berhasil dibuat",
		"data":    jadwal,
	})
}

// DELETE
func DeleteJadwal(c *gin.Context) {
	id := c.Param("id")

	database.DB.Delete(&models.Jadwal{}, id)

	c.JSON(http.StatusOK, gin.H{
		"message": "Jadwal berhasil dihapus",
	})
}