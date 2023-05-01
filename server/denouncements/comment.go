package denouncement

import "time"

type Comment struct {
	ID             string            `bson:"_id" json:"id"`
	DenouncementID string            `bson:"denouncementId" json:"denouncement_id"`
	AuthorID       string            `bson:"authorId" json:"author_id"`
	Content        string            `bson:"content" json:"content"`
	CreatedAt      time.Time         `bson:"createdAt" json:"created_at"`
	Reactions      []CommentReaction `bson:"reactions" json:"reactions"`
}
