package catalog

import "time"

type CatalogRecord struct {
	ID             string    `bson:"_id" json:"id" validate:"required"`
	AuthorID       string    `bson:"authorId" json:"author_id" validate:"required"`
	CreatedAt      time.Time `bson:"createdAt" json:"created_at" validate:"required"`
	UpdatedAt      time.Time `bson:"updatedAt" json:"updated_at" validate:"required"`
	CommonName     string    `bson:"commonName" json:"common_name" validate:"required"`
	ScientificName string    `bson:"scientificName" json:"scientific_name" validate:"required"`
	Description    string    `bson:"description" json:"description" validate:"required"`
	Locations      []string  `bson:"locations" json:"locations" validate:"required"`
	Images         []Image   `bson:"images" json:"images" validate:"required"`
}

type Image struct {
	ID              string    `bson:"_id" json:"id" validate:"required"`
	AuthorID        string    `bson:"authorId" json:"author_id" validate:"required"`
	CatalogRecordID string    `bson:"catalogRecordId" json:"catalog_record_id" validate:"required"`
	AuthorName      string    `bson:"authorName" json:"author_name" validate:"required"`
	Description     string    `bson:"description" json:"description" validate:"required"`
	SubmitedAt      time.Time `bson:"submited" json:"submited_at" validate:"required"`
	URL             string    `bson:"url" json:"url" validate:"required"`
}
