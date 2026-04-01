package services

import (
	"golang-app/models"
	"golang-app/repositories"

	"golang.org/x/crypto/bcrypt"
)

type PasienService struct {
	repo *repositories.PasienRepository
}

func NewPasienService(repo *repositories.PasienRepository) *PasienService {
	return &PasienService{repo: repo}
}

func (s *PasienService) GetAllPasien() ([]models.Pasien, error) {
	return s.repo.GetAll()
}

func (s *PasienService) GetPasienByID(id uint) (*models.Pasien, error) {
	return s.repo.GetByID(id)
}

func (s *PasienService) CreatePasien(pasien *models.Pasien) error {
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(pasien.Password), bcrypt.DefaultCost)
	if err != nil {
		return err
	}
	pasien.Password = string(hashedPassword)
	return s.repo.Create(pasien)
}

func (s *PasienService) DeletePasien(id uint) error {
	return s.repo.Delete(id)
}
