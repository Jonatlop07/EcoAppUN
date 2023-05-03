package catalog

import "time"

type CatalogRecord struct {
	ID             string    `bson:"_id" json:"id"`
	AuthorID       string    `bson:"authorId" json:"author_id"`
	CreatedAt      time.Time `bson:"createdAt" json:"created_at"`
	UpdatedAt      time.Time `bson:"updatedAt" json:"updated_at"`
	CommonName     string    `bson:"commonName" json:"common_name"`
	ScientificName string    `bson:"scientificName" json:"scientific_name"`
	Description    string    `bson:"description" json:"description"`
	Locations      []string  `bson:"locations" json:"locations"`
	Images         []Image   `bson:"images" json:"images"`
}

type Image struct {
	ID          string    `bson:"_id" json:"id"`
	AuthorID    string    `bson:"authorId" json:"author_id"`
	AuthorName  string    `bson:"authorName" json:"author_name"`
	CatalogID   string    `bson:"catalogId" json:"catalog_id"`
	Description string    `bson:"description" json:"description"`
	SubmitedAt  time.Time `bson:"submited" json:"submited_at"`
	URL         string    `bson:"url" json:"url"`
}
