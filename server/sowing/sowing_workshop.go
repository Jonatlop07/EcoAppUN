package sowing

import "time"

type SowingWorkshop struct {
	ID           string        `bson:"_id" json:"id"`
	Title        string        `bson:"title" json:"title"`
	CreatedAt    time.Time     `bson:"createdAt" json:"created_at"`
	UpdatedAt    time.Time     `bson:"updatedAt" json:"updated_at"`
	StartTime    time.Time     `bson:"startTime" json:"start_time"`
	EndTime      time.Time     `bson:"endTime" json:"end_time"`
	MeetupPoint  string        `bson:"meetupPoint" json:"meetup_point"`
	Description  string        `bson:"description" json:"description"`
	Organizers   []string      `bson:"organizers" json:"organizers"`
	Attendees    []Attendee    `bson:"attendees" json:"attendees"`
	Instructions []Instruction `bson:"instructions" json:"instructions"`
	Seeds        []Seed        `bson:"seeds" json:"seeds"`
	Objectives   []Objective   `bson:"objectives" json:"objectives"`
}

type Attendee struct {
	ID               string `bson:"_id" json:"id"`
	SowingWorkshopID string `bson:"sowingWorkshopId" json:"sowing_workshop_id"`
	Seeds            []Seed `bson:"seeds" json:"seeds"`
}

type Instruction struct {
	ID          string `bson:"_id" json:"id"`
	Description string `bson:"description" json:"description"`
	Sequence    int    `bson:"sequence" json:"sequence"`
}

type Seed struct {
	ID              string `bson:"_id" json:"id"`
	Description     string `bson:"description" json:"description"`
	ImageLink       string `bson:"imageLink" json:"image_link"`
	AvailableAmount int    `bson:"availableAmount" json:"available_amount"`
}

type Objective struct {
	ID          string `bson:"_id" json:"id"`
	Description string `bson:"description" json:"description"`
	Sequence    int    `bson:"sequence" json:"sequence"`
	IsAchieved  bool   `bson:"isAchieved" json:"is_achieved"`
}
