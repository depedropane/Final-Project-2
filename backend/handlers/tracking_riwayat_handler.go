package handlers

import (
	"golang-app/models"
	"golang-app/services"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
)

type TrackingRiwayatHandler struct {
	trackingService *services.TrackingRiwayatService
}

func NewTrackingRiwayatHandler(trackingService *services.TrackingRiwayatService) *TrackingRiwayatHandler {
	return &TrackingRiwayatHandler{trackingService: trackingService}
}

// GET tracking riwayat by pasien ID
func (h *TrackingRiwayatHandler) GetByPasien(c *gin.Context) {
	pasienID := c.Param("pasien_id")
	pid, _ := strconv.ParseUint(pasienID, 10, 32)

	tracking, err := h.trackingService.GetByPasienID(uint(pid))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "success", "data": tracking})
}

// GET tracking by date range
func (h *TrackingRiwayatHandler) GetByDateRange(c *gin.Context) {
	pasienID := c.Param("pasien_id")
	pid, _ := strconv.ParseUint(pasienID, 10, 32)

	startDateStr := c.Query("start_date")
	endDateStr := c.Query("end_date")

	startDate, _ := time.Parse("2006-01-02", startDateStr)
	endDate, _ := time.Parse("2006-01-02", endDateStr)

	tracking, err := h.trackingService.GetByDateRange(uint(pid), startDate, endDate)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "success", "data": tracking})
}

// GET compliance stats
func (h *TrackingRiwayatHandler) GetComplianceStats(c *gin.Context) {
	pasienID := c.Param("pasien_id")
	pid, _ := strconv.ParseUint(pasienID, 10, 32)

	takenDoses, totalDoses, err := h.trackingService.GetComplianceStats(uint(pid))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	percentage := 0.0
	if totalDoses > 0 {
		percentage = (float64(takenDoses) / float64(totalDoses)) * 100
	}

	c.JSON(http.StatusOK, gin.H{
		"status":      "success",
		"taken_doses": takenDoses,
		"total_doses": totalDoses,
		"percentage":  percentage,
	})
}

// CREATE tracking
func (h *TrackingRiwayatHandler) Create(c *gin.Context) {
	var tracking models.TrackingRiwayat

	if err := c.ShouldBindJSON(&tracking); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := h.trackingService.Create(&tracking); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Tracking berhasil dibuat",
		"data":    tracking,
	})
}

// UPDATE tracking
func (h *TrackingRiwayatHandler) Update(c *gin.Context) {
	id := c.Param("id")
	trackingID, _ := strconv.ParseUint(id, 10, 32)

	var tracking models.TrackingRiwayat
	if err := c.ShouldBindJSON(&tracking); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := h.trackingService.Update(uint(trackingID), &tracking); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Tracking berhasil diupdate",
		"data":    tracking,
	})
}

// DELETE tracking
func (h *TrackingRiwayatHandler) Delete(c *gin.Context) {
	id := c.Param("id")
	trackingID, _ := strconv.ParseUint(id, 10, 32)

	if err := h.trackingService.Delete(uint(trackingID)); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Tracking berhasil dihapus",
	})
}
