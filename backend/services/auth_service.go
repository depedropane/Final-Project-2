package services

import (
	"errors"
	"golang-app/repositories"
	"golang-app/utils"

	"golang.org/x/crypto/bcrypt"
)

type AuthService struct {
	pasienRepo *repositories.PasienRepository
	nakesRepo  *repositories.NakesRepository
}

func NewAuthService(pasienRepo *repositories.PasienRepository, nakesRepo *repositories.NakesRepository) *AuthService {
	return &AuthService{
		pasienRepo: pasienRepo,
		nakesRepo:  nakesRepo,
	}
}

func (s *AuthService) LoginPasien(email string, password string) (string, uint, string, error) {
	pasien, err := s.pasienRepo.GetByEmail(email)
	if err != nil {
		return "", 0, "", errors.New("email atau password salah")
	}

	if err := bcrypt.CompareHashAndPassword([]byte(pasien.Password), []byte(password)); err != nil {
		return "", 0, "", errors.New("email atau password salah")
	}

	token, err := utils.GenerateToken(pasien.PasienID, "pasien", pasien.Nama)
	if err != nil {
		return "", 0, "", err
	}

	return token, pasien.PasienID, pasien.Nama, nil
}

func (s *AuthService) LoginNakes(email string, password string) (string, uint, string, error) {
	nakes, err := s.nakesRepo.GetByEmail(email)
	if err != nil {
		return "", 0, "", errors.New("email atau password salah")
	}

	if err := bcrypt.CompareHashAndPassword([]byte(nakes.Password), []byte(password)); err != nil {
		return "", 0, "", errors.New("email atau password salah")
	}

	token, err := utils.GenerateToken(nakes.NakesID, "nakes", nakes.Nama)
	if err != nil {
		return "", 0, "", err
	}

	return token, nakes.NakesID, nakes.Nama, nil
}
