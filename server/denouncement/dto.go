package denouncement

import "time"

type DenouncementDetails struct {
	DenouncerID        string              `json:"denouncer_id" validate:"required"`
	Title              string              `json:"title" validate:"required"`
	Description        string              `json:"description" validate:"required"`
	InitialDate        time.Time           `json:"initial_date" validate:"required"`
	FinalDate          time.Time           `json:"final_date" validate:"required"`
	MultimediaElements []MultimediaDetails `json:"multimedia_elements" validate:"required"`
}

type MultimediaDetails struct {
	Description string `json:"description" validate:"required"`
	Uri         string `json:"uri" validate:"required"`
}

type CommentDetails struct {
	AuthorID string `json:"author_id" validate:"required"`
	Content  string `json:"content" validate:"required"`
}

type CommentReactionDetails struct {
	Type     string `json:"type" validate:"required"`
	AuthorID string `json:"author_id" validate:"required"`
}

type ResponseDetails struct {
	AuthorID string `json:"author_id" validate:"required"`
	Content  string `json:"content" validate:"required"`
}

type ResponseReactionDetails struct {
	Type     string `json:"type" validate:"required"`
	AuthorID string `json:"author_id" validate:"required"`
}

type CommentIdentifiersDTO struct {
	DenouncementID string `validate:"required"`
	CommentID      string `validate:"required"`
}

type CommentReactionIdentifiersDTO struct {
	DenouncementID string `validate:"required"`
	CommentID      string `validate:"required"`
	AuthorID       string `validate:"required"`
}

type ResponseIdentifiersDTO struct {
	DenouncementID string `validate:"required"`
	CommentID      string `validate:"required"`
	ResponseID     string `validate:"required"`
}

type ResponseReactionIdentifiersDTO struct {
	DenouncementID string
	CommentID      string
	ResponseID     string
	AuthorID       string
}
