package catalog

import "github.com/gin-gonic/gin"

func SetupCatalogRoutes(router *gin.Engine, catalogController *CatalogController) {
	catalogGroup := router.Group("/catalog-records")
	{
		catalogGroup.GET("", catalogController.GetAllCatalogRecords)
		catalogGroup.POST("", catalogController.CreateCatalogRecord)
		catalogGroup.GET("/:id", catalogController.GetCatalogRecordByID)
		catalogGroup.PUT("/:id", catalogController.UpdateCatalogRecord)
		catalogGroup.DELETE("/:id", catalogController.DeleteCatalogRecord)
		catalogGroup.PATCH("/:id/images", catalogController.AddSpeciesImageToCatalogRecord)
	}
}
