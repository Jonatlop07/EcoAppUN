package denouncement

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

type DenouncementModel struct {
	ID                 primitive.ObjectID            `bson:"_id" json:"id" validate:"required"`
	DenouncerID        primitive.ObjectID            `bson:"denouncerId" json:"denouncer_id" validate:"required"`
	Title              string                        `bson:"title" json:"title" validate:"required"`
	CreatedAt          time.Time                     `bson:"createdAt" json:"created_at" validate:"required"`
	UpdatedAt          time.Time                     `bson:"updatedAt" json:"updated_at" validate:"required"`
	InitialDate        time.Time                     `bson:"initialDate" json:"initial_date" validate:"required"`
	FinalDate          time.Time                     `bson:"finalDate" json:"final_date" validate:"required"`
	Description        string                        `bson:"description" json:"description" validate:"required"`
	MultimediaElements []DenouncementMultimediaModel `bson:"multimediaElements" json:"multimedia_elements" validate:"required"`
	Comments           []CommentModel                `bson:"comments" json:"comments"`
}

type DenouncementMultimediaModel struct {
	Description string    `bson:"description" json:"description" validate:"required"`
	SubmitedAt  time.Time `bson:"submited" json:"submited_at" validate:"required"`
	Uri         string    `bson:"uri" json:"uri" validate:"required"`
}

type CommentModel struct {
	ID        primitive.ObjectID     `bson:"_id" json:"id" validate:"required"`
	AuthorID  primitive.ObjectID     `bson:"authorId" json:"author_id" validate:"required"`
	Content   string                 `bson:"content" json:"content" validate:"required"`
	CreatedAt time.Time              `bson:"createdAt" json:"created_at" validate:"required"`
	Reactions []CommentReactionModel `bson:"reactions" json:"reactions" validate:"required"`
	Responses []ResponseModel        `bson:"responses" json:"responses" validate:"required"`
}

type CommentReactionModel struct {
	Type      string             `bson:"type" json:"type" validate:"required"`
	AuthorID  primitive.ObjectID `bson:"authorId" json:"author_id" validate:"required"`
	CreatedAt time.Time          `bson:"createdAt" json:"created_at" validate:"required"`
}

type ResponseModel struct {
	ID        primitive.ObjectID      `bson:"_id" json:"id" validate:"required"`
	AuthorID  primitive.ObjectID      `bson:"authorId" json:"author_id" validate:"required"`
	Content   string                  `bson:"content" json:"content" validate:"required"`
	CreatedAt time.Time               `bson:"createdAt" json:"created_at" validate:"required"`
	Reactions []ResponseReactionModel `bson:"reactions" json:"reactions" validate:"required"`
}

type ResponseReactionModel struct {
	Type      string             `bson:"type" json:"type" validate:"required"`
	AuthorID  primitive.ObjectID `bson:"authorId" json:"author_id" validate:"required"`
	CreatedAt time.Time          `bson:"createdAt" json:"created_at" validate:"required"`
}
