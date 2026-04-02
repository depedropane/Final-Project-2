package services

import (
	"golang-app/models"
	"golang-app/repositories"
)

type InfoObatService struct {
	repo *repositories.InfoObatRepository
}

func NewInfoObatService(repo *repositories.InfoObatRepository) *InfoObatService {
	return &InfoObatService{repo: repo}
}

func (s *InfoObatService) GetAll() ([]models.InfoObat, error) {
	return s.repo.GetAll()
}

func (s *InfoObatService) GetByID(id uint) (*models.InfoObat, error) {
	return s.repo.GetByID(id)
}

func (s *InfoObatService) SearchByNama(nama string) ([]models.InfoObat, error) {
	return s.repo.SearchByNama(nama)
}

func (s *InfoObatService) Create(infoObat *models.InfoObat) error {
	return s.repo.Create(infoObat)
}

func (s *InfoObatService) Update(id uint, infoObat *models.InfoObat) error {
	return s.repo.Update(id, infoObat)
}

func (s *InfoObatService) Delete(id uint) error {
	return s.repo.Delete(id)
}