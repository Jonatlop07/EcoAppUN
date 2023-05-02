package ecorecovery

import "github.com/gin-gonic/gin"

func SetupEcorecoveryWorkshopRoutes(router *gin.Engine, ecorecoveryWorkshopController *EcorecoveryWorkshopController) {
	ecorecoveryWorkshopGroup := router.Group("/ecorecovery-workshop")
	{
		ecorecoveryWorkshopGroup.GET("", ecorecoveryWorkshopController.GetAllWorkshops)
		ecorecoveryWorkshopGroup.GET("/:id", ecorecoveryWorkshopController.GetWorkshopByID)
		ecorecoveryWorkshopGroup.POST("", ecorecoveryWorkshopController.CreateWorkshop)
		ecorecoveryWorkshopGroup.PATCH("/:id", ecorecoveryWorkshopController.UpdateWorkshop)
		ecorecoveryWorkshopGroup.DELETE("/:id", ecorecoveryWorkshopController.DeleteWorkshop)
		ecorecoveryWorkshopGroup.PATCH("/:id/attendees/:attendee_id", ecorecoveryWorkshopController.AddAttendee)
		ecorecoveryWorkshopGroup.DELETE("/:id/attendees/:attendee_id", ecorecoveryWorkshopController.RemoveAttendee)
		ecorecoveryWorkshopGroup.PATCH("/:id/objectives/", ecorecoveryWorkshopController.UpdateObjectives)
	}
}
