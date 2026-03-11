package handlers

import (
	"golang-app/database"
	"golang-app/models"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
)

// GET /api/v1/jadwal-obat/:pasien_id
// Ambil semua jadwal obat hari ini milik pasien beserta status tracking-nya
func GetJadwalObatHariIni(c *gin.Context) {
	pasienIDStr := c.Param("pasien_id")
	pasienID, err := strconv.Atoi(pasienIDStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "message": "pasien_id tidak valid"})
		return
	}

	today := time.Now().Format("2006-01-02")

	// Query join jadwal_obat → obat → tracking_obat (hari ini)
	type Result struct {
		JadwalObatID uint   `json:"jadwal_obat_id"`
		JamMinum     string `json:"jam_minum"`
		NamaObat     string `json:"nama_obat"`
		Dosis        string `json:"dosis"`
		Status       string `json:"status"`
		TrackingID   *uint  `json:"tracking_obat_id"`
	}

	var results []Result

	err = database.DB.Raw(`
		SELECT
			jo.jadwal_obat_id,
			jo.jam_minum::text AS jam_minum,
			o.nama_obat,
			r.dosis,
			COALESCE(tr.status, 'pending') AS status,
			tr.tracking_obat_id
		FROM jadwal_obat jo
		INNER JOIN obat o ON jo.obat_id = o.obat_id
		LEFT JOIN resep_obat r ON r.obat_id = o.obat_id AND r.pasien_id = ?
		LEFT JOIN tracking_obat tr ON tr.tracking_obat_id = jo.tracking_obat_id
			AND tr.tanggal = ?
		WHERE o.pasien_id = ?
		ORDER BY jo.jam_minum ASC
	`, pasienID, today, pasienID).Scan(&results).Error

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"success": false, "message": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"tanggal": today,
		"data":    results,
	})
}

// PUT /api/v1/jadwal-obat/tracking/:jadwal_obat_id
// Update status tracking (pending → done)
func UpdateStatusTracking(c *gin.Context) {
	jadwalObatIDStr := c.Param("jadwal_obat_id")
	jadwalObatID, err := strconv.Atoi(jadwalObatIDStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "message": "jadwal_obat_id tidak valid"})
		return
	}

	var input struct {
		PasienID uint   `json:"pasien_id"`
		NakesID  uint   `json:"nakes_id"`
		Status   string `json:"status"` // "done" atau "pending"
	}
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"success": false, "message": "Input tidak valid"})
		return
	}

	today := time.Now().Truncate(24 * time.Hour)

	// Cek apakah tracking sudah ada hari ini
	var tracking models.TrackingObat
	result := database.DB.Where(
		"pasien_id = ? AND nakes_id = ? AND tanggal = ?",
		input.PasienID, input.NakesID, today,
	).First(&tracking)

	if result.Error != nil {
		// Buat tracking baru
		tracking = models.TrackingObat{
			PasienID: input.PasienID,
			NakesID:  input.NakesID,
			Tanggal:  today,
			Status:   input.Status,
		}
		database.DB.Create(&tracking)
	} else {
		// Update status
		database.DB.Model(&tracking).Update("status", input.Status)
	}

	// Hubungkan tracking ke jadwal_obat
	database.DB.Model(&models.JadwalObat{}).
		Where("jadwal_obat_id = ?", jadwalObatID).
		Update("tracking_obat_id", tracking.TrackingObatID)

	c.JSON(http.StatusOK, gin.H{
		"success":    true,
		"message":    "Status berhasil diperbarui",
		"tracking":   tracking,
	})
}