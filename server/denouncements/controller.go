package denouncement

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
	"go.mongodb.org/mongo-driver/mongo"
)

type DenouncementController struct {
	Gateway DenouncementRepository
}

func (denouncementController *DenouncementController) CreateDenouncement(ctx *gin.Context) {
	var denouncement Denouncement
	if err := ctx.ShouldBindJSON(&denouncement); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	validate := validator.New()
	if err := validate.Struct(denouncement); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
	}
	if err := denouncementController.Gateway.Create(&denouncement); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusCreated, denouncement)
}

func (denouncementController *DenouncementController) UpdateDenouncement(ctx *gin.Context) {
	denouncementID := ctx.Param("id")
	var denouncement Denouncement
	if err := ctx.ShouldBindJSON(&denouncement); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	denouncement.ID = denouncementID
	if err := denouncementController.Gateway.Update(&denouncement); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, denouncement)
}

func (denouncementController *DenouncementController) DeleteDenouncement(ctx *gin.Context) {
	denouncementID := ctx.Param("id")
	if err := denouncementController.Gateway.Delete(denouncementID); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	if err := denouncementController.Gateway.DeleteCommentsByDenouncementID(denouncementID); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.Status(http.StatusNoContent)
}

func (denouncementController *DenouncementController) GetDenouncementByID(ctx *gin.Context) {
	denouncementID := ctx.Param("id")
	denouncement, err := denouncementController.Gateway.FindByID(denouncementID)
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

func (denouncementController *DenouncementController) GetAllDenouncements(ctx *gin.Context) {
	denouncements, err := denouncementController.Gateway.FindAll()
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
