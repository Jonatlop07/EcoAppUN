package ecotour

import "github.com/gin-gonic/gin"

func SetupEcotourRoutes(router *gin.Engine, ecotourController *EcotourController) {
	ecotourGroup := router.Group("/ecotours")
	{
		ecotourGroup.GET("", ecotourController.GetAllEcotours)
		ecotourGroup.GET("/:id", ecotourController.GetEcotourByID)
		ecotourGroup.POST("", ecotourController.CreateEcotour)
		ecotourGroup.PATCH("/:id", ecotourController.UpdateEcotour)
		ecotourGroup.DELETE("/:id", ecotourController.DeleteEcotour)
		ecotourGroup.PATCH("/:id/attendants/:id", ecotourController.AddAttendant)
		ecotourGroup.DELETE("/:id/attendants/:id", ecotourController.RemoveAttendant)
	}
}
