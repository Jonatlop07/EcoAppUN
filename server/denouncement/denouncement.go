package denouncement

import "time"

type Denouncement struct {
	ID                 string                   `json:"id" validate:"required"`
	DenouncerID        string                   `json:"denouncer_id" validate:"required"`
	Title              string                   `json:"title" validate:"required"`
	CreatedAt          time.Time                `json:"created_at" validate:"required"`
	UpdatedAt          time.Time                `json:"updated_at" validate:"required"`
	InitialDate        time.Time                `json:"initial_date" validate:"required"`
	FinalDate          time.Time                `json:"final_date" validate:"required"`
	Description        string                   `json:"description" validate:"required"`
	MultimediaElements []DenouncementMultimedia `json:"multimedia_elements" validate:"required"`
	Comments           []Comment                `json:"comments"`
}

type DenouncementMultimedia struct {
	Description string    `json:"description" validate:"required"`
	SubmitedAt  time.Time `json:"submited_at" validate:"required"`
	Uri         string    `json:"uri" validate:"required"`
}

type Comment struct {
	ID        string            `json:"id" validate:"required"`
	AuthorID  string            `json:"author_id" validate:"required"`
	Content   string            `json:"content" validate:"required"`
	CreatedAt time.Time         `json:"created_at" validate:"required"`
	Reactions []CommentReaction `json:"reactions" validate:"required"`
	Responses []Response        `json:"responses" validate:"required"`
}

type CommentReaction struct {
	Type      string    `json:"type" validate:"required"`
	AuthorID  string    `json:"author_id" validate:"required"`
	CreatedAt time.Time `json:"created_at" validate:"required"`
}

type Response struct {
	ID        string             `json:"id" validate:"required"`
	AuthorID  string             `json:"author_id" validate:"required"`
	Content   string             `json:"content" validate:"required"`
	CreatedAt time.Time          `json:"created_at" validate:"required"`
	Reactions []ResponseReaction `json:"reactions" validate:"required"`
}

type ResponseReaction struct {
	Type      string    `json:"type" validate:"required"`
	AuthorID  string    `json:"author_id" validate:"required"`
	CreatedAt time.Time `json:"created_at" validate:"required"`
}
