package ecotour

import "time"

type EcotourDetails struct {
	AuthorID    string    `json:"author_id" validate:"required"`
	Title       string    `json:"title" validate:"required"`
	Date        time.Time `json:"date" validate:"required"`
	StartTime   time.Time `json:"start_time" validate:"required"`
	EndTime     time.Time `json:"end_time" validate:"required"`
	MeetupPoint string    `json:"meetup_point" validate:"required"`
	Description string    `json:"description" validate:"required"`
	Organizers  []string  `json:"organizers" validate:"required"`
}
