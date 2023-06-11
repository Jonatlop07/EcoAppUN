package ecorecovery

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

type EcorecoveryWorkshopModel struct {
	ID           primitive.ObjectID   `bson:"_id" json:"id"`
	AuthorID     primitive.ObjectID   `bson:"authorId" json:"author_id"`
	Title        string               `bson:"title" json:"title"`
	CreatedAt    time.Time            `bson:"createdAt" json:"created_at"`
	UpdatedAt    time.Time            `bson:"updatedAt" json:"updated_at"`
	Date         time.Time            `bson:"date" json:"date"`
	StartTime    time.Time            `bson:"startTime" json:"start_time"`
	EndTime      time.Time            `bson:"endTime" json:"end_time"`
	MeetupPoint  string               `bson:"meetupPoint" json:"meetup_point"`
	Description  string               `bson:"description" json:"description"`
	Organizers   []primitive.ObjectID `bson:"organizers" json:"organizers"`
	Attendees    []primitive.ObjectID `bson:"attendees" json:"attendees"`
	Instructions []string             `bson:"instructions" json:"instructions"`
	Objectives   []Objective          `bson:"objectives" json:"objectives"`
}

type ObjectiveModel struct {
	Description string `bson:"description" json:"description"`
	IsAchieved  bool   `bson:"isAchieved" json:"is_achieved"`
}
