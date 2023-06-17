package ecorecovery

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
	"go.mongodb.org/mongo-driver/mongo"
)

type EcorecoveryWorkshopController struct {
	Gateway EcorecoveryWorkshopRepository
}

func (controller *EcorecoveryWorkshopController) CreateWorkshop(ctx *gin.Context) {
	var workshopDetails EcorecoveryWorkshopDetails
	if err := ctx.ShouldBindJSON(&workshopDetails); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	validate := validator.New()
	if err := validate.Struct(workshopDetails); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
	}
	createdWorkshop, err := controller.Gateway.Create(workshopDetails)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusCreated, gin.H{"workshop_id": createdWorkshop.ID})
}

func (controller *EcorecoveryWorkshopController) GetWorkshopByID(ctx *gin.Context) {
	workshopID := ctx.Param("id")
	workshop, err := controller.Gateway.GetByID(workshopID)
	if err != nil {
		if err == mongo.ErrNoDocuments {
			ctx.JSON(http.StatusNotFound, gin.H{"error": "Ecorecovery Workshop not found"})
		} else {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"workshop": workshop})
}

func (controller *EcorecoveryWorkshopController) GetAllWorkshops(ctx *gin.Context) {
	workshops, err := controller.Gateway.GetAll()
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"workshops": workshops})
}

func (controller *EcorecoveryWorkshopController) UpdateWorkshop(ctx *gin.Context) {
	var workshop EcorecoveryWorkshop
	if err := ctx.ShouldBindJSON(&workshop); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	validate := validator.New()
	if err := validate.Struct(workshop); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
	}
	updatedWorkshop, err := controller.Gateway.Update(workshop)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"workshop_id": updatedWorkshop.ID})
}

func (controller *EcorecoveryWorkshopController) DeleteWorkshop(ctx *gin.Context) {
	workshopID := ctx.Param("id")
	if err := controller.Gateway.Delete(workshopID); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.Status(http.StatusNoContent)
}

func (controller *EcorecoveryWorkshopController) AddAttendee(ctx *gin.Context) {
	workshopID := ctx.Param("id")
	attendeeID := ctx.Param("attendee_id")
	err := controller.Gateway.AddAttendee(workshopID, attendeeID)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.Status(http.StatusOK)
}

func (controller *EcorecoveryWorkshopController) RemoveAttendee(ctx *gin.Context) {
	workshopID := ctx.Param("id")
	attendeeID := ctx.Param("attendee_id")
	if err := controller.Gateway.RemoveAttendee(workshopID, attendeeID); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.Status(http.StatusNoContent)
}

func (controller *EcorecoveryWorkshopController) UpdateObjectives(ctx *gin.Context) {
	workshopID := ctx.Param("id")
	var objectives []Objective
	if err := ctx.ShouldBindJSON(&objectives); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	updatedObjectives, err := controller.Gateway.UpdateObjectives(workshopID, objectives)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"objectives": updatedObjectives})
}

func ProvideEcorecoveryWorkshopController(ecorecoveryWorkshopRepository EcorecoveryWorkshopRepository) *EcorecoveryWorkshopController {
	return &EcorecoveryWorkshopController{
		Gateway: ecorecoveryWorkshopRepository,
	}
}
