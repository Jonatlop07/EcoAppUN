package catalog

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
	"go.mongodb.org/mongo-driver/mongo"
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
	validate := validator.New()
	if err := validate.Struct(catalogRecordDetails); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	catalogRecordID, err := controller.Gateway.Create(catalogRecordDetails)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusCreated, gin.H{"catalog_record_id": catalogRecordID})
}

func (controller *CatalogController) GetCatalogRecordByID(ctx *gin.Context) {
	id := ctx.Param("id")
	catalogRecord, err := controller.Gateway.GetByID(id)
	if err != nil {
		if err == mongo.ErrNoDocuments {
			ctx.JSON(http.StatusNotFound, gin.H{"error": "Catalog record not found"})
		} else {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}
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
	validate := validator.New()
	if err := validate.Struct(catalogRecord); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	err := controller.Gateway.Update(catalogRecord)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"catalog_record_id": id})
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
