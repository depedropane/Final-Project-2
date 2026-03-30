package handlers

import (
	"golang-app/database"
	"golang-app/models"
	"golang-app/utils"
	"net/http"

	"github.com/gin-gonic/gin"
	"golang.org/x/crypto/bcrypt"
)

type LoginRequest struct {
	Email    string `json:"email" binding:"required"`
	Password string `json:"password" binding:"required"`
}

type LoginResponse struct {
	Success bool   `json:"success"`
	Message string `json:"message"`
	Token   string `json:"token,omitempty"`
	Data    any    `json:"data,omitempty"`
}

// LoginPasien - POST /api/v1/auth/pasien/login
func LoginPasien(c *gin.Context) {
	var input LoginRequest
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, LoginResponse{
			Success: false,
			Message: "Email dan password tidak boleh kosong",
		})
		return
	}

	var pasien models.Pasien
	if err := database.DB.Where("email = ?", input.Email).First(&pasien).Error; err != nil {
		c.JSON(http.StatusUnauthorized, LoginResponse{
			Success: false,
			Message: "Email atau password salah",
		})
		return
	}

	// Validasi password
	if err := bcrypt.CompareHashAndPassword([]byte(pasien.Password), []byte(input.Password)); err != nil {
		c.JSON(http.StatusUnauthorized, LoginResponse{
			Success: false,
			Message: "Email atau password salah",
		})
		return
	}

	// Generate token
	token, err := utils.GenerateToken(pasien.PasienID, "pasien", pasien.Nama)
	if err != nil {
		c.JSON(http.StatusInternalServerError, LoginResponse{
			Success: false,
			Message: "Gagal generate token",
		})
		return
	}

	c.JSON(http.StatusOK, LoginResponse{
		Success: true,
		Message: "Login berhasil",
		Token:   token,
		Data: gin.H{
			"id":    pasien.PasienID,
			"nama":  pasien.Nama,
			"email": pasien.Email,
			"role":  "pasien",
		},
	})
}

// LoginNakes - POST /api/v1/auth/nakes/login
func LoginNakes(c *gin.Context) {
	var input LoginRequest
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, LoginResponse{
			Success: false,
			Message: "Email dan password tidak boleh kosong",
		})
		return
	}

	var nakes models.Nakes
	if err := database.DB.Where("email = ?", input.Email).First(&nakes).Error; err != nil {
		c.JSON(http.StatusUnauthorized, LoginResponse{
			Success: false,
			Message: "Email atau password salah",
		})
		return
	}

	// Validasi password
	if err := bcrypt.CompareHashAndPassword([]byte(nakes.Password), []byte(input.Password)); err != nil {
		c.JSON(http.StatusUnauthorized, LoginResponse{
			Success: false,
			Message: "Email atau password salah",
		})
		return
	}

	// Generate token
	token, err := utils.GenerateToken(nakes.NakesID, "nakes", nakes.Nama)
	if err != nil {
		c.JSON(http.StatusInternalServerError, LoginResponse{
			Success: false,
			Message: "Gagal generate token",
		})
		return
	}

	c.JSON(http.StatusOK, LoginResponse{
		Success: true,
		Message: "Login berhasil",
		Token:   token,
		Data: gin.H{
			"id":    nakes.NakesID,
			"nama":  nakes.Nama,
			"email": nakes.Email,
			"role":  "nakes",
		},
	})
}
