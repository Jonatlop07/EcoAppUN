package catalog

type CatalogRecordDetails struct {
	AuthorID       string         `json:"author_id" validate:"required"`
	CommonName     string         `json:"common_name" validate:"required"`
	ScientificName string         `json:"scientific_name" validate:"required"`
	Description    string         `json:"description" validate:"required"`
	Locations      []string       `json:"locations" validate:"required"`
	Images         []ImageDetails `json:"images" validate:"required"`
}

type ImageDetails struct {
	AuthorID    string `json:"author_id" validate:"required"`
	AuthorName  string `json:"author_name" validate:"required"`
	Description string `json:"description" validate:"required"`
	URL         string `json:"url" validate:"required"`
}
