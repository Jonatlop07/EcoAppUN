package ecotour

import "time"

type Ecotour struct {
	ID           string    `bson:"_id" json:"id"`
	Title        string    `bson:"title" json:"title"`
	CreatedAt    time.Time `bson:"createdAt" json:"created_at"`
	UpdatedAt    time.Time `bson:"updatedAt" json:"updated_at"`
	StartTime    time.Time `bson:"startTime" json:"start_time"`
	EndTime      time.Time `bson:"endTime" json:"end_time"`
	MeetingPoint string    `bson:"meetingPoint" json:"meeting_point"`
	Description  string    `bson:"description" json:"description"`
	Organizers   []string  `bson:"organizers" json:"organizers"`
	Attendees    []string  `bson:"attendees" json:"attendees"`
}
