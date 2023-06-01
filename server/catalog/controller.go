package catalog

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

type CatalogController struct {
	Gateway CatalogRepository
}

func (controller *CatalogController) CreateCatalogRecord(ctx *gin.Context) {
	var catalogRecordDetails CatalogRecordDetails
	if err := ctx.ShouldBindJSON(&catalogRecordDetails); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	catalogRecordID, err := controller.Gateway.Create(catalogRecordDetails)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"record_id": catalogRecordID})
}

func (controller *CatalogController) GetCatalogRecordByID(ctx *gin.Context) {
	id := ctx.Param("id")
	catalogRecord, err := controller.Gateway.GetByID(id)
	if err != nil {
		ctx.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, catalogRecord)
}

func (controller *CatalogController) GetAllCatalogRecords(ctx *gin.Context) {
	records, err := controller.Gateway.GetAll()
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"records": records})
}

func (controller *CatalogController) UpdateCatalogRecord(ctx *gin.Context) {
	id := ctx.Param("id")
	var catalogRecord CatalogRecord
	if err := ctx.ShouldBindJSON(&catalogRecord); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	catalogRecord.ID = id
	err := controller.Gateway.Update(catalogRecord)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"catalog_record": catalogRecord})
}

func (controller *CatalogController) DeleteCatalogRecord(ctx *gin.Context) {
	id := ctx.Param("id")
	err := controller.Gateway.Delete(id)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"message": "Catalog Record deleted successfully"})
}

func (controller *CatalogController) AddSpeciesImageToCatalogRecord(ctx *gin.Context) {
	id := ctx.Param("id")
	var image Image
	if err := ctx.ShouldBindJSON(&image); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	err := controller.Gateway.AddSpeciesImage(id, image)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"added_image": image})
}

func ProvideCatalogController(catalogRepository CatalogRepository) *CatalogController {
	return &CatalogController{
		Gateway: catalogRepository,
	}
}
