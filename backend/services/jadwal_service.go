package services

import (
	"golang-app/models"
	"golang-app/repositories"
)

type JadwalService struct {
	repo *repositories.JadwalRepository
}

func NewJadwalService(repo *repositories.JadwalRepository) *JadwalService {
	return &JadwalService{repo: repo}
}

func (s *JadwalService) GetAllJadwal() ([]models.Jadwal, error) {
	return s.repo.GetAll()
}

func (s *JadwalService) GetJadwalByID(id uint) (*models.Jadwal, error) {
	return s.repo.GetByID(id)
}

func (s *JadwalService) GetJadwalByPasienID(pasienID uint) ([]models.Jadwal, error) {
	return s.repo.GetByPasienID(pasienID)
}

func (s *JadwalService) CreateJadwal(jadwal *models.Jadwal) error {
	jadwal.Status = "active"
	return s.repo.Create(jadwal)
}

func (s *JadwalService) UpdateJadwal(id uint, jadwal *models.Jadwal) error {
	return s.repo.Update(id, jadwal)
}

func (s *JadwalService) DeleteJadwal(id uint) error {
	return s.repo.Delete(id)
}
