package sowing

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
	"go.mongodb.org/mongo-driver/mongo"
)

type SowingWorkshopController struct {
	Gateway SowingWorkshopRepository
}

func (controller *SowingWorkshopController) CreateWorkshop(ctx *gin.Context) {
	var sowingWorkshopDetails SowingWorkshopDetails
	if err := ctx.ShouldBindJSON(&sowingWorkshopDetails); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	validate := validator.New()
	if err := validate.Struct(sowingWorkshopDetails); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	createdWorkshop, err := controller.Gateway.Create(sowingWorkshopDetails)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusCreated, gin.H{"workshop_id": createdWorkshop.ID})
}

func (controller *SowingWorkshopController) GetWorkshopByID(ctx *gin.Context) {
	sowingWorkshopID := ctx.Param("id")
	sowingWorkshop, err := controller.Gateway.GetByID(sowingWorkshopID)
	if err != nil {
		if err == mongo.ErrNoDocuments {
			ctx.JSON(http.StatusNotFound, gin.H{"error": "Sowing Workshop not found"})
		} else {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"workshop": sowingWorkshop})
}

func (controller *SowingWorkshopController) GetAllWorkshops(ctx *gin.Context) {
	sowingWorkshops, err := controller.Gateway.GetAll()
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"workshops": sowingWorkshops})
}

func (controller *SowingWorkshopController) UpdateWorkshop(ctx *gin.Context) {
	var sowingWorkshop SowingWorkshop
	if err := ctx.ShouldBindJSON(&sowingWorkshop); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	validate := validator.New()
	if err := validate.Struct(sowingWorkshop); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
	}
	updatedWorkshop, err := controller.Gateway.Update(sowingWorkshop)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"workshop_id": updatedWorkshop.ID})
}

func (controller *SowingWorkshopController) DeleteWorkshop(ctx *gin.Context) {
	sowingWorkshopID := ctx.Param("id")
	if err := controller.Gateway.Delete(sowingWorkshopID); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.Status(http.StatusNoContent)
}

func (controller *SowingWorkshopController) AddAttendee(ctx *gin.Context) {
	var attendee Attendee
	if err := ctx.ShouldBindJSON(&attendee); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	sowingWorkshopID := ctx.Param("id")

	addedAttendee, err := controller.Gateway.AddAttendee(sowingWorkshopID, attendee)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"attendee": addedAttendee})
}

func (controller *SowingWorkshopController) RemoveAttendee(ctx *gin.Context) {
	sowingWorkshopID := ctx.Param("id")
	attendeeID := ctx.Param("attendee_id")
	if err := controller.Gateway.RemoveAttendee(sowingWorkshopID, attendeeID); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.Status(http.StatusNoContent)
}

func (controller *SowingWorkshopController) UpdateObjectives(ctx *gin.Context) {
	sowingWorkshopID := ctx.Param("id")
	var objectives []Objective
	if err := ctx.ShouldBindJSON(&objectives); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	updatedObjectives, err := controller.Gateway.UpdateObjectives(sowingWorkshopID, objectives)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"objectives": updatedObjectives})
}

func ProvideSowingController(sowingWorkshopRepository SowingWorkshopRepository) *SowingWorkshopController {
	return &SowingWorkshopController{
		Gateway: sowingWorkshopRepository,
	}
}
