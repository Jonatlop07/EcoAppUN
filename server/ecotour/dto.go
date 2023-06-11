package ecotour

import "time"

type EcotourDetails struct {
	AuthorID    string    `bson:"authorId" json:"author_id"`
	Title       string    `bson:"title" json:"title"`
	CreatedAt   time.Time `bson:"createdAt" json:"created_at"`
	UpdatedAt   time.Time `bson:"updatedAt" json:"updated_at"`
	Date        time.Time `bson:"date" json:"date"`
	StartTime   time.Time `bson:"startTime" json:"start_time"`
	EndTime     time.Time `bson:"endTime" json:"end_time"`
	MeetupPoint string    `bson:"meetupPoint" json:"meetup_point"`
	Description string    `bson:"description" json:"description"`
	Organizers  []string  `bson:"organizers" json:"organizers"`
}
