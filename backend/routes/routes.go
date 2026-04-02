package routes

import (
	"golang-app/handlers"
	"golang-app/middleware"
	"golang-app/services"

	"github.com/gin-gonic/gin"
)

func SetupRoutes(
	authService *services.AuthService,
	pasienService *services.PasienService,
	nakesService *services.NakesService,
	jadwalService *services.JadwalService,
	trackingRiwayatService *services.TrackingRiwayatService,
) *gin.Engine {
	r := gin.Default()

	// Middleware CORS
	r.Use(corsMiddleware())

	api := r.Group("/api/v1")
	{
		// ── Auth Routes (public) ──────────────────────────────────────────────
		setupAuthRoutes(api, authService)

		// ── Pasien Routes ─────────────────────────────────────────────────────
		setupPasienRoutes(api, pasienService, jadwalService)

		// ── Nakes Routes ──────────────────────────────────────────────────────
		setupNakesRoutes(api, nakesService)

		// ── Jadwal Routes (public) ────────────────────────────────────────────
		setupJadwalRoutes(api, jadwalService)

		// ── Tracking Riwayat Routes ───────────────────────────────────────────
		setupTrackingRiwayatRoutes(api, trackingRiwayatService)

		// ── Admin Routes (protected: Nakes only) ───────────────────────────────
		setupAdminRoutes(api, pasienService, jadwalService)
	}

	return r
}

// ── Auth Routes ───────────────────────────────────────────────────────────
func setupAuthRoutes(api *gin.RouterGroup, authService *services.AuthService) {
	authHandler := handlers.NewAuthHandler(authService)
	auth := api.Group("/auth")
	{
		auth.POST("/pasien/login", authHandler.LoginPasien)
		auth.POST("/nakes/login", authHandler.LoginNakes)
	}
}

// ── Pasien Routes ─────────────────────────────────────────────────────────
func setupPasienRoutes(api *gin.RouterGroup, pasienService *services.PasienService, jadwalService *services.JadwalService) {
	pasienHandler := handlers.NewPasienHandler(pasienService, jadwalService)
	pasien := api.Group("/pasien")
	{
		pasien.GET("", pasienHandler.GetPasien)
		pasien.POST("/register", pasienHandler.RegisterPasien)

		// Protected: hanya pasien login yang bisa akses
		pasien.GET("/jadwal", middleware.AuthMiddleware, middleware.PasienOnlyMiddleware, pasienHandler.GetPasienJadwal)
	}
}

// ── Nakes Routes ──────────────────────────────────────────────────────────
func setupNakesRoutes(api *gin.RouterGroup, nakesService *services.NakesService) {
	nakesHandler := handlers.NewNakesHandler(nakesService)
	nakes := api.Group("/nakes")
	{
		nakes.GET("", nakesHandler.GetNakes)
		nakes.POST("/register", nakesHandler.RegisterNakes)
	}
}

// ── Jadwal Routes (public) ────────────────────────────────────────────────
func setupJadwalRoutes(api *gin.RouterGroup, jadwalService *services.JadwalService) {
	jadwalHandler := handlers.NewJadwalHandler(jadwalService)
	jadwal := api.Group("/jadwal")
	{
		jadwal.GET("", jadwalHandler.GetJadwal)
		jadwal.POST("", jadwalHandler.CreateJadwal)
		jadwal.DELETE("/:id", jadwalHandler.DeleteJadwal)
	}
}

// ── Admin Routes (Protected: Nakes only) ──────────────────────────────────
func setupAdminRoutes(api *gin.RouterGroup, pasienService *services.PasienService, jadwalService *services.JadwalService) {
	adminHandler := handlers.NewAdminHandler(pasienService, jadwalService)
	admin := api.Group("/admin", middleware.AuthMiddleware, middleware.NakesOnlyMiddleware)
	{
		// Dashboard
		admin.GET("/dashboard", adminHandler.AdminDashboard)

		// Pasien Management
		admin.GET("/pasien", adminHandler.AdminGetAllPasien)
		admin.DELETE("/pasien/:id", adminHandler.AdminDeletePasien)

		// Jadwal Management
		admin.GET("/jadwal", adminHandler.AdminGetAllJadwal)
		admin.POST("/jadwal", adminHandler.AdminCreateJadwal)
		admin.PUT("/jadwal/:id", adminHandler.AdminUpdateJadwal)
		admin.DELETE("/jadwal/:id", adminHandler.AdminDeleteJadwal)
	}
}

// ─── Tracking Riwayat Routes ───────────────────────────────────────────────
func setupTrackingRiwayatRoutes(api *gin.RouterGroup, trackingRiwayatService *services.TrackingRiwayatService) {
	trackingHandler := handlers.NewTrackingRiwayatHandler(trackingRiwayatService)
	tracking := api.Group("/riwayat")
	{
		tracking.GET("/pasien/:pasien_id", trackingHandler.GetByPasien)
		tracking.GET("/pasien/:pasien_id/date-range", trackingHandler.GetByDateRange)
		tracking.GET("/compliance/:pasien_id", trackingHandler.GetComplianceStats)
		tracking.POST("", trackingHandler.Create)
		tracking.PUT("/:id", trackingHandler.Update)
		tracking.DELETE("/:id", trackingHandler.Delete)
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
