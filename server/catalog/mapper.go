package catalog

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

func FromDetails(catalogRecordDetails *CatalogRecordDetails) *CatalogRecord {
	catalogRecordID := primitive.NewObjectID().Hex()
	var images []Image
	for i, imageDetails := range catalogRecordDetails.Images {
		images[i] = Image{
			ID:              primitive.NewObjectID().Hex(),
			AuthorID:        imageDetails.AuthorID,
			AuthorName:      imageDetails.AuthorName,
			CatalogRecordID: catalogRecordID,
			Description:     imageDetails.Description,
			SubmitedAt:      time.Now(),
		}
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
	return &catalogRecord
}
