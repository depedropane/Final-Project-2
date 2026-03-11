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

	// Grouping API sesuai dengan AppConfig.baseUrl di Flutter: /api/v1
	api := r.Group("/api/v1")
	{
		// Grouping untuk fitur Pasien
		pasien := api.Group("/pasien")
		{
			// GET /api/v1/pasien (Untuk mengambil semua data pasien)
			pasien.GET("", handlers.GetPasien)
			
			// POST /api/v1/pasien/register (Untuk pendaftaran pasien baru)
			pasien.POST("/register", handlers.RegisterPasien)
			
			// POST /api/v1/pasien/login (Untuk login pasien)
			pasien.POST("/login", handlers.LoginPasien)
		}
	}

	return r
}