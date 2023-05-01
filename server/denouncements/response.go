package denouncement

import "time"

type Response struct {
	ID             string             `bson:"_id" json:"id"`
	DenouncementID string             `bson:"denouncementId" json:"denouncement_id"`
	CommentID      string             `bson:"commentId" json:"comment_id"`
	AuthorID       string             `bson:"authorId" json:"author_id"`
	Content        string             `bson:"content" json:"content"`
	CreatedAt      time.Time          `bson:"createdAt" json:"created_at"`
	Reactions      []ResponseReaction `bson:"reactions" json:"reactions"`
}
