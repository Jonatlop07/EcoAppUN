package sowing

import "github.com/gin-gonic/gin"

func SetupSowingWorkshopRoutes(router *gin.Engine, sowingWorkshopController *SowingWorkshopController) {
	sowingWorkshopGroup := router.Group("/sowing-workshops")
	{
		sowingWorkshopGroup.GET("", sowingWorkshopController.GetAllWorkshops)
		sowingWorkshopGroup.GET("/:id", sowingWorkshopController.GetWorkshopByID)
		sowingWorkshopGroup.POST("", sowingWorkshopController.CreateWorkshop)
		sowingWorkshopGroup.PUT("/:id", sowingWorkshopController.UpdateWorkshop)
		sowingWorkshopGroup.DELETE("/:id", sowingWorkshopController.DeleteWorkshop)
		sowingWorkshopGroup.PATCH("/:id/attendees/:attendee_id", sowingWorkshopController.AddAttendee)
		sowingWorkshopGroup.DELETE("/:id/attendees/:attendee_id", sowingWorkshopController.RemoveAttendee)
		sowingWorkshopGroup.PATCH("/:id/objectives/", sowingWorkshopController.UpdateObjectives)
	}
}
