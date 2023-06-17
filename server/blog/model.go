package blog

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

type ArticleModel struct {
	ID         primitive.ObjectID     `bson:"id" validate:"required"`
	AuthorID   primitive.ObjectID     `bson:"authorId" validate:"required"`
	Title      string                 `bson:"title" validate:"required"`
	CreatedAt  time.Time              `bson:"createdAt" validate:"required"`
	UpdatedAt  time.Time              `bson:"updatedAt" validate:"required"`
	Content    string                 `bson:"content" validate:"required"`
	Categories []string               `bson:"categories" validate:"required"`
	Reactions  []ArticleReactionModel `bson:"reactions" validate:"required"`
	Comments   []CommentModel         `bson:"comments" validate:"required"`
}

type ArticleReactionModel struct {
	AuthorID  primitive.ObjectID `bson:"authorId" validate:"required"`
	Type      string             `bson:"type" validate:"required"`
	CreatedAt time.Time          `bson:"createdAt" validate:"required"`
}

type CommentModel struct {
	ID        primitive.ObjectID     `bson:"id" validate:"required"`
	AuthorID  primitive.ObjectID     `bson:"authorId" validate:"required"`
	Content   string                 `bson:"content" validate:"required"`
	CreatedAt time.Time              `bson:"createdAt" validate:"required"`
	Reactions []CommentReactionModel `bson:"reactions" validate:"required"`
}

type CommentReactionModel struct {
	AuthorID  primitive.ObjectID `bson:"authorId" validate:"required"`
	Type      string             `bson:"type" validate:"required"`
	CreatedAt time.Time          `bson:"createdAt" validate:"required"`
}
