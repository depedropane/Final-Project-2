package services

import (
	"golang-app/models"
	"golang-app/repositories"
	"time"
)

type TrackingRiwayatService struct {
	repo *repositories.TrackingRiwayatRepository
}

func NewTrackingRiwayatService(repo *repositories.TrackingRiwayatRepository) *TrackingRiwayatService {
	return &TrackingRiwayatService{repo: repo}
}

func (s *TrackingRiwayatService) GetAll() ([]models.TrackingRiwayat, error) {
	return s.repo.GetAll()
}

func (s *TrackingRiwayatService) GetByPasienID(pasienID uint) ([]models.TrackingRiwayat, error) {
	return s.repo.GetByPasienID(pasienID)
}

func (s *TrackingRiwayatService) GetByDateRange(pasienID uint, startDate, endDate time.Time) ([]models.TrackingRiwayat, error) {
	return s.repo.GetByDateRange(pasienID, startDate, endDate)
}

func (s *TrackingRiwayatService) GetByID(id uint) (*models.TrackingRiwayat, error) {
	return s.repo.GetByID(id)
}

func (s *TrackingRiwayatService) Create(tracking *models.TrackingRiwayat) error {
	return s.repo.Create(tracking)
}

func (s *TrackingRiwayatService) Update(id uint, tracking *models.TrackingRiwayat) error {
	return s.repo.Update(id, tracking)
}

func (s *TrackingRiwayatService) Delete(id uint) error {
	return s.repo.Delete(id)
}

func (s *TrackingRiwayatService) GetComplianceStats(pasienID uint) (int, int, error) {
	return s.repo.GetComplianceStats(pasienID)
}
