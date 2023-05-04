package blog

import "time"

type Article struct {
	ID        string             `bson:"id" json:"id"`
	AuthorID  string             `bson:"authorId" json:"author_id"`
	CreatedAt time.Time          `bson:"createdAt" json:"created_at"`
	UpdatedAt time.Time          `bson:"updatedAt" json:"updated_at"`
	Content   string             `bson:"content" json:"content"`
	Category  string             `bson:"category" json:"category"`
	Reactions []*ArticleReaction `bson:"reactions" json:"reactions"`
	Comments  []*Comment         `bson:"comments" json:"comments"`
}

type ArticleReaction struct {
	ID        string `bson:"id" json:"id"`
	UserID    string `bson:"userId" json:"user_id"`
	Type      string `bson:"type" json:"type"`
	ArticleID string `bson:"articleId" json:"article_id"`
}

type Comment struct {
	ID        string             `bson:"id" json:"id"`
	ArticleID string             `bson:"articleId" json:"article_id"`
	AuthorID  string             `bson:"authorId" json:"author_id"`
	Content   string             `bson:"content" json:"content"`
	CreatedAt time.Time          `bson:"createdAt" json:"created_at"`
	Reactions []*CommentReaction `bson:"reactions" json:"reactions"`
}

type CommentReaction struct {
	ID        string `bson:"id" json:"id"`
	UserID    string `bson:"userId" json:"user_id"`
	Type      string `bson:"type" json:"type"`
	CommentID string `bson:"commentId" json:"comment_id"`
}
