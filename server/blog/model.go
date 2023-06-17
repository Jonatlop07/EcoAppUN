package blog

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

type ArticleModel struct {
	ID         primitive.ObjectID     `bson:"id"`
	AuthorID   primitive.ObjectID     `bson:"authorId"`
	Title      string                 `bson:"title"`
	CreatedAt  time.Time              `bson:"createdAt"`
	UpdatedAt  time.Time              `bson:"updatedAt"`
	Content    string                 `bson:"content"`
	Categories []string               `bson:"categories"`
	Reactions  []ArticleReactionModel `bson:"reactions"`
	Comments   []CommentModel         `bson:"comments"`
}

type ArticleReactionModel struct {
	AuthorID  primitive.ObjectID `bson:"authorId"`
	Type      string             `bson:"type"`
	CreatedAt time.Time          `bson:"createdAt"`
}

type CommentModel struct {
	ID        primitive.ObjectID     `bson:"id"`
	AuthorID  primitive.ObjectID     `bson:"authorId"`
	Content   string                 `bson:"content"`
	CreatedAt time.Time              `bson:"createdAt"`
	Reactions []CommentReactionModel `bson:"reactions"`
}

type CommentReactionModel struct {
	AuthorID  primitive.ObjectID `bson:"authorId"`
	Type      string             `bson:"type"`
	CreatedAt time.Time          `bson:"createdAt"`
}
