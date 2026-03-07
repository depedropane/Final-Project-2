package routes

import (
    "golang-app/handlers" // Pastikan ini sesuai nama modul di go.mod
    "github.com/gin-gonic/gin"
)

func SetupRoutes() *gin.Engine {
    r := gin.Default()

    api := r.Group("/api")
    {
        api.GET("/pasien", handlers.GetPasien)
    }

    return r
}