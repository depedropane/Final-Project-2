package repositories

import (
	"golang-app/database"
	"golang-app/models"
)

type InfoObatRepository struct{}

func NewInfoObatRepository() *InfoObatRepository {
	return &InfoObatRepository{}
}

func (r *InfoObatRepository) GetAll() ([]models.InfoObat, error) {
	var infoObat []models.InfoObat
	return infoObat, database.DB.Order("created_at DESC").Find(&infoObat).Error
}

func (r *InfoObatRepository) GetByID(id uint) (*models.InfoObat, error) {
	var infoObat models.InfoObat
	return &infoObat, database.DB.First(&infoObat, id).Error
}

func (r *InfoObatRepository) SearchByNama(nama string) ([]models.InfoObat, error) {
	var infoObat []models.InfoObat
	return infoObat, database.DB.Where("LOWER(nama_obat) LIKE LOWER(?)", "%"+nama+"%").
		Order("created_at DESC").Find(&infoObat).Error
}

func (r *InfoObatRepository) Create(infoObat *models.InfoObat) error {
	return database.DB.Create(infoObat).Error
}

func (r *InfoObatRepository) Update(id uint, infoObat *models.InfoObat) error {
	return database.DB.Model(&models.InfoObat{}).Where("info_obat_id = ?", id).Updates(infoObat).Error
}

func (r *InfoObatRepository) Delete(id uint) error {
	return database.DB.Where("info_obat_id = ?", id).Delete(&models.InfoObat{}).Error
}