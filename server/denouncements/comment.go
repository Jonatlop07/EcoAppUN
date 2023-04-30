package denouncement

import "time"

type Comment struct {
	ID             string
	DenouncementID string
	AuthorID       string
	Content        string
	CreatedAt      time.Time
}
