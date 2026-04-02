package repositories

import (
	"golang-app/database"
	"golang-app/models"
	"time"
)

type TrackingRiwayatRepository struct{}

func NewTrackingRiwayatRepository() *TrackingRiwayatRepository {
	return &TrackingRiwayatRepository{}
}

// Get all tracking
func (r *TrackingRiwayatRepository) GetAll() ([]models.TrackingRiwayat, error) {
	var tracking []models.TrackingRiwayat
	return tracking, database.DB.Order("tanggal DESC").Find(&tracking).Error
}

// Get tracking by Pasien ID
func (r *TrackingRiwayatRepository) GetByPasienID(pasienID uint) ([]models.TrackingRiwayat, error) {
	var tracking []models.TrackingRiwayat
	return tracking, database.DB.
		Where("pasien_id = ?", pasienID).
		Order("tanggal DESC").
		Find(&tracking).Error
}

// Get tracking by date range
func (r *TrackingRiwayatRepository) GetByDateRange(pasienID uint, startDate, endDate time.Time) ([]models.TrackingRiwayat, error) {
	var tracking []models.TrackingRiwayat
	return tracking, database.DB.
		Where("pasien_id = ? AND tanggal >= ? AND tanggal <= ?", pasienID, startDate, endDate).
		Order("tanggal DESC").
		Find(&tracking).Error
}

// Get single tracking
func (r *TrackingRiwayatRepository) GetByID(id uint) (*models.TrackingRiwayat, error) {
	var tracking models.TrackingRiwayat
	return &tracking, database.DB.First(&tracking, id).Error
}

// Create tracking
func (r *TrackingRiwayatRepository) Create(tracking *models.TrackingRiwayat) error {
	return database.DB.Create(tracking).Error
}

// Update tracking
func (r *TrackingRiwayatRepository) Update(id uint, tracking *models.TrackingRiwayat) error {
	return database.DB.Model(&models.TrackingRiwayat{}).Where("tracking_id = ?", id).Updates(tracking).Error
}

// Delete tracking
func (r *TrackingRiwayatRepository) Delete(id uint) error {
	return database.DB.Where("tracking_id = ?", id).Delete(&models.TrackingRiwayat{}).Error
}

// Get compliance stats
func (r *TrackingRiwayatRepository) GetComplianceStats(pasienID uint) (int, int, error) {
	var totalDoses int64
	var takenDoses int64

	if err := database.DB.
		Model(&models.TrackingRiwayat{}).
		Where("pasien_id = ?", pasienID).
		Count(&totalDoses).Error; err != nil {
		return 0, 0, err
	}

	if err := database.DB.
		Model(&models.TrackingRiwayat{}).
		Where("pasien_id = ? AND status = ?", pasienID, "taken").
		Count(&takenDoses).Error; err != nil {
		return 0, 0, err
	}

	return int(takenDoses), int(totalDoses), nil
}
