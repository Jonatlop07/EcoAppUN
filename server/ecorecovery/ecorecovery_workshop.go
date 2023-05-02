package ecorecovery

import "time"

type EcorecoveryWorkshop struct {
	ID           string        `bson:"_id" json:"id"`
	Title        string        `bson:"title" json:"title"`
	CreatedAt    time.Time     `bson:"createdAt" json:"created_at"`
	UpdatedAt    time.Time     `bson:"updatedAt" json:"updated_at"`
	StartTime    time.Time     `bson:"startTime" json:"start_time"`
	EndTime      time.Time     `bson:"endTime" json:"end_time"`
	MeetupPoint  string        `bson:"meetupPoint" json:"meetup_point"`
	Description  string        `bson:"description" json:"description"`
	Organizers   []string      `bson:"organizers" json:"organizers"`
	Attendees    []string      `bson:"attendees" json:"attendees"`
	Instructions []Instruction `bson:"instructions" json:"instructions"`
	Objectives   []Objective   `bson:"objectives" json:"objectives"`
}

type Instruction struct {
	ID          string `bson:"_id" json:"id"`
	Description string `bson:"description" json:"description"`
	Sequence    int    `bson:"sequence" json:"sequence"`
}

type Objective struct {
	ID          string `bson:"_id" json:"id"`
	Description string `bson:"description" json:"description"`
	Sequence    int    `bson:"sequence" json:"sequence"`
	IsAchieved  bool   `bson:"isAchieved" json:"is_achieved"`
}
