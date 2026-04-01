package repositories

import (
	"golang-app/database"
	"golang-app/models"
)

type NakesRepository struct{}

func NewNakesRepository() *NakesRepository {
	return &NakesRepository{}
}

func (r *NakesRepository) GetAll() ([]models.Nakes, error) {
	var nakes []models.Nakes
	return nakes, database.DB.Find(&nakes).Error
}

func (r *NakesRepository) GetByID(id uint) (*models.Nakes, error) {
	var nakes models.Nakes
	return &nakes, database.DB.First(&nakes, id).Error
}

func (r *NakesRepository) GetByEmail(email string) (*models.Nakes, error) {
	var nakes models.Nakes
	return &nakes, database.DB.Where("email = ?", email).First(&nakes).Error
}

func (r *NakesRepository) Create(nakes *models.Nakes) error {
	return database.DB.Create(nakes).Error
}

func (r *NakesRepository) Update(id uint, nakes *models.Nakes) error {
	return database.DB.Model(&models.Nakes{}).Where("nakes_id = ?", id).Updates(nakes).Error
}

func (r *NakesRepository) Delete(id uint) error {
	return database.DB.Where("nakes_id = ?", id).Delete(&models.Nakes{}).Error
}
