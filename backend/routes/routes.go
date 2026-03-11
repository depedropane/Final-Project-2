package routes

import (
	"golang-app/handlers"
	"github.com/gin-gonic/gin"
)

func SetupRoutes() *gin.Engine {
	r := gin.Default()

	// Middleware CORS
	r.Use(func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization")
		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}
		c.Next()
	})

	api := r.Group("/api/v1")
	{
		// ── Pasien ──────────────────────────────────────────────────────────
		pasien := api.Group("/pasien")
		{
			pasien.GET("", handlers.GetPasien)
			pasien.POST("/register", handlers.RegisterPasien)
			pasien.POST("/login", handlers.LoginPasien)
		}

		// ── Jadwal Obat ──────────────────────────────────────────────────────
		jadwalObat := api.Group("/jadwal-obat")
		{
			// GET  /api/v1/jadwal-obat/:pasien_id → ambil jadwal hari ini
			jadwalObat.GET("/:pasien_id", handlers.GetJadwalObatHariIni)

			// PUT  /api/v1/jadwal-obat/tracking/:jadwal_obat_id → update status
			jadwalObat.PUT("/tracking/:jadwal_obat_id", handlers.UpdateStatusTracking)
		}
	}

	return r
}