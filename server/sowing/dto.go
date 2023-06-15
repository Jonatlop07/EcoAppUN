package sowing

import "time"

type SowingWorkshopDetails struct {
	AuthorID     string        `json:"author_id" validate:"required"`
	Title        string        `json:"title" validate:"required"`
	Date         time.Time     `json:"date" validate:"required"`
	StartTime    time.Time     `json:"start_time" validate:"required"`
	EndTime      time.Time     `json:"end_time" validate:"required"`
	Description  string        `json:"description" validate:"required"`
	MeetupPoint  string        `json:"meetup_point" validate:"required"`
	Organizers   []string      `json:"organizers" validate:"required"`
	Instructions []string      `json:"instructions" validate:"required"`
	Seeds        []SeedDetails `json:"seeds" validate:"required"`
	Objectives   []string      `json:"objectives" validate:"required"`
}

type SeedDetails struct {
	Description     string `json:"description" validate:"required"`
	ImageLink       string `json:"image_link" validate:"required"`
	AvailableAmount int    `json:"available_amount" validate:"required"`
}
