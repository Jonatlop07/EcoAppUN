package catalog

import (
	"time"
)

type CatalogRecord struct {
	ID             string    `json:"id" validate:"required"`
	AuthorID       string    `json:"author_id" validate:"required"`
	CreatedAt      time.Time `json:"created_at" validate:"required"`
	UpdatedAt      time.Time `json:"updated_at" validate:"required"`
	CommonName     string    `json:"common_name" validate:"required"`
	ScientificName string    `json:"scientific_name" validate:"required"`
	Description    string    `json:"description" validate:"required"`
	Locations      []string  `json:"locations" validate:"required"`
	Images         []Image   `json:"images" validate:"required"`
}

type Image struct {
	ID          string    `json:"id" validate:"required"`
	AuthorID    string    `json:"author_id" validate:"required"`
	AuthorName  string    `json:"author_name" validate:"required"`
	Description string    `json:"description" validate:"required"`
	SubmitedAt  time.Time `json:"submited_at" validate:"required"`
	URL         string    `json:"url" validate:"required"`
}
