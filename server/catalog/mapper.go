package catalog

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

func FromDetails(catalogRecordDetails CatalogRecordDetails) CatalogRecord {
	catalogRecordID := primitive.NewObjectID().Hex()
	images := []Image{}
	for _, imageDetails := range catalogRecordDetails.Images {
		images = append(images, FromImageDetails(imageDetails))
	}
	catalogRecord := CatalogRecord{
		ID:             catalogRecordID,
		AuthorID:       catalogRecordDetails.AuthorID,
		CreatedAt:      time.Now(),
		UpdatedAt:      time.Now(),
		CommonName:     catalogRecordDetails.CommonName,
		ScientificName: catalogRecordDetails.ScientificName,
		Description:    catalogRecordDetails.Description,
		Locations:      catalogRecordDetails.Locations,
		Images:         images,
	}
	return catalogRecord
}

func FromImageDetails(imageDetails ImageDetails) Image {
	return Image{
		ID:          primitive.NewObjectID().Hex(),
		AuthorID:    imageDetails.AuthorID,
		AuthorName:  imageDetails.AuthorName,
		Description: imageDetails.Description,
		SubmitedAt:  time.Now(),
		URL:         imageDetails.URL,
	}
}

func FromCatalogRecord(catalogRecord CatalogRecord) CatalogRecordModel {
	modelImages := []ImageModel{}
	catalogRecordId, _ := primitive.ObjectIDFromHex(catalogRecord.ID)
	authorId, _ := primitive.ObjectIDFromHex(catalogRecord.AuthorID)
	for _, image := range catalogRecord.Images {
		modelImages = append(modelImages, FromImage(image))
	}
	return CatalogRecordModel{
		ID:             catalogRecordId,
		AuthorID:       authorId,
		CreatedAt:      catalogRecord.CreatedAt,
		UpdatedAt:      catalogRecord.UpdatedAt,
		CommonName:     catalogRecord.CommonName,
		ScientificName: catalogRecord.ScientificName,
		Description:    catalogRecord.Description,
		Locations:      catalogRecord.Locations,
		Images:         modelImages,
	}
}

func FromCatalogRecordModel(model CatalogRecordModel) CatalogRecord {
	images := []Image{}
	catalogRecordId := model.ID.Hex()
	authorId := model.AuthorID.Hex()
	for _, imageModel := range model.Images {
		images = append(images, FromImageModel(imageModel))
	}
	return CatalogRecord{
		ID:             catalogRecordId,
		AuthorID:       authorId,
		CreatedAt:      model.CreatedAt,
		UpdatedAt:      model.UpdatedAt,
		CommonName:     model.CommonName,
		ScientificName: model.ScientificName,
		Description:    model.Description,
		Locations:      model.Locations,
		Images:         images,
	}
}

func FromImage(image Image) ImageModel {
	var imageId primitive.ObjectID
	var submitedAt time.Time
	if image.ID != "" {
		imageId, _ = primitive.ObjectIDFromHex(image.ID)
	} else {
		imageId = primitive.NewObjectID()
	}
	if submitedAt = image.SubmitedAt; image.SubmitedAt.IsZero() {
		submitedAt = time.Now()
	}
	authorId, _ := primitive.ObjectIDFromHex(image.AuthorID)
	return ImageModel{
		ID:          imageId,
		AuthorID:    authorId,
		AuthorName:  image.AuthorName,
		Description: image.Description,
		SubmitedAt:  submitedAt,
		URL:         image.URL,
	}
}

func FromImageModel(imageModel ImageModel) Image {
	imageId := imageModel.ID.Hex()
	authorId := imageModel.AuthorID.Hex()
	return Image{
		ID:          imageId,
		AuthorID:    authorId,
		AuthorName:  imageModel.AuthorName,
		Description: imageModel.Description,
		SubmitedAt:  imageModel.SubmitedAt,
		URL:         imageModel.URL,
	}
}
