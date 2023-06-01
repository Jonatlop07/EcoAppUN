package catalog

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

type CatalogRecordModel struct {
	ID             primitive.ObjectID `bson:"_id" json:"id" validate:"required"`
	AuthorID       primitive.ObjectID `bson:"authorId" json:"author_id" validate:"required"`
	CreatedAt      time.Time          `bson:"createdAt" json:"created_at" validate:"required"`
	UpdatedAt      time.Time          `bson:"updatedAt" json:"updated_at" validate:"required"`
	CommonName     string             `bson:"commonName" json:"common_name" validate:"required"`
	ScientificName string             `bson:"scientificName" json:"scientific_name" validate:"required"`
	Description    string             `bson:"description" json:"description" validate:"required"`
	Locations      []string           `bson:"locations" json:"locations" validate:"required"`
	Images         []ImageModel       `bson:"images" json:"images" validate:"required"`
}

type ImageModel struct {
	ID          primitive.ObjectID `bson:"_id" json:"id" validate:"required"`
	AuthorID    primitive.ObjectID `bson:"authorId" json:"author_id" validate:"required"`
	AuthorName  string             `bson:"authorName" json:"author_name" validate:"required"`
	Description string             `bson:"description" json:"description" validate:"required"`
	SubmitedAt  time.Time          `bson:"submited" json:"submited_at" validate:"required"`
	URL         string             `bson:"url" json:"url" validate:"required"`
}
