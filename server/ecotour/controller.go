package ecotour

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
	"go.mongodb.org/mongo-driver/mongo"
)

type EcotourController struct {
	Gateway EcotourRepository
}

func (controller *EcotourController) CreateEcotour(ctx *gin.Context) {
	var ecotour Ecotour
	if err := ctx.ShouldBindJSON(&ecotour); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	validate := validator.New()
	if err := validate.Struct(ecotour); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
	}
	if err := controller.Gateway.Create(&ecotour); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusCreated, ecotour)
}

func (controller *EcotourController) GetEcotourByID(ctx *gin.Context) {
	ecotourID := ctx.Param("id")
	ecotour, err := controller.Gateway.GetByID(ecotourID)
	if err != nil {
		if err == mongo.ErrNoDocuments {
			ctx.JSON(http.StatusNotFound, gin.H{"error": "Denouncement not found"})
		} else {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}
		return
	}
	ctx.JSON(http.StatusOK, ecotour)
}

func (controller *EcotourController) GetAllEcotours(ctx *gin.Context) {
	ecotours, err := controller.Gateway.GetAll()
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, ecotours)
}

func (controller *EcotourController) UpdateEcotour(ctx *gin.Context) {
	ecotourID := ctx.Param("id")
	var ecotour Ecotour
	if err := ctx.ShouldBindJSON(&ecotour); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	ecotour.ID = ecotourID
	validate := validator.New()
	if err := validate.Struct(ecotour); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
	}
	if err := controller.Gateway.Update(&ecotour); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, ecotour)
}

func (controller *EcotourController) DeleteEcotour(ctx *gin.Context) {
	ecotourID := ctx.Param("id")
	if err := controller.Gateway.Delete(ecotourID); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.Status(http.StatusNoContent)
}

func (controller *EcotourController) AddAttendee(ctx *gin.Context) {
	ecotourID := ctx.Param("id")
	attendeeID := ctx.Param("attendee_id")
	if err := controller.Gateway.AddAttendee(ecotourID, attendeeID); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.Status(http.StatusOK)
}

func (controller *EcotourController) RemoveAttendee(ctx *gin.Context) {
	ecotourID := ctx.Param("id")
	attendeeID := ctx.Param("attendee_id")
	if err := controller.Gateway.RemoveAttendee(ecotourID, attendeeID); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.Status(http.StatusNoContent)
}

func ProvideEcotourController(ecotourRepository EcotourRepository) *EcotourController {
	return &EcotourController{
		Gateway: ecotourRepository,
	}
}
