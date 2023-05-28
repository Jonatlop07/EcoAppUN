package catalog

type CatalogRecordDetails struct {
	AuthorID       string         `bson:"authorId" json:"author_id" validate:"required"`
	CommonName     string         `bson:"commonName" json:"common_name" validate:"required"`
	ScientificName string         `bson:"scientificName" json:"scientific_name" validate:"required"`
	Description    string         `bson:"description" json:"description" validate:"required"`
	Locations      []string       `bson:"locations" json:"locations" validate:"required"`
	Images         []ImageDetails `bson:"images" json:"images" validate:"required"`
}

type ImageDetails struct {
	AuthorID    string `bson:"authorId" json:"author_id" validate:"required"`
	AuthorName  string `bson:"authorName" json:"author_name" validate:"required"`
	Description string `bson:"description" json:"description" validate:"required"`
	URL         string `bson:"url" json:"url" validate:"required"`
}
