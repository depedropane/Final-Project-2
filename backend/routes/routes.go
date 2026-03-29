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

		// ── Nakes ────────────────────────────────────────────────────────────
		nakes := api.Group("/nakes")
		{
			nakes.GET("", handlers.GetNakes)
			nakes.POST("/register", handlers.RegisterNakes)
		}

		// ── Jadwal ─────────────────────────────
		jadwal := api.Group("/jadwal")
		{
			jadwal.GET("", handlers.GetJadwal)
			jadwal.POST("", handlers.CreateJadwal)
			jadwal.DELETE("/:id", handlers.DeleteJadwal)
		}
	}

	return r
}