package sowing

import "time"

type SowingWorkshop struct {
	ID           string      `bson:"_id" json:"id"`
	AuthorID     string      `bson:"authorId" json:"author_id"`
	Title        string      `bson:"title" json:"title"`
	CreatedAt    time.Time   `bson:"createdAt" json:"created_at"`
	UpdatedAt    time.Time   `bson:"updatedAt" json:"updated_at"`
	Date         time.Time   `bson:"date" json:"date"`
	StartTime    time.Time   `bson:"startTime" json:"start_time"`
	EndTime      time.Time   `bson:"endTime" json:"end_time"`
	MeetupPoint  string      `bson:"meetupPoint" json:"meetup_point"`
	Description  string      `bson:"description" json:"description"`
	Organizers   []string    `bson:"organizers" json:"organizers"`
	Attendees    []Attendee  `bson:"attendees" json:"attendees"`
	Instructions []string    `bson:"instructions" json:"instructions"`
	Seeds        []Seed      `bson:"seeds" json:"seeds"`
	Objectives   []Objective `bson:"objectives" json:"objectives"`
}

type Attendee struct {
	ID    string `bson:"_id" json:"id"`
	Seeds []Seed `bson:"seeds" json:"seeds"`
}

type Seed struct {
	ID              string `bson:"_id" json:"id"`
	Description     string `bson:"description" json:"description"`
	ImageLink       string `bson:"imageLink" json:"image_link"`
	AvailableAmount int    `bson:"availableAmount" json:"available_amount"`
}

type Objective struct {
	Description string `bson:"description" json:"description"`
	IsAchieved  bool   `bson:"isAchieved" json:"is_achieved"`
}
