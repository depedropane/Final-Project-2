package services

import (
	"golang-app/models"
	"golang-app/repositories"

	"golang.org/x/crypto/bcrypt"
)

type NakesService struct {
	repo *repositories.NakesRepository
}

func NewNakesService(repo *repositories.NakesRepository) *NakesService {
	return &NakesService{repo: repo}
}

func (s *NakesService) GetAllNakes() ([]models.Nakes, error) {
	return s.repo.GetAll()
}

func (s *NakesService) GetNakesByID(id uint) (*models.Nakes, error) {
	return s.repo.GetByID(id)
}

func (s *NakesService) CreateNakes(nakes *models.Nakes) error {
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(nakes.Password), bcrypt.DefaultCost)
	if err != nil {
		return err
	}
	nakes.Password = string(hashedPassword)
	return s.repo.Create(nakes)
}

func (s *NakesService) DeleteNakes(id uint) error {
	return s.repo.Delete(id)
}
