package blog

type ArticleDetails struct {
	AuthorID   string   `json:"author_id" validate:"required"`
	Title      string   `json:"title" validate:"required"`
	Content    string   `json:"content" validate:"required"`
	Categories []string `json:"categories" validate:"required"`
}

type ArticleReactionDetails struct {
	AuthorID string `json:"author_id" validate:"required"`
	Type     string `json:"type" validate:"required"`
}

type CommentDetails struct {
	AuthorID string `json:"author_id" validate:"required"`
	Content  string `json:"content" validate:"required"`
}

type CommentReactionDetails struct {
	AuthorID string `json:"author_id" validate:"required"`
	Type     string `json:"type" validate:"required"`
}

type CommentIdentifiersDTO struct {
	ArticleID string `validate:"required"`
	CommentID string `validate:"required"`
}
