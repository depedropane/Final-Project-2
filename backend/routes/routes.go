package routes

import (
	"golang-app/handlers"
	"golang-app/middleware"

	"github.com/gin-gonic/gin"
)

func SetupRoutes() *gin.Engine {
	r := gin.Default()

	// Middleware CORS
	r.Use(corsMiddleware())

	api := r.Group("/api/v1")
	{
		// ── Auth Routes (public) ──────────────────────────────────────────────
		setupAuthRoutes(api)

		// ── Pasien Routes ─────────────────────────────────────────────────────
		setupPasienRoutes(api)

		// ── Nakes Routes ──────────────────────────────────────────────────────
		setupNakesRoutes(api)

		// ── Jadwal Routes (public) ────────────────────────────────────────────
		setupJadwalRoutes(api)

		// ── Admin Routes (protected: Nakes only) ───────────────────────────────
		setupAdminRoutes(api)
	}

	return r
}

// ── Auth Routes ───────────────────────────────────────────────────────────
func setupAuthRoutes(api *gin.RouterGroup) {
	auth := api.Group("/auth")
	{
		auth.POST("/pasien/login", handlers.LoginPasien)
		auth.POST("/nakes/login", handlers.LoginNakes)
	}
}

// ── Pasien Routes ─────────────────────────────────────────────────────────
func setupPasienRoutes(api *gin.RouterGroup) {
	pasien := api.Group("/pasien")
	{
		pasien.GET("", handlers.GetPasien)
		pasien.POST("/register", handlers.RegisterPasien)

		// Protected: hanya pasien login yang bisa akses
		pasien.GET("/jadwal", middleware.AuthMiddleware, middleware.PasienOnlyMiddleware, handlers.GetPasienJadwal)
	}
}

// ── Nakes Routes ──────────────────────────────────────────────────────────
func setupNakesRoutes(api *gin.RouterGroup) {
	nakes := api.Group("/nakes")
	{
		nakes.GET("", handlers.GetNakes)
		nakes.POST("/register", handlers.RegisterNakes)
	}
}

// ── Jadwal Routes (public) ────────────────────────────────────────────────
func setupJadwalRoutes(api *gin.RouterGroup) {
	jadwal := api.Group("/jadwal")
	{
		jadwal.GET("", handlers.GetJadwal)
		jadwal.POST("", handlers.CreateJadwal)
		jadwal.DELETE("/:id", handlers.DeleteJadwal)
	}
}

// ── Admin Routes (Protected: Nakes only) ──────────────────────────────────
func setupAdminRoutes(api *gin.RouterGroup) {
	admin := api.Group("/admin", middleware.AuthMiddleware, middleware.NakesOnlyMiddleware)
	{
		// Dashboard
		admin.GET("/dashboard", handlers.AdminDashboard)

		// Pasien Management
		admin.GET("/pasien", handlers.AdminGetAllPasien)
		admin.DELETE("/pasien/:id", handlers.AdminDeletePasien)

		// Jadwal Management
		admin.GET("/jadwal", handlers.AdminGetAllJadwal)
		admin.POST("/jadwal", handlers.AdminCreateJadwal)
		admin.PUT("/jadwal/:id", handlers.AdminUpdateJadwal)
		admin.DELETE("/jadwal/:id", handlers.AdminDeleteJadwal)
	}
}

// ── CORS Middleware ───────────────────────────────────────────────────────
func corsMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization")
		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}
		c.Next()
	}
}
