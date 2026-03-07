package handlers

import (
	"golang-app/database"
	"golang-app/models"
	"net/http"
	"github.com/gin-gonic/gin"
)

func GetPasien(c *gin.Context) {
	var pasien []models.Pasien
	
	// Query: SELECT * FROM pasiens
	if err := database.DB.Find(&pasien).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"status": "success",
		"data":   pasien,
	})
}