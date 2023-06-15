package denouncement

import "time"

type Denouncement struct {
	ID                 string                   `bson:"_id" json:"id" validate:"required"`
	DenouncerID        string                   `bson:"denouncerId" json:"denouncer_id" validate:"required"`
	Title              string                   `bson:"title" json:"title" validate:"required"`
	CreatedAt          time.Time                `bson:"createdAt" json:"created_at" validate:"required"`
	UpdatedAt          time.Time                `bson:"updatedAt" json:"updated_at" validate:"required"`
	InitialDate        time.Time                `bson:"initialDate" json:"initial_date" validate:"required"`
	FinalDate          time.Time                `bson:"finalDate" json:"final_date" validate:"required"`
	Description        string                   `bson:"description" json:"description" validate:"required"`
	MultimediaElements []DenouncementMultimedia `bson:"multimediaElements" json:"multimedia_elements" validate:"required"`
	Comments           []Comment                `bson:"comments" json:"comments"`
}

type DenouncementMultimedia struct {
	Description string    `bson:"description" json:"description" validate:"required"`
	SubmitedAt  time.Time `bson:"submited" json:"submited_at" validate:"required"`
	Uri         string    `bson:"uri" json:"uri" validate:"required"`
}

type Comment struct {
	ID        string            `bson:"_id" json:"id" validate:"required"`
	AuthorID  string            `bson:"authorId" json:"author_id" validate:"required"`
	Content   string            `bson:"content" json:"content" validate:"required"`
	CreatedAt time.Time         `bson:"createdAt" json:"created_at" validate:"required"`
	Reactions []CommentReaction `bson:"reactions" json:"reactions" validate:"required"`
	Responses []Response        `bson:"responses" json:"responses" validate:"required"`
}

type CommentReaction struct {
	Type      string    `bson:"type" json:"type" validate:"required"`
	AuthorID  string    `bson:"authorId" json:"author_id" validate:"required"`
	CreatedAt time.Time `bson:"createdAt" json:"created_at" validate:"required"`
}

type Response struct {
	ID        string             `bson:"_id" json:"id" validate:"required"`
	AuthorID  string             `bson:"authorId" json:"author_id" validate:"required"`
	Content   string             `bson:"content" json:"content" validate:"required"`
	CreatedAt time.Time          `bson:"createdAt" json:"created_at" validate:"required"`
	Reactions []ResponseReaction `bson:"reactions" json:"reactions" validate:"required"`
}

type ResponseReaction struct {
	Type      string    `bson:"type" json:"type" validate:"required"`
	AuthorID  string    `bson:"authorId" json:"author_id" validate:"required"`
	CreatedAt time.Time `bson:"createdAt" json:"created_at" validate:"required"`
}
