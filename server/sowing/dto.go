package sowing

import "time"

type SowingWorkshopDetails struct {
	AuthorID     string        `bson:"authorId" json:"author_id"`
	Title        string        `bson:"title" json:"title"`
	Date         time.Time     `bson:"date" json:"date"`
	StartTime    time.Time     `bson:"startTime" json:"start_time"`
	EndTime      time.Time     `bson:"endTime" json:"end_time"`
	Description  string        `bson:"description" json:"description"`
	MeetupPoint  string        `bson:"meetupPoint" json:"meetup_point"`
	Organizers   []string      `bson:"organizers" json:"organizers"`
	Instructions []string      `bson:"instructions" json:"instructions"`
	Seeds        []SeedDetails `bson:"seeds" json:"seeds"`
	Objectives   []string      `bson:"objectives" json:"objectives"`
}

type SeedDetails struct {
	Description     string `bson:"description" json:"description"`
	ImageLink       string `bson:"imageLink" json:"image_link"`
	AvailableAmount int    `bson:"availableAmount" json:"available_amount"`
}
