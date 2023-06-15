package ecorecovery

import "time"

type EcorecoveryWorkshopDetails struct {
	AuthorID     string    `json:"author_id" validate:"required"`
	Title        string    `json:"title" validate:"required"`
	CreatedAt    time.Time `json:"created_at" validate:"required"`
	UpdatedAt    time.Time `json:"updated_at" validate:"required"`
	Date         time.Time `json:"date" validate:"required"`
	StartTime    time.Time `json:"start_time" validate:"required"`
	EndTime      time.Time `json:"end_time" validate:"required"`
	MeetupPoint  string    `json:"meetup_point" validate:"required"`
	Description  string    `json:"description" validate:"required"`
	Organizers   []string  `json:"organizers" validate:"required"`
	Instructions []string  `json:"instructions" validate:"required"`
	Objectives   []string  `json:"objectives" validate:"required"`
}
