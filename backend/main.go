package main

import (
	"golang-app/database"
	"golang-app/models"
	"golang-app/repositories"
	"golang-app/routes"
	"golang-app/services"
	"os"
)

func main() {
	// 1. Koneksi DB
	database.ConnectDatabase()

	// 2. Auto Migration
	database.DB.AutoMigrate(&models.Pasien{}, &models.Nakes{}, &models.Jadwal{}, &models.TrackingRiwayat{}, &models.InfoObat{})

	// 3. Initialize Repositories
	pasienRepo := repositories.NewPasienRepository()
	nakesRepo := repositories.NewNakesRepository()
	jadwalRepo := repositories.NewJadwalRepository()
	trackingRiwayatRepo := repositories.NewTrackingRiwayatRepository()
	infoObatRepo := repositories.NewInfoObatRepository()
	// 4. Initialize Services
	authService := services.NewAuthService(pasienRepo, nakesRepo)
	pasienService := services.NewPasienService(pasienRepo)
	nakesService := services.NewNakesService(nakesRepo)
	jadwalService := services.NewJadwalService(jadwalRepo)
	trackingRiwayatService := services.NewTrackingRiwayatService(trackingRiwayatRepo)
	infoObatService := services.NewInfoObatService(infoObatRepo)
	// 5. Setup Routes with Services
	r := routes.SetupRoutes(authService, pasienService, nakesService, jadwalService, trackingRiwayatService, infoObatService,)
	// 6. Run Server
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	r.Run(":" + port)
}
