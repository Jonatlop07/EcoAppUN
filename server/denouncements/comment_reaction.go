package denouncement

import "time"

type CommentReaction struct {
	ID             string    `bson:"_id" json:"id"`
	DenouncementID string    `bson:"denouncementId" json:"denouncement_id"`
	CommentID      string    `bson:"commentId" json:"comment_id"`
	Type           string    `bson:"type" json:"type"`
	UserID         string    `bson:"userId" json:"user_id"`
	CreatedAt      time.Time `bson:"createdAt" json:"created_at"`
}
