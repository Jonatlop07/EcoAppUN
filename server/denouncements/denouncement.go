package denouncement

import "time"

type Denouncement struct {
	ID          string    `bson:"_id" json:"id"`
	DenouncerID string    `bson:"denouncerId" json:"denouncer_id"`
	Title       string    `bson:"title" json:"title"`
	CreatedAt   time.Time `bson:"createdAt" json:"created_at"`
	UpdatedAt   time.Time `bson:"updatedAt" json:"updated_at"`
	InitialDate time.Time `bson:"initialDate" json:"initial_date"`
	FinalDate   time.Time `bson:"finalDate" json:"final_date"`
	Description string    `bson:"description" json:"description"`
	MediaLinks  []string  `bson:"mediaLinks" json:"media_links"`
	Comments    []Comment `bson:"comments" json:"comments"`
}

type Comment struct {
	ID             string            `bson:"_id" json:"id"`
	DenouncementID string            `bson:"denouncementId" json:"denouncement_id"`
	AuthorID       string            `bson:"authorId" json:"author_id"`
	Content        string            `bson:"content" json:"content"`
	CreatedAt      time.Time         `bson:"createdAt" json:"created_at"`
	Reactions      []CommentReaction `bson:"reactions" json:"reactions"`
}

type CommentReaction struct {
	ID             string    `bson:"_id" json:"id"`
	DenouncementID string    `bson:"denouncementId" json:"denouncement_id"`
	CommentID      string    `bson:"commentId" json:"comment_id"`
	Type           string    `bson:"type" json:"type"`
	UserID         string    `bson:"userId" json:"user_id"`
	CreatedAt      time.Time `bson:"createdAt" json:"created_at"`
}

type Response struct {
	ID             string             `bson:"_id" json:"id"`
	DenouncementID string             `bson:"denouncementId" json:"denouncement_id"`
	CommentID      string             `bson:"commentId" json:"comment_id"`
	AuthorID       string             `bson:"authorId" json:"author_id"`
	Content        string             `bson:"content" json:"content"`
	CreatedAt      time.Time          `bson:"createdAt" json:"created_at"`
	Reactions      []ResponseReaction `bson:"reactions" json:"reactions"`
}

type ResponseReaction struct {
	ID             string    `bson:"_id" json:"id"`
	DenouncementID string    `bson:"denouncementId" json:"denouncement_id"`
	CommentID      string    `bson:"commentId" json:"comment_id"`
	ResponseID     string    `bson:"responseId" json:"response_id"`
	Type           string    `bson:"type" json:"type"`
	UserID         string    `bson:"userId" json:"user_id"`
	CreatedAt      time.Time `bson:"createdAt" json:"created_at"`
}
