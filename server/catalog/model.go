package catalog

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

type CatalogRecordModel struct {
	ID             primitive.ObjectID `bson:"_id" validate:"required"`
	AuthorID       primitive.ObjectID `bson:"authorId" validate:"required"`
	CreatedAt      time.Time          `bson:"createdAt" validate:"required"`
	UpdatedAt      time.Time          `bson:"updatedAt" validate:"required"`
	CommonName     string             `bson:"commonName" validate:"required"`
	ScientificName string             `bson:"scientificName" validate:"required"`
	Description    string             `bson:"description" validate:"required"`
	Locations      []string           `bson:"locations" validate:"required"`
	Images         []ImageModel       `bson:"images" validate:"required"`
}

type ImageModel struct {
	ID          primitive.ObjectID `bson:"_id" validate:"required"`
	AuthorID    primitive.ObjectID `bson:"authorId" validate:"required"`
	AuthorName  string             `bson:"authorName" validate:"required"`
	Description string             `bson:"description" validate:"required"`
	SubmitedAt  time.Time          `bson:"submited" validate:"required"`
	URL         string             `bson:"url" validate:"required"`
}
