package denouncement

import "github.com/gin-gonic/gin"

func SetupDenouncementRoutes(router *gin.Engine, denouncementController *DenouncementController) {
	denouncementGroup := router.Group("/denouncements")
	{
		denouncementGroup.GET("", denouncementController.GetAllDenouncements)
		denouncementGroup.POST("", denouncementController.CreateDenouncement)
		denouncementGroup.GET("/:id", denouncementController.GetDenouncementByID)
		denouncementGroup.DELETE("/:id", denouncementController.DeleteDenouncement)
		denouncementGroup.PATCH("/:id", denouncementController.UpdateDenouncement)
	}
}
