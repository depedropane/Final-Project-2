package utils

import (
	"errors"
	"os"
	"time"

	"github.com/golang-jwt/jwt/v5"
)

var jwtSecret = []byte(os.Getenv("JWT_SECRET"))

type Claims struct {
	ID   uint
	Role string // "pasien" atau "nakes"
	Nama string
	jwt.RegisteredClaims
}

// GenerateToken membuat JWT token
func GenerateToken(id uint, role, nama string) (string, error) {
	if len(jwtSecret) == 0 {
		jwtSecret = []byte("your-secret-key-change-in-env")
	}

	claims := &Claims{
		ID:   id,
		Role: role,
		Nama: nama,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(24 * time.Hour)),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString(jwtSecret)
}

// ValidateToken memvalidasi JWT token
func ValidateToken(tokenString string) (*Claims, error) {
	if len(jwtSecret) == 0 {
		jwtSecret = []byte("your-secret-key-change-in-env")
	}

	claims := &Claims{}
	token, err := jwt.ParseWithClaims(tokenString, claims, func(token *jwt.Token) (interface{}, error) {
		return jwtSecret, nil
	})

	if err != nil {
		return nil, err
	}

	if !token.Valid {
		return nil, errors.New("invalid token")
	}

	return claims, nil
}
