package repositories

import (
	"golang-app/database"
	"golang-app/models"
)

type PasienRepository struct{}

func NewPasienRepository() *PasienRepository {
	return &PasienRepository{}
}

func (r *PasienRepository) GetAll() ([]models.Pasien, error) {
	var pasien []models.Pasien
	return pasien, database.DB.Find(&pasien).Error
}

func (r *PasienRepository) GetByID(id uint) (*models.Pasien, error) {
	var pasien models.Pasien
	return &pasien, database.DB.First(&pasien, id).Error
}

func (r *PasienRepository) GetByEmail(email string) (*models.Pasien, error) {
	var pasien models.Pasien
	return &pasien, database.DB.Where("email = ?", email).First(&pasien).Error
}

func (r *PasienRepository) Create(pasien *models.Pasien) error {
	return database.DB.Create(pasien).Error
}

func (r *PasienRepository) Update(id uint, pasien *models.Pasien) error {
	return database.DB.Model(&models.Pasien{}).Where("pasien_id = ?", id).Updates(pasien).Error
}

func (r *PasienRepository) Delete(id uint) error {
	return database.DB.Where("pasien_id = ?", id).Delete(&models.Pasien{}).Error
}
