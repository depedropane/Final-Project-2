package main

import (
    "golang-app/database"
    "golang-app/routes"
    "golang-app/models"
    "os"
)

func main() {
    // 1. Koneksi DB
    database.ConnectDatabase()

    // 2. Auto Migration 
    database.DB.AutoMigrate(&models.Pasien{}, &models.Nakes{})

    // 3. Setup Routes
    r := routes.SetupRoutes()

    // 4. Run Server
    port := os.Getenv("PORT")
    if port == "" { port = "8080" }
    r.Run(":" + port)
}