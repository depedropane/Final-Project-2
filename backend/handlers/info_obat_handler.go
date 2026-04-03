package handlers

import (
	"golang-app/models"
	"golang-app/services"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

type InfoObatHandler struct {
	infoObatService *services.InfoObatService
}

func NewInfoObatHandler(infoObatService *services.InfoObatService) *InfoObatHandler {
	return &InfoObatHandler{infoObatService: infoObatService}
}

// GET /api/v1/info-obat?search=xxx
func (h *InfoObatHandler) GetAll(c *gin.Context) {
	search := c.Query("search")
	if search != "" {
		data, err := h.infoObatService.SearchByNama(search)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusOK, gin.H{"status": "success", "data": data})
		return
	}

	data, err := h.infoObatService.GetAll()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "success", "data": data})
}

// GET /api/v1/info-obat/:id
func (h *InfoObatHandler) GetByID(c *gin.Context) {
	id, _ := strconv.ParseUint(c.Param("id"), 10, 32)

	data, err := h.infoObatService.GetByID(uint(id))
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Info obat tidak ditemukan"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "success", "data": data})
}

// POST /api/v1/info-obat (nakes only)
func (h *InfoObatHandler) Create(c *gin.Context) {
	var infoObat models.InfoObat
	if err := c.ShouldBindJSON(&infoObat); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := h.infoObatService.Create(&infoObat); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Info obat berhasil ditambahkan", "data": infoObat})
}

// PUT /api/v1/info-obat/:id (nakes only)
func (h *InfoObatHandler) Update(c *gin.Context) {
	id, _ := strconv.ParseUint(c.Param("id"), 10, 32)

	var infoObat models.InfoObat
	if err := c.ShouldBindJSON(&infoObat); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := h.infoObatService.Update(uint(id), &infoObat); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Info obat berhasil diupdate"})
}

// DELETE /api/v1/info-obat/:id (nakes only)
func (h *InfoObatHandler) Delete(c *gin.Context) {
	id, _ := strconv.ParseUint(c.Param("id"), 10, 32)

	if err := h.infoObatService.Delete(uint(id)); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Info obat berhasil dihapus"})
}