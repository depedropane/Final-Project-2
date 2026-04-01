package handlers

import (
	"golang-app/services"
	"net/http"

	"github.com/gin-gonic/gin"
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

type AuthHandler struct {
	authService *services.AuthService
}

func NewAuthHandler(authService *services.AuthService) *AuthHandler {
	return &AuthHandler{authService: authService}
}

// LoginPasien - POST /api/v1/auth/pasien/login
func (h *AuthHandler) LoginPasien(c *gin.Context) {
	var input LoginRequest
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, LoginResponse{
			Success: false,
			Message: "Email dan password tidak boleh kosong",
		})
		return
	}

	token, pasienID, nama, err := h.authService.LoginPasien(input.Email, input.Password)
	if err != nil {
		c.JSON(http.StatusUnauthorized, LoginResponse{
			Success: false,
			Message: err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, LoginResponse{
		Success: true,
		Message: "Login berhasil",
		Token:   token,
		Data: gin.H{
			"id":    pasienID,
			"nama":  nama,
			"email": input.Email,
			"role":  "pasien",
		},
	})
}

// LoginNakes - POST /api/v1/auth/nakes/login
func (h *AuthHandler) LoginNakes(c *gin.Context) {
	var input LoginRequest
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, LoginResponse{
			Success: false,
			Message: "Email dan password tidak boleh kosong",
		})
		return
	}

	token, nakesID, nama, err := h.authService.LoginNakes(input.Email, input.Password)
	if err != nil {
		c.JSON(http.StatusUnauthorized, LoginResponse{
			Success: false,
			Message: err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, LoginResponse{
		Success: true,
		Message: "Login berhasil",
		Token:   token,
		Data: gin.H{
			"id":    nakesID,
			"nama":  nama,
			"email": input.Email,
			"role":  "nakes",
		},
	})
}
