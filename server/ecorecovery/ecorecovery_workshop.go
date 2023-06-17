package ecorecovery

import "time"

type EcorecoveryWorkshop struct {
	ID           string      `json:"id" validate:"required"`
	AuthorID     string      `json:"author_id" validate:"required"`
	Title        string      `json:"title" validate:"required"`
	CreatedAt    time.Time   `json:"created_at" validate:"required"`
	UpdatedAt    time.Time   `json:"updated_at" validate:"required"`
	Date         time.Time   `json:"date" validate:"required"`
	StartTime    time.Time   `json:"start_time" validate:"required"`
	EndTime      time.Time   `json:"end_time" validate:"required"`
	MeetupPoint  string      `json:"meetup_point" validate:"required"`
	Description  string      `json:"description" validate:"required"`
	Organizers   []string    `json:"organizers" validate:"required"`
	Attendees    []string    `json:"attendees" validate:"required"`
	Instructions []string    `json:"instructions" validate:"required"`
	Objectives   []Objective `json:"objectives" validate:"required"`
}

type Objective struct {
	Description string `json:"description" validate:"required"`
	IsAchieved  bool   `json:"is_achieved" validate:"required"`
}
