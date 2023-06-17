package blog

import "time"

type Article struct {
	ID         string            `json:"id" validate:"required"`
	AuthorID   string            `json:"author_id" validate:"required"`
	Title      string            `json:"title" validate:"required"`
	CreatedAt  time.Time         `json:"created_at" validate:"required"`
	UpdatedAt  time.Time         `json:"updated_at" validate:"required"`
	Content    string            `json:"content" validate:"required"`
	Categories []string          `json:"categories" validate:"required"`
	Reactions  []ArticleReaction `json:"reactions" validate:"required"`
	Comments   []Comment         `json:"comments" validate:"required"`
}

type ArticleReaction struct {
	AuthorID  string    `json:"author_id" validate:"required"`
	Type      string    `json:"type" validate:"required"`
	CreatedAt time.Time `json:"created_at" validate:"required"`
}

type Comment struct {
	ID        string            `json:"id" validate:"required"`
	AuthorID  string            `json:"author_id" validate:"required"`
	Content   string            `json:"content" validate:"required"`
	CreatedAt time.Time         `json:"created_at" validate:"required"`
	Reactions []CommentReaction `json:"reactions" validate:"required"`
}

type CommentReaction struct {
	AuthorID  string    `json:"author_id" validate:"required"`
	Type      string    `json:"type" validate:"required"`
	CreatedAt time.Time `json:"created_at" validate:"required"`
}
