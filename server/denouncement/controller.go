package denouncement

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"go.mongodb.org/mongo-driver/mongo"
)

type DenouncementController struct {
	Gateway DenouncementRepository
}

func (c *DenouncementController) CreateDenouncement(ctx *gin.Context) {
	var denouncement Denouncement
	if err := ctx.ShouldBindJSON(&denouncement); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if err := c.Gateway.Create(&denouncement); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusCreated, denouncement)
}

func (c *DenouncementController) UpdateDenouncement(ctx *gin.Context) {
	denouncementID := ctx.Param("id")
	var denouncement Denouncement
	if err := ctx.ShouldBindJSON(&denouncement); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	denouncement.ID = denouncementID
	if err := c.Gateway.Update(&denouncement); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, denouncement)
}

func (c *DenouncementController) DeleteDenouncement(ctx *gin.Context) {
	denouncementID := ctx.Param("id")
	if err := c.Gateway.Delete(denouncementID); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	if err := c.Gateway.DeleteCommentsByDenouncementID(denouncementID); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.Status(http.StatusNoContent)
}

func (c *DenouncementController) GetDenouncementByID(ctx *gin.Context) {
	denouncementID := ctx.Param("id")
	denouncement, err := c.Gateway.FindByID(denouncementID)
	if err != nil {
		if err == mongo.ErrNoDocuments {
			ctx.JSON(http.StatusNotFound, gin.H{"error": "Denouncement not found"})
		} else {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}
		return
	}
	ctx.JSON(http.StatusOK, denouncement)
}

func (c *DenouncementController) GetAllDenouncements(ctx *gin.Context) {
	denouncements, err := c.Gateway.FindAll()
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, denouncements)
}

func ProvideDenouncementController(denouncementRepository DenouncementRepository) *DenouncementController {
	return &DenouncementController{
		Gateway: denouncementRepository,
	}
}
