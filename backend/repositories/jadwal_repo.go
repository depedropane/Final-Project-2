package repositories

import (
	"golang-app/database"
	"golang-app/models"
)

type JadwalRepository struct{}

func NewJadwalRepository() *JadwalRepository {
	return &JadwalRepository{}
}

func (r *JadwalRepository) GetAll() ([]models.Jadwal, error) {
	var jadwal []models.Jadwal
	return jadwal, database.DB.Find(&jadwal).Error
}

func (r *JadwalRepository) GetByID(id uint) (*models.Jadwal, error) {
	var jadwal models.Jadwal
	return &jadwal, database.DB.First(&jadwal, id).Error
}

func (r *JadwalRepository) GetByPasienID(pasienID uint) ([]models.Jadwal, error) {
	var jadwal []models.Jadwal
	return jadwal, database.DB.Where("pasien_id = ?", pasienID).Find(&jadwal).Error
}

func (r *JadwalRepository) Create(jadwal *models.Jadwal) error {
	return database.DB.Create(jadwal).Error
}

func (r *JadwalRepository) Update(id uint, jadwal *models.Jadwal) error {
	return database.DB.Model(&models.Jadwal{}).Where("jadwal_id = ?", id).Updates(jadwal).Error
}

func (r *JadwalRepository) Delete(id uint) error {
	return database.DB.Where("jadwal_id = ?", id).Delete(&models.Jadwal{}).Error
}
