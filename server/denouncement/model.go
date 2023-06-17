package denouncement

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

type DenouncementModel struct {
	ID                 primitive.ObjectID            `bson:"_id" validate:"required"`
	DenouncerID        primitive.ObjectID            `bson:"denouncerId" validate:"required"`
	Title              string                        `bson:"title" validate:"required"`
	CreatedAt          time.Time                     `bson:"createdAt" validate:"required"`
	UpdatedAt          time.Time                     `bson:"updatedAt" validate:"required"`
	InitialDate        time.Time                     `bson:"initialDate" validate:"required"`
	FinalDate          time.Time                     `bson:"finalDate" validate:"required"`
	Description        string                        `bson:"description" validate:"required"`
	MultimediaElements []DenouncementMultimediaModel `bson:"multimediaElements" validate:"required"`
	Comments           []CommentModel                `bson:"comments" validate:"required"`
}

type DenouncementMultimediaModel struct {
	Description string    `bson:"description" validate:"required"`
	SubmitedAt  time.Time `bson:"submited" validate:"required"`
	Uri         string    `bson:"uri" validate:"required"`
}

type CommentModel struct {
	ID        primitive.ObjectID     `bson:"_id" validate:"required"`
	AuthorID  primitive.ObjectID     `bson:"authorId" validate:"required"`
	Content   string                 `bson:"content" validate:"required"`
	CreatedAt time.Time              `bson:"createdAt" validate:"required"`
	Reactions []CommentReactionModel `bson:"reactions" validate:"required"`
	Responses []ResponseModel        `bson:"responses" validate:"required"`
}

type CommentReactionModel struct {
	Type      string             `bson:"type" validate:"required"`
	AuthorID  primitive.ObjectID `bson:"authorId" validate:"required"`
	CreatedAt time.Time          `bson:"createdAt" validate:"required"`
}

type ResponseModel struct {
	ID        primitive.ObjectID      `bson:"_id" validate:"required"`
	AuthorID  primitive.ObjectID      `bson:"authorId" validate:"required"`
	Content   string                  `bson:"content" validate:"required"`
	CreatedAt time.Time               `bson:"createdAt" validate:"required"`
	Reactions []ResponseReactionModel `bson:"reactions" validate:"required"`
}

type ResponseReactionModel struct {
	Type      string             `bson:"type" validate:"required"`
	AuthorID  primitive.ObjectID `bson:"authorId" validate:"required"`
	CreatedAt time.Time          `bson:"createdAt" validate:"required"`
}
